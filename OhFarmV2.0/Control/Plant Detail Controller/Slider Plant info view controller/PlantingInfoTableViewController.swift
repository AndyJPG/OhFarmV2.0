//
//  PlantingInfoTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlantingInfoTableViewController: UITableViewController, IndicatorInfoProvider {
    
    //MARK: Variable
    var plant: Plant!
    var isFromHome: Bool!
    let defaultCellIdentifier = "defaultPlantInfoCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
    init(style: UITableView.Style, itemInfo: IndicatorInfo, plant: Plant, fromHome: Bool) {
        self.isFromHome = fromHome
        self.plant = plant
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plant.plantingInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath) as? DefaultPlantInfoTableViewCell else { return DefaultPlantInfoTableViewCell() }
        let data = plant.plantingInfo[indexPath.row]
        
        cell.configureWithData(data)
        if blackTheme {
            cell.changeStylToBlack()
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // MARK: Appearence
    private func setupTableStyle() {
        tableView.register(UINib(nibName: "DefaultPlantCell", bundle: Bundle.main), forCellReuseIdentifier: defaultCellIdentifier)
//      tableView.separatorStyle = .none
        if isFromHome {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        } else {
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        }
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
    }

}
