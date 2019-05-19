//
//  PlantSearchTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PlantSearchTableViewController: UITableViewController {
    
    //MARK: Filter attribute
    enum CategoryID: String {
        case vegetable
        case herb
    }
    
    enum PlantLocationID: String {
        case indoor
        case outdoor
    }
    
    enum SegueID: String {
        case filterSegue
        case filterUnwindSegue
        case viewDetailFromSearch
        case ComparisonSegue
        case compareToSearchSegue
        case detailToSearchSegue
    }
    
    enum sortMethod: String {
        case alphabetic
        case harvestTime
        case spacing
    }
    
    //MARK: Variable
    var filter: Filter?
    var originalPlants = [Plant]()
    var filterPlants = [Plant]()
    var networkHandler = NetworkHandler()
    var user: User!
    let plantTableUI = SearchPlantUI()
    let localData = LocalData()
    
    //Keep tracking order
    var ascending =  true
    
    //Button for comparison
    let compareButton = SearchPlantUI().filterBottomButton()
    var showSelectedCompareList = false
    
    //Search bar properites
    var searchPlants = [Plant]()
    let searchController = UISearchController(searchResultsController: nil)
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    //Check if is compare mode
    var compareMode = false
    var compareList = [Plant]()
    
    //Show selected list button
    @IBOutlet weak var showSelected: UIBarButtonItem!
    
    //Filter button
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    //Plants properites to handle change
    var plants: [Plant] {
        
        if showSelectedCompareList {
            return compareList
        } else if isFiltering() {
            return searchPlants
        } else if filterApplied {
            return filterPlants
        }
        
        return originalPlants
    }
    
    var filterApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if filter == nil {
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,200,0,200,["All"],sortMethod.alphabetic.rawValue])
        }
        
        if user == nil {
            user = delegate.user
//            originalPlants = delegate.plants
        }
        
        if originalPlants.isEmpty {
            requestPlantData()
        }
        
        setUpAppearance()
        setUpSearchBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        compareButtonAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        compareButton.isHidden = true
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if originalPlants.isEmpty {
            return 10
        }
        
        if plants.count == 0 {
            return 1
        }
        
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        //Loading plant
        if originalPlants.isEmpty {
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
            guard let uiCell = plantTableUI.loadingSearchPlantCell(cell) as? SearchPlantTableViewCell else {fatalError()}
            
            return uiCell
        } else if plants.isEmpty {
            guard let noResultCell = tableView.dequeueReusableCell(withIdentifier: "NoResultCell", for: indexPath) as? NoResultTableViewCell else {fatalError()}
            let searchText = searchController.searchBar.text ?? "the plant"
            noResultCell.selectionStyle = .none
            noResultCell.backgroundColor = .clear
            noResultCell.noResultLabel.text = "Sorry we can't find \(searchText)"
            if searchText.isEmpty {
                noResultCell.noResultLabel.text = "Sorry we can't find anything with the input filter"
            }
            
            if showSelectedCompareList && compareList.isEmpty{
                noResultCell.noResultLabel.text = "You didn't select any plants for compare yet"
            }
            
            cell = noResultCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
            let plant = plants[indexPath.row]
            
            guard let uiCell = plantTableUI.searchPlantCell(cell, plant: plant) as? SearchPlantTableViewCell else {fatalError()}
            
            //Add long press gesture recognizer
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressCompare(_:)))
            uiCell.addGestureRecognizer(recognizer)
            
            //Update plus button to show exist
            if plantIsExist(plant) {
                uiCell.plusButton.setImage(UIImage(named: "inFarm"), for: .normal)
            } else {
                uiCell.plusButton.setImage(UIImage(named: "plus"), for: .normal)
            }
            
            uiCell.plusButton.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
            uiCell.plusButton.tag =  indexPath.row
            
            uiCell.compareCheck.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
            uiCell.compareCheck.tag = indexPath.row
            
            //Change plus button if is compare mode
            if compareMode {
                uiCell.isCompare(true)
                uiCell.plusButton.isHidden = true
                uiCell.compareCheck.isHidden = false
            } else {
                uiCell.isCompare(false)
                uiCell.compareCheck.isHidden = true
                uiCell.plusButton.isHidden = false
            }
            
            //Update check box selection
            if compareMode {
                let names = compareList.map({ (plant) -> String in
                    return plant.cropName
                })

                if names.contains(plant.cropName) {
                    uiCell.compareCheck.isSelected = true
                } else {
                    uiCell.compareCheck.isSelected = false
                }
            }
            
            cell = uiCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !compareMode {
            performSegue(withIdentifier: SegueID.viewDetailFromSearch.rawValue, sender: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchPlantTableViewCell else {fatalError()}
            cell.compareCheck.tag = indexPath.row
            checkAction(cell.compareCheck)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: Main functions
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category, let location = filter?.location, let minSpacing = filter?.minSpacing, let maxSpacing = filter?.maxSpacing, let minHarvest = filter?.minHarvest, let maxHarvest = filter?.maxHarvest, let months = filter?.month, let sort = filter?.sort else {return}
        
        filterPlants = originalPlants.filter({ (plant : Plant) -> Bool in
            return (category.contains(plant.plantCategory.lowercased()) || plant.plantCategory.lowercased() == "both") && (location.contains(plant.plantStyle.lowercased()) || plant.plantStyle.lowercased() == "both") && minSpacing <= plant.maxSpacing && plant.maxSpacing <= maxSpacing && minHarvest <= plant.maxHarvestTime && plant.maxHarvestTime <= maxHarvest
        })
        
        //Filter based on month
        var monthFilterPlants = [Plant]()
        if months[0].lowercased() != "all" {
            
            //Get rid of the invalid months plant
            for plant in filterPlants {
                
                //Get prefix of plant months
                let plantMonths = plant.getSuitableMonth.map { (month) -> String in
                    return month.prefix(3).lowercased()
                }
                
                //If the plant within month range set in range true
                var inRange = false
                for month in months {
                    if plantMonths.contains(month.lowercased()) {
                        inRange = true
                    }
                }
                
                //If not in range remove plant
                if inRange {
                    monthFilterPlants.append(plant)
                }
            }
            
            filterPlants = monthFilterPlants
        }
        
        //Sort plants list
        switch sort {
        case sortMethod.alphabetic.rawValue:
            filterPlants.sort { (plant1, plant2) -> Bool in
                return plant1.cropName < plant2.cropName
            }
            
        case sortMethod.harvestTime.rawValue:
            filterPlants.sort { (plant1, plant2) -> Bool in
                if plant1.minHarvestTime == plant2.minHarvestTime {
                    return plant1.maxHarvestTime <= plant2.maxHarvestTime
                }
                return plant1.minHarvestTime <= plant2.minHarvestTime
            }
            
        case sortMethod.spacing.rawValue:
            filterPlants.sort { (plant1, plant2) -> Bool in
                if plant1.minSpacing == plant2.minSpacing {
                    return plant1.maxSpacing <= plant2.maxSpacing
                }
                return plant1.minSpacing <= plant2.minSpacing
            }
            
        default: break
        }
        
        print(filterPlants.count)
        filterApplied = true
        tableView.reloadData()
    }
    
    // MARK: Search bar functions
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if filterApplied {
            searchPlants = filterPlants.filter({( plant : Plant) -> Bool in
                return plant.cropName.lowercased().contains(searchText.lowercased())
            })
        } else {
            searchPlants = originalPlants.filter({( plant : Plant) -> Bool in
                return plant.cropName.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    // Search bar update view method
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // Private instance methods for search bar
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Private function check if plant exist in my farm
    private func plantIsExist(_ plant: Plant) -> Bool {
        var exist = false
        
        if !user.farmPlants.isEmpty {
            for i in user.farmPlants {
                if i.cropName == plant.cropName {
                    exist = true
                }
            }
        }
        
        return exist
    }
    
    //Button animation
    private func compareButtonAppear() {
        UIView.animate(withDuration: 0.5) {
            self.compareButton.isHidden = false
            self.compareButton.alpha = 0
            self.compareButton.alpha = 1
        }
    }
    
    // MARK: Action handle functions
    // Long press gesture action
    @objc private func longPressCompare(_ sender: UILongPressGestureRecognizer) {
        if !compareMode {
            compareAction(sender)
        }
    }
    
    //Add lant action
    @objc private func addPlant(_ sender: UIButton) {
        
        let plant = plants[sender.tag]
        
        if plantIsExist(plant) {
            uiAlert(plant.cropName, alertIndex: 0)
        } else {
            let newPlant = plant.copy() as! Plant
            user.farmPlants.insert(newPlant, at: 0)
            localData.saveUserInfo(user)
            uiAlert(plant.cropName, alertIndex: 1)
        }
    }
    
    //Comparison check box
    @objc private func checkAction(_ sender: UIButton) {
        selectForComparison(sender)
    }
    
    //Select plants for comparison action
    private func selectForComparison(_ sender: UIButton) {
        
        let maxPlant = 3
        
        if showSelectedCompareList {
            
            compareList.remove(at: sender.tag)
            tableView.reloadData()
            return
            
        }
        
        //Happen when it is not show selected plants mode
        if !sender.isSelected {
            //Check if list is full
            if compareList.count < maxPlant {
                sender.isSelected = true
                compareList.append(plants[sender.tag])
                
                //Testing code
                print("add to checklist")
                print(compareList.map({ (plant) -> String in
                    return plant.cropName
                }))
                
            } else {
                comparisonAlert(1)
            }
            
        } else {
            sender.isSelected = false
            let deselectPlant = plants[sender.tag].cropName
            
            //Search for the plant to remove
            var position = 0
            for (index,plant) in compareList.enumerated() {
                if plant.cropName == deselectPlant {
                    position = index
                }
            }
            
            compareList.remove(at: position)
            
            //Testing code
            print("remove from checklist")
            print(compareList.map({ (plant) -> String in
                return plant.cropName
            }))
        }
        
        //Update the compare button appearance
        if compareList.count > 1 {
            compareButton.tintColor = .white
        } else {
            compareButton.tintColor = .lightText
        }
        
    }
    
    //Show selected plants
    @IBAction func showSelectedPlants(_ sender: UIBarButtonItem) {
        
        if compareMode {
            print("show selected plants")
            //check if compare list has any plant
            if showSelectedCompareList {
                showSelectedCompareList = false
                showSelected.title = "Show selected plants"
                
                tableView.reloadData()
            } else if compareList.isEmpty {
                comparisonAlert(2)
            } else if !showSelectedCompareList {
                showSelectedCompareList = true
                showSelected.title = "Back to search"
                
                tableView.reloadData()
            }
            
            print("show selected plants")
        } else {
            print("sorting")
            
            //Change button icon
            ascending = !ascending
            if ascending {
                showSelected.image = UIImage(named: "ascendingOrder")
            } else {
                showSelected.image = UIImage(named: "descendingOrder")
            }
            
            //If ascending sort to descending
            switch filter?.sort {
            case sortMethod.alphabetic.rawValue:
                //Sort if is ascending order with alphabetic
                if ascending {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            return plant1.cropName < plant2.cropName
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            return plant1.cropName < plant2.cropName
                        }
                    }
                } else {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            return plant1.cropName > plant2.cropName
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            return plant1.cropName > plant2.cropName
                        }
                    }
                }
                
            case sortMethod.harvestTime.rawValue:
                //Sort if is ascending order with harvest time
                if ascending {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minHarvestTime == plant2.minHarvestTime {
                                return plant1.maxHarvestTime <= plant2.maxHarvestTime
                            }
                            return plant1.minHarvestTime <= plant2.minHarvestTime
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minHarvestTime == plant2.minHarvestTime {
                                return plant1.maxHarvestTime <= plant2.maxHarvestTime
                            }
                            return plant1.minHarvestTime <= plant2.minHarvestTime
                        }
                    }
                } else {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minHarvestTime == plant2.minHarvestTime {
                                return plant1.maxHarvestTime >= plant2.maxHarvestTime
                            }
                            return plant1.minHarvestTime >= plant2.minHarvestTime
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minHarvestTime == plant2.minHarvestTime {
                                return plant1.maxHarvestTime >= plant2.maxHarvestTime
                            }
                            return plant1.minHarvestTime >= plant2.minHarvestTime
                        }
                    }
                }
                
                
            case sortMethod.spacing.rawValue:
                //Sort if is ascending with spacing
                if ascending {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minSpacing == plant2.minSpacing {
                                return plant1.maxSpacing <= plant2.maxSpacing
                            }
                            return plant1.minSpacing <= plant2.minSpacing
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minSpacing == plant2.minSpacing {
                                return plant1.maxSpacing <= plant2.maxSpacing
                            }
                            return plant1.minSpacing <= plant2.minSpacing
                        }
                    }
                } else {
                    if filterApplied {
                        filterPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minSpacing == plant2.minSpacing {
                                return plant1.maxSpacing >= plant2.maxSpacing
                            }
                            return plant1.minSpacing >= plant2.minSpacing
                        }
                    } else {
                        originalPlants.sort { (plant1, plant2) -> Bool in
                            if plant1.minSpacing == plant2.minSpacing {
                                return plant1.maxSpacing >= plant2.maxSpacing
                            }
                            return plant1.minSpacing >= plant2.minSpacing
                        }
                    }
                }
                
            default: break
            }
            
            tableView.reloadData()
        }
        
    }
    
    //Compare button action
    @objc func compareAction(_ sender: Any) {
        //Show compare selected list
        //check if is compare mode
        if !compareMode {
            compareMode = true
            compareButton.setTitle("Compare Now", for: .normal)
            //Set filter button to be cancel button
            filterButton.title = "Cancel"
            filterButton.image = nil
            
            //Set navbar title
            navigationItem.title = ""
            
            //Set show select button
            showSelected.title = "Show selected plants"
            showSelected.image = nil
            
            tableView.reloadData()
        } else if compareList.count <= 1 {
            comparisonAlert(0)
        } else if compareList.count > 1 {
            //If comparison list got 3 plant compare
            compareButton.isHidden = true
            performSegue(withIdentifier: SegueID.ComparisonSegue.rawValue, sender: self)
        }
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        //check if is under compare mode
        if compareMode {
            endCompareMode()
        } else {
            performSegue(withIdentifier: SegueID.filterSegue.rawValue, sender: self)
        }
    }
    
    //End compare mode method
    private func endCompareMode() {
        compareMode = false
        compareButton.setTitle("Compare plants", for: .normal)
        
        filterButton.title = ""
        filterButton.image = UIImage(named: "filterIcon")
        compareList = []
        
        print("Change")
        navigationItem.title = "Plant search"
        
        //Change show selected button title
        showSelected.title = ""
        if ascending {
            showSelected.image = UIImage(named: "ascendingOrder")
        } else {
            showSelected.image = UIImage(named: "descendingOrder")
        }
        
        showSelectedCompareList = false
        
        tableView.reloadData()
    }
    
}

