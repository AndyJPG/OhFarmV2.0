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
    }
    
    //MARK: Variable
    var filter: Filter?
    var originalPlants = [Plant]()
    var filterPlants = [Plant]()
    var networkHandler = NetworkHandler()
    var user: User!
    let plantTableUI = SearchPlantUI()
    let localData = LocalData()
    
    //Search bar properites
    var searchPlants = [Plant]()
    let searchController = UISearchController(searchResultsController: nil)
    
    //Plants properites to handle change
    var plants: [Plant] {
        if isFiltering() {
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
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,200,0,200])
        }
        
        setUpAppearance()
        setUpSearchBar()
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
            
            cell = uiCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Main functions
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category, let location = filter?.location, let minSpacing = filter?.minSpacing, let maxSpacing = filter?.maxSpacing, let minHarvest = filter?.minHarvest, let maxHarvest = filter?.maxHarvest else {return}
        
        filterPlants = originalPlants.filter({ (plant : Plant) -> Bool in
            return (category.contains(plant.plantCategory.lowercased()) || plant.plantCategory.lowercased() == "both") && (location.contains(plant.plantStyle.lowercased()) || plant.plantStyle.lowercased() == "both") && minSpacing <= plant.maxSpacing && plant.maxSpacing <= maxSpacing && minHarvest <= plant.maxHarvestTime && plant.maxHarvestTime <= maxHarvest
        })
        
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
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == SegueID.filterSegue.rawValue {
            guard let nv = segue.destination as? UINavigationController, let filterVC = nv.topViewController as? FilterTableViewController else {return}
            filterVC.filter = filter
        }
        
        if segue.identifier == SegueID.viewDetailFromSearch.rawValue {
            guard let nv = segue.destination as? UINavigationController, let detailVC = nv.topViewController as? PlantDetailViewController, let selectedCell = sender as? SearchPlantTableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else {fatalError()}
            detailVC.user = user
            
            let selectedPlant = plants[indexPath.row]
            
            detailVC.plant = selectedPlant
        }
    }
    
    // Pass back filter object
    @IBAction func unwindToPlantSearch(sender: UIStoryboardSegue) {
        if sender.identifier == SegueID.filterUnwindSegue.rawValue {
            guard let filterVC = sender.source as? FilterTableViewController else {return}
            filter = filterVC.filter
            applyFilter()
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
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Plant", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
    }
    
}
