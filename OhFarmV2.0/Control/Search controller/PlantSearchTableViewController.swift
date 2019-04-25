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
    var user: User?
    let plantTableUI = SearchPlantUI()
    
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
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,100,0,100])
        }
        
        originalPlants = networkHandler.fetchPlantData()
        
        setUpAppearance()
        setUpSearchBar()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
        let plant = plants[indexPath.row]
        
        guard let uiCell = plantTableUI.searchPlantCell(cell, plant: plant) as? SearchPlantTableViewCell else {fatalError()}
        
        uiCell.plusButton.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
        uiCell.plusButton.tag =  indexPath.row
        
        return uiCell
    }
    
    //MARK: Main functions
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category, let location = filter?.location, let minSpacing = filter?.minSpacing, let maxSpacing = filter?.maxSpacing, let minHarvest = filter?.minHarvest, let maxHarvest = filter?.maxHarvest else {return}
        
        filterPlants = originalPlants.filter({ (plant : Plant) -> Bool in
            return category.contains(plant.plantCategory.lowercased()) && location.contains(plant.plantStyle.lowercased()) && minSpacing <= plant.maxSpacing && plant.maxSpacing <= maxSpacing && minHarvest <= plant.maxHarvestTime && plant.maxHarvestTime <= maxHarvest
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
        user?.farmPlants.append(plants[sender.tag])
        print("\(plants[sender.tag].cropName) added")
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
            guard let nv = segue.destination as? PlantDetailViewController, let selectedCell = sender as? SearchPlantTableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else {fatalError()}
            nv.plant = plants[indexPath.row]
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
    
    
    
    // MARK: Appearence
    // Set up search bar
    private func setUpSearchBar() {
        //Search bar code
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Plant"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
//        UISearchBar.appearance().tintColor = UIColor.white
    }
    
    private func setUpAppearance() {
        tableView.separatorStyle = .none
        navigationItem.title = "Plants search"
    }
}

// MARK: UI Search bar controller extension
extension PlantSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