//MARK: Navigations
extension PlantSearchTableViewController {
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
            
        case SegueID.filterSegue.rawValue:
            guard let nv = segue.destination as? UINavigationController, let filterVC = nv.topViewController as? FilterViewController  else {return}
            filterVC.filter = filter
            filterVC.hidesBottomBarWhenPushed = true
            
        case SegueID.viewDetailFromSearch.rawValue:
            guard let detailVC = segue.destination as? PlantDetailViewController, let indexPath = sender as? IndexPath else {fatalError()}
            detailVC.user = user
            
            let selectedPlant = plants[indexPath.row]
            
            detailVC.plant = selectedPlant
            detailVC.hidesBottomBarWhenPushed = true
            
        case SegueID.ComparisonSegue.rawValue:
            guard let nv = segue.destination as? ComparisonViewController else {fatalError()}
            nv.compareList = compareList
            nv.userFarm = user.farmPlants
            nv.hidesBottomBarWhenPushed = true
            
        default: break
        }
    }
    
    // Pass back filter object
    @IBAction func unwindToPlantSearch(sender: UIStoryboardSegue) {
        
        switch sender.identifier {
        case SegueID.filterUnwindSegue.rawValue:
            guard let filterVC = sender.source as? FilterViewController else {return}
            filter = filterVC.filter
            applyFilter()
            
        case SegueID.compareToSearchSegue.rawValue:
            guard let vc = sender.source as? ComparisonViewController else {fatalError()}
            guard let plants = vc.compareList else {fatalError()}
            
            //Add plants to user farm
            if !plants.isEmpty {
                user.farmPlants.insert(contentsOf: plants, at: 0)
            }
            localData.saveUserInfo(user)
            endCompareMode()
            tabBarController?.selectedIndex = 1
            
        case SegueID.detailToSearchSegue.rawValue:
            tabBarController?.selectedIndex = 1
            
        default: break
        }
    }
    
    
}


