//
//  NotificationViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 11/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: Variable
    var user: User!
    var notification: [String] {
        return user.notificationList
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "notificationCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @objc private func clearNotification(_ sender: Any) {
        user.notificationList = []
        tableView.reloadData()
    }

}

//MARK: Table view delegate and data source
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NotificationTableViewCell else {fatalError()}
        cell.configWithDate(notification[indexPath.row])
        
        return cell
    }
    
    //End able swipe to delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            user.notificationList.remove(at: indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}

//MARK: Appearance
extension NotificationViewController {
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotification(_:)))
        
        tableView.tableFooterView = UIView()
    }
    
}
