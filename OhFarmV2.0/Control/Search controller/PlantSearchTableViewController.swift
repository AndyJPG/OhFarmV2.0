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
    
    var filterApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if filter == nil {
            filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,100,0,100])
        }
        
        plants = networkHandler.fetchPlantData()
        
        tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterApplied {
            return filterPlants.count
        }
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
        var plant: Plant
        
        if filterApplied {
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
    
    //MARK: Filter functions
    private func applyFilter() {
        guard let category = filter?.category else {return}
        guard let location = filter?.location else {return}
        guard let minSpacing = filter?.minSpacing else {return}
        guard let maxSpacing = filter?.maxSpacing else {return}
        guard let minHarvest = filter?.minHarvest else {return}
        guard let maxHarvest = filter?.maxHarvest else {return}
        
        filterPlants = [Plant]()
        for plant in plants {
            if category.contains(plant.plantCategory.lowercased()) && location.contains(plant.plantStyle.lowercased()) && minSpacing <= plant.maxSpacing && plant.maxSpacing <= maxSpacing && minHarvest <= plant.maxHarvestTime && plant.maxHarvestTime <= maxHarvest {
                filterPlants.append(plant)
            }
        }

        filterApplied = true
        tableView.reloadData()
    }
    
    // MARK: Action handle functions
    @objc private func addPlant(_ sender: UIButton) {
        print("\(plants[sender.tag].cropName) added")
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
}