// MARK: UI Search bar controller extension
extension PlantSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


// MARK: Extension for ui Alert
extension PlantSearchTableViewController {
    
    // MARK: Alert functions
    private func uiAlert(_ plant: String, alertIndex: Int)  {
        if alertIndex == 0 {
            let alert = UIAlertController(title: "", message: "\(plant) is already in your farm", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        if alertIndex == 1 {
            let alert = UIAlertController(title: "New Plant!", message: "\(plant) has been added to your farm", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                self.tabBarController?.selectedIndex = 1
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Alert for comparison
    private func comparisonAlert(_ index: Int) {
        
        switch index {
        case 0:
            let alert = UIAlertController(title: "", message: "Please choose more than 1 plants to compare", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        case 1:
            let alert = UIAlertController(title: "", message: "Please only choose 3 plants to compare", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        case 2:
            //If user clicked show compare list and there are not compare plant
            let alert = UIAlertController(title: "", message: "You haven't selected any plant yet", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
            
        default: break
        }
        
    }
    
}

//MARK: Networking
extension PlantSearchTableViewController {
    
    //Request for data
    func requestPlantData() {
        
        guard let url = URL(string: "http://ec2-52-91-229-118.compute-1.amazonaws.com/allPlantData1.php") else {fatalError()}
        //        guard let url = URL(string: "http://ec2-52-91-229-118.compute-1.amazonaws.com/FertilizerData.php") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                
                //Convert json response to dictionary
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                
                //Create data
                var plantsData = [Plant]()
                
                for dic in jsonArray {
                    
                    //Data formate
                    let cropName = dic["cropName"] as? String ?? ""
                    let suitableMonth = dic["suitableMonth"] as? String ?? ""
                    let plantCategory = dic["plantCategory"] as? String ?? ""
                    
                    //Config value
                    guard let minSpaceString = dic["minSpace"] as? String, let minSpace = Int(minSpaceString) else {fatalError()}
                    guard let maxSpaceString = dic["maxSpace"] as? String, let maxSpace = Int(maxSpaceString) else {fatalError()}
                    guard let minHarvestTimeString = dic["minHarvestTime"] as? String, let minHarvestTime = Int(minHarvestTimeString) else {fatalError()}
                    guard let maxHarvestTimeString = dic["maxHarvestTime"] as? String, let maxHarvestTime = Int(maxHarvestTimeString) else {fatalError()}
                    
                    let plantStyle = dic["plantStyle"] as? String ?? ""
                    let compatiblePlants = dic["compatiblePlants"] as? String ?? ""
                    let culinaryHints = dic["culinaryHints"] as? String ?? ""
                    let fertilizerName = dic["fertilizerName"] as? String ?? ""
                    
                    plantsData.append(Plant(cropName: cropName, plantCategory: plantCategory, suitableMonth: suitableMonth, minSpacing: minSpace, maxSpacing: maxSpace, minHarvestTime: minHarvestTime, maxHarvestTime: maxHarvestTime, compatiblePlants: compatiblePlants, avoidInstructions: "", culinaryHints: culinaryHints, plantStyle: plantStyle, plantingTechnique: "", fertilizer: fertilizerName, compPlantList: [], avoidPlantList: [], harvestTime: Date(), nextWateringDate: Date(), indoorList: -1, outdoorList: -1, harvested: false))
                }
                
                //get missing value
                var missingValue = self.networkHandler.getMissingValue()
                
                //Fill out avoid instructions and planting technique
                plantsData.sort(by: { (plant1, plant2) -> Bool in
                    return plant1.cropName < plant2.cropName
                })
                
                for (index,plant) in plantsData.enumerated() {
                    if plant.cropName == missingValue[index][0] {
                        plant.avoidInstructions = missingValue[index][1]
                        plant.plantingTechnique = missingValue[index][2]
                    }
                }
                
                //Complete data
                plantsData = self.networkHandler.completeData(plantsData)
                
                self.originalPlants = plantsData
                self.tableView.reloadData()
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
}

//MARK: Appearance section
extension PlantSearchTableViewController {
    
    // MARK: Appearence
    // Set up search bar
    private func setUpSearchBar() {
        //Search bar code
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSAttributedString(string: "Search Plant", attributes: [.foregroundColor: UIColor.white]).string
        searchController.searchBar.tintColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setUpAppearance() {
        tableView.separatorStyle = .none
        navigationItem.title = "Plants search"
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        tableView.backgroundView = image
        tableView.showsVerticalScrollIndicator = false
        
        //Add show compare list button
        let y = (view.frame.height - (tabBarController?.tabBar.frame.height)!)-(view.frame.height*0.06+10)
        
        print(view.frame.height)
        print((tabBarController?.tabBar.frame.height)!)
        print(y)
        
        //Set up compare button
        compareButton.frame = CGRect(origin: CGPoint(x:view.frame.width*0.04, y: y), size: CGSize(width: view.frame.width*0.40, height: view.frame.height*0.06))
        compareButton.layer.cornerRadius = compareButton.frame.height/2
        compareButton.setTitle("Compare plants", for: .normal)
        
        compareButton.addTarget(self, action: #selector(compareAction(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(compareButton)
        
        //Setup left bar button item
        showSelected.image = UIImage(named: "ascendingOrder")
        
        //Setup filter button
        filterButton.image = UIImage(named: "filterIcon")
        filterButton.title = ""
        
        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
