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
    }
    
    //MARK: Variable
    var filter: Filter?
    var plants = [Plant]()
    var filterPlants = [Plant]()
    var networkHandler = NetworkHandler()
    let plantTableUI = SearchPlantUI()
    
    //Search bar properites
    var searchPlants = [Plant]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var filterApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if filter == nil {
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,100,0,100])
        }
        
        plants = networkHandler.fetchPlantData()
        
        tableView.separatorStyle = .none
        
        setUpSearchBar()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchPlants.count
        } else if filterApplied {
            return filterPlants.count
        }
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
        var plant: Plant
        
        if isFiltering() {
            plant = searchPlants[indexPath.row]
        } else if filterApplied {
            plant = filterPlants[indexPath.row]
        } else {
            plant = plants[indexPath.row]
        }
        
        guard let uiCell = plantTableUI.searchPlantCell(cell, name: plant.cropName, category: plant.plantCategory, plantStyle: plant.plantStyle) as? SearchPlantTableViewCell else {fatalError()}
        
        uiCell.plusButton.addTarget(self, action: #selector(addPlant(_:)), for: .touchUpInside)
        uiCell.plusButton.tag =  indexPath.row
        
        return uiCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: Main functions
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category else {return}
        guard let location = filter?.location else {return}
        guard let minSpacing = filter?.minSpacing else {return}
        guard let maxSpacing = filter?.maxSpacing else {return}
        guard let minHarvest = filter?.minHarvest else {return}
        guard let maxHarvest = filter?.maxHarvest else {return}
        
        filterPlants = plants.filter({ (plant : Plant) -> Bool in
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
            searchPlants = plants.filter({( plant : Plant) -> Bool in
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
        if isFiltering() {
            print("\(searchPlants[sender.tag].cropName) added")
        } else if filterApplied {
            print("\(filterPlants[sender.tag].cropName) added")
        } else {
            print("\(plants[sender.tag].cropName) added")
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.filterSegue.rawValue {
            guard let nv = segue.destination as? UINavigationController, let filterVC = nv.topViewController as? FilterTableViewController else {return}
            filterVC.filter = filter
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
}

// MARK: UI Search bar controller extension
extension PlantSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
