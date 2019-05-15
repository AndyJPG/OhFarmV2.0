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
    var notifiMassage = UILabel()
    var welcomeIamage = UIImageView()
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
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        navigationItem.title = "Notification"
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
        tableView.reloadData()
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
            updateView()
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
        
        //Set up the image
        //Add welcome image and label
        welcomeIamage = UIImageView(frame: CGRect(x: view.frame.width*0.5 - 130, y: view.frame.height*0.3, width: 250, height: 250))
        welcomeIamage.image = UIImage(named: "notificationImage")
        welcomeIamage.contentMode = .scaleAspectFit
        
        
        view.addSubview(welcomeIamage)
        
        //Set up the label
        let text = "We will notify you when your plant needs water\nor is ready for harvest"
        
        notifiMassage = UILabel(frame: CGRect(x: view.frame.width*0.5-120, y: view.frame.height*0.3+250, width: 240, height: 100))
        notifiMassage.numberOfLines = 0
        notifiMassage.font = UIFont(name: "Helvetica", size: 15)
        notifiMassage.textColor = .darkGray
        
        let attributedString = NSMutableAttributedString(string: text)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        notifiMassage.attributedText = attributedString
        
        view.addSubview(notifiMassage)
    }
    
    private func updateView() {
        
        if notification.isEmpty {
            notifiMassage.isHidden = false
            welcomeIamage.isHidden = false
        } else {
            notifiMassage.isHidden = true
            welcomeIamage.isHidden = true
        }
    }
    
}
