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
    var icon: String
}

class ProfileTableViewController: UITableViewController {
    
    enum segueID: String {
        case settingSegue
        case favouritePlantSegue
        case NotificationSegue
        case unwindToProfileSegue
    }

    //MARK: Variable
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var user: User!
    let localData = LocalData()
    let imagePicker = UIImagePickerController()
    
    var options:[[Option]] = []
    
    enum cellID: String {
        case PofileCell
        case OptionCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = delegate.user
        }
        
        imagePicker.delegate = self
        
        setTableFooter()
        setupOptionsArry()
        setupAppearance()
        setupBackStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !user.notificationList.isEmpty {
            self.navigationController?.tabBarItem.badgeValue = String(user.notificationList.count)
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? -1.0 : 10
    }
    
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(editButton(_:)))
            profileTopCell.userName.isUserInteractionEnabled = true
            profileTopCell.userName.addGestureRecognizer(tap)
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
            profileTopCell.profileImage.addGestureRecognizer(imageTap)
            
            
            cell = profileTopCell
        case 2:
            guard let optionCell = tableView.dequeueReusableCell(withIdentifier: cellID.OptionCell.rawValue, for: indexPath) as? ProfileOptionTableViewCell else {fatalError()}
            let option = options[indexPath.section][indexPath.row]
            optionCell.configCell(option.optionName, icon: option.icon)
            
            if !user.notificationList.isEmpty {
                optionCell.badgeBackground.isHidden = false
                optionCell.badgeValue.isHidden = false
                optionCell.badgeValue.text = "\(user.notificationList.count)"
            } else {
                optionCell.badgeBackground.isHidden = true
                optionCell.badgeValue.isHidden = true
            }
            
            cell = optionCell
        default:
            guard let optionCell = tableView.dequeueReusableCell(withIdentifier: cellID.OptionCell.rawValue, for: indexPath) as? ProfileOptionTableViewCell else {fatalError()}
            let option = options[indexPath.section][indexPath.row]
            optionCell.configCell(option.optionName, icon: option.icon)
            cell = optionCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Perform segue for different section
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                self.tabBarController?.selectedIndex = 1
            } else {
                performSegue(withIdentifier: segueID.favouritePlantSegue.rawValue, sender: self)
            }
        case 2:
            performSegue(withIdentifier: segueID.NotificationSegue.rawValue, sender: self)
        case options.count-1:
            performSegue(withIdentifier: segueID.settingSegue.rawValue, sender: self)
        default: break
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case segueID.favouritePlantSegue.rawValue:
            guard let favouriteVC = segue.destination as? FavouriteTableViewController else {fatalError()}
            favouriteVC.user = user
            favouriteVC.hidesBottomBarWhenPushed = true
            
        case segueID.settingSegue.rawValue:
            guard let settingVC = segue.destination as? SettingTableViewController else {fatalError()}
            settingVC.user = user
            settingVC.hidesBottomBarWhenPushed = true
        
        case segueID.NotificationSegue.rawValue:
            guard let vc = segue.destination as? NotificationViewController else {fatalError()}
            vc.user = user
            vc.hidesBottomBarWhenPushed = true
            
        default: break
        }
    }
    
    // Pass back filter object
    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        if sender.identifier == segueID.unwindToProfileSegue.rawValue {
            guard let settingVC = sender.source as? SettingTableViewController else {return}
            print("back from setting")
            if settingVC.restore {
                user.userName = "First User"
                user.userImage = UIImage(named: "userProfile")!
                user.farmPlants = []
                user.favoritePlants = []
                localData.saveUserInfo(user)
                tableView.reloadData()
            }
        }
        
    }
    
    //MAKR: Action
    @objc private func editButton(_ sender: Any) {
        changeNameAlert()
    }
    
    
    //MARK: Private function
    private func setupOptionsArry() {
        let myGarden = Option(optionName: "My Garden", icon: "farm")
        let favourite = Option(optionName: "Favourites", icon: "heart")
        let setting = Option(optionName: "Settings", icon: "setting")
        let notification = Option(optionName: "Notifications", icon: "notification")
        options = [[Option(optionName: "Profile", icon: "heart")],[myGarden,favourite],[notification],[setting]]
    }
    

}

//MARK: UI image picker delegate
extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func profileImageTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get the image
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTopTableViewCell else {return}
        cell.profileImage.image = image
        user.userImage = image
        localData.saveUserInfo(user)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: UI alert extension
extension ProfileTableViewController {
    
    /**
     Simple Alert with Text input
     */
    private func changeNameAlert() {
        let alertController = UIAlertController(title: "Change name", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text.isEmpty {
                    self.uiAlert(0)
                } else if text.rangeOfCharacter(from: CharacterSet.letters) == nil || text.rangeOfCharacter(from: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ")) == nil {
                    self.uiAlert(1)
                } else {
                    self.user.userName = text
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                    self.localData.saveUserInfo(self.user)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Your name"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func uiAlert(_ alertCase: Int)  {
        var alert = UIAlertController()
        
        switch alertCase {
        case 0:
            alert = UIAlertController(title: "Error", message: "Your name can not be empty", preferredStyle: UIAlertController.Style.alert)
        case 1:
            alert = UIAlertController(title: "Error", message: "Name can only have characters or number", preferredStyle: UIAlertController.Style.alert)
        default: break
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Appearance
extension ProfileTableViewController {
    
    //Set up the back button style
    private func setupBackStyle() {
        
        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
    }
    
    // MARK: Appearance
    private func setTableFooter() {
        
        tableView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        tableViewFooter.backgroundColor = .clear
        let version = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 14))
        version.font = version.font.withSize(12)
        version.text = "Version 2.0"
        version.tintColor = .lightGray
        version.textAlignment = .center
        
        tableViewFooter.addSubview(version)
        
        tableView.tableFooterView  = tableViewFooter
    }
    
    private func setupAppearance() {
        
        let backgroundImage = UIImageView(image: UIImage(named: "background"))
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImage
        
        navigationItem.title =  "Profile"
        
        //Add camera button
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera"), style: .plain, target: self, action: #selector(profileImageTapped(_:)))
        navigationItem.rightBarButtonItem = cameraButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editButton(_:)))
        navigationItem.leftBarButtonItem = editButton
    }
    
}
