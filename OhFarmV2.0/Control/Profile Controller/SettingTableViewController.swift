//
//  SettingTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 26/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

struct Cell {
    var cellName: String
    var cellValue: String
}

class SettingTableViewController: UITableViewController {
    
    //MARK: Variable
    var restore = false
    var cells: [[Cell]] = []
    
    //Enum for cell name
    enum cellName: String {
        case lastLogin = "Last login day"
        case timeZone = "Time zone"
        case restore = "Restore app"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupApearence()
        setupCells()
        
        let backgroundImage = UIImageView(image: UIImage(named: "background"))
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImage
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? -1.0 : 10
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingTableViewCell else {fatalError()}
        let cellInfo = cells[indexPath.section][indexPath.row]
        if cellInfo.cellName == cellName.lastLogin.rawValue || cellInfo.cellName == cellName.timeZone.rawValue {
            cell.arrowIcon.isHidden = true
            cell.selectionStyle = .none
        }
        cell.cellTypeLabel.text = cellInfo.cellName
        cell.typeValueLabel.text = cellInfo.cellValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            restoreConfirmation()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Functions
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
    private func setupCells() {
        let cell1 = Cell(cellName: cellName.lastLogin.rawValue, cellValue: String(getCurrentDate().prefix(11)))
        let cell2 = Cell(cellName: cellName.timeZone.rawValue, cellValue: getCurrentDate())
        let cell3 = Cell(cellName: cellName.restore.rawValue, cellValue: "")
        
        cells = [[cell1,cell2],[cell3]]
    }
    
    //MARK: Action
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToProfileSegue", sender: self)
    }
    
    //MARK: Delete pop up confirmation
    private func restoreConfirmation() {
        
        let alert = UIAlertController(title: "Restore", message: "Are you sure you want to restore?\nThis will erase all your saved preferences", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            self.restore = true
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { (_) in
            print("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (_) in
            print("Delete dismiss")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    // MARK: Apearence
    private func setupApearence() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.title = "Setting"
        
        tableView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableViewFooter.backgroundColor = .clear
        tableView.tableFooterView  = tableViewFooter
    }

}
