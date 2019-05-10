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
    }
    
    //MARK: Variable
    var filter: Filter?
    var originalPlants = [Plant]()
    var filterPlants = [Plant]()
    var networkHandler = NetworkHandler()
    var user: User!
    let plantTableUI = SearchPlantUI()
    let localData = LocalData()
    
    //Button for comparison
    let showCompareListButton = SearchPlantUI().filterBottomButton()
    var showSelectedCompareList = false
    
    //Search bar properites
    var searchPlants = [Plant]()
    let searchController = UISearchController(searchResultsController: nil)
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    //Check if is compare mode
    var compareMode = false
    var compareList = [Plant]()
    
    //Compare button
    @IBOutlet weak var compareButton: UIBarButtonItem!
    
    //Filter button
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    //Plants properites to handle change
    var plants: [Plant] {
        if isFiltering() {
            return searchPlants
        } else if filterApplied {
            return filterPlants
        } else if showSelectedCompareList {
            return compareList
        }
        return originalPlants
    }
    
    var filterApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if filter == nil {
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,200,0,200,["All"]])
        }
        
        if user == nil {
            user = delegate.user
            originalPlants = delegate.plants
        }
        
        setUpAppearance()
        setUpSearchBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if compareMode {
            showCompareListButton.isHidden = false
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plants.count == 0 {
            return 1
        }
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if plants.count == 0 {
            guard let noResultCell = tableView.dequeueReusableCell(withIdentifier: "NoResultCell", for: indexPath) as? NoResultTableViewCell else {fatalError()}
            let searchText = searchController.searchBar.text ?? "the plant"
            noResultCell.selectionStyle = .none
            noResultCell.backgroundColor = .clear
            noResultCell.noResultLabel.text = "Sorry we can't find \(searchText)"
            if searchText.isEmpty {
                noResultCell.noResultLabel.text = "Sorry we can't find anything with the input filter"
            }
            cell = noResultCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
            let plant = plants[indexPath.row]
            
            guard let uiCell = plantTableUI.searchPlantCell(cell, plant: plant) as? SearchPlantTableViewCell else {fatalError()}
            
            uiCell.plusButton.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
            uiCell.plusButton.tag =  indexPath.row
            
            uiCell.compareCheck.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
            uiCell.compareCheck.tag = indexPath.row
            
            //Change plus button if is compare mode
            if compareMode {
                uiCell.plusButton.isHidden = true
                uiCell.compareCheck.isHidden = false
            } else {
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
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: Main functions
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category, let location = filter?.location, let minSpacing = filter?.minSpacing, let maxSpacing = filter?.maxSpacing, let minHarvest = filter?.minHarvest, let maxHarvest = filter?.maxHarvest, let months = filter?.month else {return}
        
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
    
    
    // MARK: Action handle functions
    @objc private func addPlant(_ sender: UIButton) {
        
        let plant = plants[sender.tag]
        var exist = false
        
        if !user.farmPlants.isEmpty {
            for i in user.farmPlants {
                if i.cropName == plant.cropName {
                    exist = true
                }
            }
        }
        
        if exist {
            uiAlert(plant.cropName, alertIndex: 0)
        } else {
            user.farmPlants.insert(plant, at: 0)
            localData.saveUserInfo(user)
            uiAlert(plant.cropName, alertIndex: 1)
        }
    }
    
    //Comparison check box
    @objc private func checkAction(_ sender: UIButton) {
        if !sender.isSelected {
            //Check if list is full
            if compareList.count < 3 {
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
        if compareList.count == 3 {
            compareButton.tintColor = .white
        } else {
            compareButton.tintColor = .lightText
        }
    }
    
    //Show select list action
    @objc private func showSelectedPlants(_ sender: UIButton) {
        
        //check if compare list has any plant
        if compareList.isEmpty {
            comparisonAlert(2)
        } else if !showSelectedCompareList {
            showSelectedCompareList = true
            
            //change title for button
            showCompareListButton.setTitle("Cancel", for: .normal)
            showCompareListButton.frame = CGRect(origin: CGPoint(x:view.frame.width*0.04, y: view.frame.height*0.85), size: CGSize(width: view.frame.width*0.25, height: view.frame.height*0.06))
            
            tableView.reloadData()
        } else {
            showSelectedCompareList = false
            showCompareListButton.setTitle("Show selected plants", for: .normal)
            showCompareListButton.frame = CGRect(origin: CGPoint(x:view.frame.width*0.04, y: view.frame.height*0.85), size: CGSize(width: view.frame.width*0.42, height: view.frame.height*0.06))
            tableView.reloadData()
        }
        
        print("show selected plants")
    }
    
    //Compare button action
    @IBAction func compareAction(_ sender: Any) {
        //check if is compare mode
        if !compareMode {
            compareMode = true
            compareButton.title = "Comparing"
            compareButton.tintColor = .lightText
            //Set filter button to be cancel button
            filterButton.title = "Cancel"
            
            //Show compare list button
            UIView.animate(withDuration: 0.5) {
                self.showCompareListButton.alpha = 0
                self.showCompareListButton.alpha = 1
            }
            self.showCompareListButton.isHidden = false
            
            tableView.reloadData()
        } else if compareList.count != 3 {
            comparisonAlert(0)
        } else if compareList.count == 3 {
            //If comparison list got 3 plant compare
            showCompareListButton.isHidden = true
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
        compareButton.title = "Compare"
        compareButton.tintColor = .white
        filterButton.title = "Filter"
        compareList = []
        
        //Hiddent compare list button
        UIView.animate(withDuration: 0.5) {
            self.showCompareListButton.alpha = 1
            self.showCompareListButton.alpha = 0
        }
        self.showCompareListButton.isHidden = true
        
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
            guard let nv = segue.destination as? UINavigationController, let filterVC = nv.topViewController as? FilterTableViewController else {return}
            filterVC.filter = filter
            
        case SegueID.viewDetailFromSearch.rawValue:
            guard let nv = segue.destination as? UINavigationController, let detailVC = nv.topViewController as? PlantDetailViewController, let indexPath = sender as? IndexPath else {fatalError()}
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
        if sender.identifier == SegueID.filterUnwindSegue.rawValue {
            guard let filterVC = sender.source as? FilterTableViewController else {return}
            filter = filterVC.filter
            applyFilter()
        }
        
        if sender.identifier == SegueID.compareToSearchSegue.rawValue {
            guard let vc = sender.source as? ComparisonViewController else {fatalError()}
            guard let plants = vc.compareList else {fatalError()}
            
            //Add plants to user farm
            if !plants.isEmpty {
                user.farmPlants.insert(contentsOf: plants, at: 0)
            }
            localData.saveUserInfo(user)
            endCompareMode()
            tabBarController?.selectedIndex = 1
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
            let alert = UIAlertController(title: "Oops!", message: "\(plant) is already in your farm", preferredStyle: UIAlertController.Style.alert)
            
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
            let alert = UIAlertController(title: "", message: "Please choose 3 plants to compare", preferredStyle: UIAlertController.Style.alert)
            
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
        
        //Add show compare list button
        showCompareListButton.frame = CGRect(origin: CGPoint(x:view.frame.width*0.04, y: view.frame.height*0.85), size: CGSize(width: view.frame.width*0.42, height: view.frame.height*0.06))
        showCompareListButton.layer.cornerRadius = showCompareListButton.frame.height/2
        showCompareListButton.setTitle("Show selected plants", for: .normal)
        showCompareListButton.isHidden = true
        showCompareListButton.addTarget(self, action: #selector(showSelectedPlants(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(showCompareListButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
