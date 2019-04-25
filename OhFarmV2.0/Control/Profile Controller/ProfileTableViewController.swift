//
//  ProfileTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

struct Option {
    var optionName: String
}

class ProfileTableViewController: UITableViewController {

    //MARK: Variable
    var user: User!
    
    var options:[[Option]] = []
    
    enum cellID: String {
        case PofileCell
        case OptionCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupOptionsArry()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? -1.0 : 10
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
//        view.backgroundColor = UIColor.lightGray
//        return view
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            guard let profileTopCell = tableView.dequeueReusableCell(withIdentifier: cellID.PofileCell.rawValue, for: indexPath) as? ProfileTopTableViewCell else {fatalError()}
            profileTopCell.configCell(user)
            cell = profileTopCell
        case 1:
            guard let optionCell = tableView.dequeueReusableCell(withIdentifier: cellID.OptionCell.rawValue, for: indexPath) as? ProfileOptionTableViewCell else {fatalError()}
            optionCell.configCell(options[indexPath.section][indexPath.row].optionName)
            cell = optionCell
        default:
            guard let optionCell = tableView.dequeueReusableCell(withIdentifier: cellID.OptionCell.rawValue, for: indexPath) as? ProfileOptionTableViewCell else {fatalError()}
            optionCell.configCell(options[indexPath.section][indexPath.row].optionName)
            cell = optionCell
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
    
    //MARK: Private function
    private func setupOptionsArry() {
        let myGarden = Option(optionName: "My Garden")
        let favourite = Option(optionName: "Favourites")
        let setting = Option(optionName: "Setting")
        options = [[Option(optionName: "Profile")],[myGarden,favourite],[setting]]
    }

}
