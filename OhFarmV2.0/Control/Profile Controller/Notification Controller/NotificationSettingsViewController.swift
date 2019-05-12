//
//  NotificationSettingsViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 11/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

struct nCell {
    var cellName: String
    var cellState: Bool
}

class NotificationSettingsViewController: UIViewController {
    
    //MARK: Variable
    @IBOutlet weak var tableView: UITableView!
    var user: User!
    
    //Cell
    var cells = [nCell]()
    
    //Local data to save change
    let localData = LocalData()
    
    
    enum cellID: String {
        case notificationSettingCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        setData()
        setupAppreance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        localData.saveUserInfo(user)
    }
    

    //MARK: Form data
    private func setData(){
        let cell1 = nCell(cellName: "Watering Notification", cellState: user.wateringNotif)
        let cell2 = nCell(cellName: "Harvest Notification", cellState: user.harvestNotif)
        
        cells = [cell1,cell2]
    }
    
    //MARK: Appearance
    private func setupAppreance() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
    }
    
    //MARK: Action
    @objc private func switchAction(_ sender: UISwitch) {
        sender.setOn(!sender.isOn, animated: true)
        
        if sender.isOn {
            if sender.tag == 0 {
                user.wateringNotif = true
            }
            
            if sender.tag == 1 {
                user.harvestNotif = true
            }
        } else {
            if sender.tag == 0 {
                user.wateringNotif = false
            }
            
            if sender.tag == 1 {
                user.harvestNotif = false
            }
        }
        
    }

}

//MARK: Table view delegate
extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Define row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.notificationSettingCell.rawValue, for: indexPath) as? NotificationSettingsTableViewCell else {fatalError()}
        
        let notiCell = cells[indexPath.row]
        cell.cellLabel.text = notiCell.cellName
        cell.switchButton.setOn(notiCell.cellState, animated: true)
        cell.switchButton.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        cell.switchButton.tag = indexPath.row
        
        return cell
    }
    
}
