//
//  HomeTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    // MARK: Variable
    // Style instance
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let homeTableUI = HomeUI()
    let localData = LocalData()
    var user: User!
    var addPlantImage = UIView()
    var progressTracker = [Float]()
    
    //Notification button
    let notificationButton = SSBadgeButton()
    
    //Welcome label and image
    var welcomeIamage = UIImageView()
    var welcomeLabel = UILabel()
    
    enum segueID: String {
        case HomeToDetailSegue
        case checkListSegue
        case unwindToHomeSegue
        case unwindFromCheckList
        case homeToNotificationSegue
    }
    
    var plants: [Plant] {
        return user?.farmPlants ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            self.user = delegate.user
        }
        
        setUpAppearance()
    }
    
    // Keep updating the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user.userName == "User" || user.userName == "First User" {
            navigationItem.title = "Your farm"
        } else {
            navigationItem.title = "\(user.userName)'s farm"
        }
        
        updateNotification()
        updateAppearance()
        updateProgressTracker()
        print("progress tracker")
        print(progressTracker)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFarmCell", for: indexPath)
        let plant = plants[indexPath.row]
        let progress = progressTracker[indexPath.row]
        guard let plantCell = homeTableUI.homePlantCellStyle(cell, plant: plant) as? HomeFarmTableViewCell else {fatalError()}
        
        //Check list button and action
        plantCell.checkListButton.tag = indexPath.row
        plantCell.checkListButton.addTarget(self, action: #selector(checkListButton(_:)), for: .touchUpInside)
        
        //Progress bar
        if plant.harvested {
            plantCell.progressBar.progress = 1.0
        } else  {
            plantCell.progressBar.progress = progress
        }
        
        return plantCell
    }
    
    //give click feedback
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID.HomeToDetailSegue.rawValue, sender: indexPath)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteConfirmation(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let plant = plants[fromIndexPath.row]
        user?.farmPlants.remove(at: fromIndexPath.row)
        user?.farmPlants.insert(plant, at: to.row)
        updateProgressTracker()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //MARK: Action
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
        if isEditing == false && plants.isEmpty {
            uiAlert()
        } else {
            isEditing = !isEditing
            if isEditing {
                navigationItem.rightBarButtonItem?.title = "Cancel"
            } else {
                navigationItem.rightBarButtonItem?.title = "Manage"
                tableView.reloadData()
            }
        }
    }
    
    //Update the progress tracking array
    private func updateProgressTracker() {
        var progresses = [Float]()
        for plant in plants {
            print("in progress tracker")
            print(plant.indoorList)
            print(plant.outdoorList)
            print(plant.progress)
            if plant.progress <= 1.0 && (plant.indoorList >= 3 || plant.outdoorList >= 4) {
                progresses.append(plant.progress)
            } else {
                progresses.append(0.0)
            }
        }
        progressTracker = progresses
        tableView.reloadData()
        
    }
    
    //Update notification
    private func updateNotification() {
        //Date formater
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let currentDate = Date()
        
        //Date calender
        let calendar = Calendar.current
        
        if user.wateringNotif && user.harvestNotif {
            for plant in user.farmPlants {
                //Check if plant started planting
                if (plant.indoorList > 3 || plant.outdoorList > 4) && !plant.harvested {
                    //Check Harvest time and watering
                    let harvestDate = plant.harvestDate
                    
                    let harvestDateString = dateFormatter.string(from: plant.harvestDate)
                    
                    let harvestString = "is ready to harvest!"
                    let waterString = "Please water the"
                    
                    //If harvest date is today push notificaiton
                    if harvestDate <= currentDate {
                        user.notificationList.append("\(plant.cropName) \(harvestString);\(harvestDateString)")
                        plant.harvested = true
                    }
                    
                    //Check of watering
                    if calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedDescending {
                        
                        while calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedDescending {
                            let nextWaterString = dateFormatter.string(from: plant.nextWateringDate)
                            
                            user.notificationList.append("\(waterString) \(plant.cropName).;\(nextWaterString)")
                            plant.nextWateringDate = calendar.date(byAdding: .day, value: 2, to: plant.nextWateringDate)!
                        }
                        
                    }
                    
                    //If the watering date is today
                    if calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedSame {
                        let nextWaterString = dateFormatter.string(from: plant.nextWateringDate)
                        
                        user.notificationList.append("\(waterString) \(plant.cropName).;\(nextWaterString)")
                        plant.nextWateringDate = calendar.date(byAdding: .day, value: 2, to: plant.nextWateringDate)!
                    }
                    
                }
            }
        } else if user.wateringNotif {
            for plant in user.farmPlants {
                //Check if plant started planting
                if (plant.indoorList > 3 || plant.outdoorList > 4) && !plant.harvested {
                    //Check watering
                    let waterString = "Please water the"
                    
                    //Check of watering
                    if calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedDescending {
                        
                        while calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedDescending {
                            let nextWaterString = dateFormatter.string(from: plant.nextWateringDate)
                            
                            user.notificationList.append("\(waterString) \(plant.cropName).;\(nextWaterString)")
                            plant.nextWateringDate = calendar.date(byAdding: .day, value: 2, to: plant.nextWateringDate)!
                        }
                        
                    }
                    
                    //If the watering date is today
                    if calendar.compare(currentDate, to: plant.nextWateringDate, toGranularity: .day) == .orderedSame {
                        let nextWaterString = dateFormatter.string(from: plant.nextWateringDate)
                        
                        user.notificationList.append("\(waterString) \(plant.cropName).;\(nextWaterString)")
                        plant.nextWateringDate = calendar.date(byAdding: .day, value: 2, to: plant.nextWateringDate)!
                    }
                    
                }
            }
        } else if user.harvestNotif {
            for plant in user.farmPlants {
                //Check if plant started planting
                if (plant.indoorList > 3 || plant.outdoorList > 4) && !plant.harvested {
                    //Check Harvest time
                    let harvestDate = plant.harvestDate
                    let harvestDateString = dateFormatter.string(from: plant.harvestDate)
                    let harvestString = "is ready to harvest!"
                    
                    //If harvest date is today push notificaiton
                    if harvestDate <= currentDate {
                        user.notificationList.append("\(plant.cropName) \(harvestString);\(harvestDateString)")
                        plant.harvested = true
                    }
                    
                }
            }
        }
        
        if !user.notificationList.isEmpty {
            notificationButton.badge = "\(user.notificationList.count)"
            notificationButton.badgeBackgroundColor = UIColor(red: 242/255, green: 48/255, blue: 48/255, alpha: 1)
        } else {
            notificationButton.badgeBackgroundColor = .clear
            notificationButton.badge = ""
        }
        
        print(user.notificationList)
        localData.saveUserInfo(user)
    }
    
}

//MARK: Actions
extension HomeTableViewController {
    
    @objc private func addPlantTap(_ sender: UITapGestureRecognizer) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc private func checkListButton(_ sender: UIButton) {
        let plant = plants[sender.tag]
        if plant.plantStyle.lowercased() == "both" && plant.indoorList < 0 && plant.outdoorList < 0 {
            choiceConfirmation(sender)
        } else {
            //Initial check list
            if plant.plantStyle.lowercased() != "both" {
                
                //Initial for indoor and outdoor plant
                if plant.plantStyle.lowercased() == "indoor" && plant.indoorList < 0 {
                    plant.indoorList = 0
                }
                
                if plant.plantStyle.lowercased() == "outdoor" && plant.outdoorList < 0 {
                    plant.outdoorList = 0
                }
                
            }
            
            performSegue(withIdentifier: segueID.checkListSegue.rawValue, sender: sender)
        }
    }
    
    @objc private func notificationAction(_ sender: UIButton) {
        performSegue(withIdentifier: segueID.homeToNotificationSegue.rawValue, sender: self)
    }
    
    //Add button gestrue
    @objc private func addMeAction(_ sender: UIGestureRecognizer) {
        print("add me")
        tabBarController?.selectedIndex = 0
    }
    
}

//MARK: Navigation
extension HomeTableViewController {
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID.HomeToDetailSegue.rawValue {
            guard let detailVC = segue.destination as? PlantDetailViewController, let indexPath = sender as? IndexPath else {fatalError()}
            detailVC.plant = plants[indexPath.row]
            detailVC.isFromHome = true
            detailVC.user = user
            detailVC.hidesBottomBarWhenPushed = true
        }
        
        if segue.identifier == segueID.checkListSegue.rawValue {
            guard let vc = segue.destination as? CheckListHolderViewController, let button = sender as? UIButton else {fatalError()}
            vc.plant = plants[button.tag]
            vc.checkList = delegate.checkList
            vc.hidesBottomBarWhenPushed = true
        }
        
        if segue.identifier == segueID.homeToNotificationSegue.rawValue {
            guard let nv = segue.destination as? NotificationViewController else {fatalError()}
            nv.user = user
            nv.hidesBottomBarWhenPushed = true
        }
    }
    
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue) {
        if sender.identifier == segueID.unwindToHomeSegue.rawValue {
            guard let loginVC = sender.source as? LoginViewController else {return}
            if !loginVC.name.isEmpty {
                user.userName = loginVC.name
            } else {
                user.userName = "User"
            }
            localData.saveUserInfo(user)
            tableView.reloadData()
        }
        
        if sender.identifier == segueID.unwindFromCheckList.rawValue {
            localData.saveUserInfo(user)
        }
    }
    
}

//MARK: UI alert
extension HomeTableViewController {
    
    //MARK: Delete pop up confirmation
    private func deleteConfirmation(_ indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete plant", message: "Are you sure you want to delete this plant ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.user.farmPlants.remove(at: indexPath.row)
            self.localData.saveUserInfo(self.user)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if self.plants.isEmpty {
                self.isEditing = false
            }
            self.updateProgressTracker()
            self.updateAppearance()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (_) in
            print("Delete dismiss")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    private func uiAlert()  {
        let alert = UIAlertController(title: "Oops!", message: "Your farm is empty, please add plant first", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //Check list style confirmation
    private func choiceConfirmation(_ sender: UIButton) {
        let plant = self.user.farmPlants[sender.tag]
        
        print(plant.indoorList)
        print(plant.outdoorList)
        
        let alert = UIAlertController(title: "Ready to plant?", message: "\(plant.cropName) can be grow in both indoor and outdoor, choose one option to start.", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Indoor", style: UIAlertAction.Style.default, handler: { _ in
            plant.indoorList = 0
            self.performSegue(withIdentifier: segueID.checkListSegue.rawValue, sender: sender)
        }))
        
        alert.addAction(UIAlertAction(title: "Outdoor", style: UIAlertAction.Style.default, handler: { _ in
            plant.outdoorList = 0
            self.performSegue(withIdentifier: segueID.checkListSegue.rawValue, sender: sender)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("Delete dimiss")
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: Appearance
extension HomeTableViewController {
    
    // MARK: Appearance methods
    private func setUpAppearance() {
        tableView.separatorStyle = .none
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        
        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
        //Set up bar button for notfication
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "notification")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        notificationButton.badge = "\(user.notificationList.count)"
        notificationButton.addTarget(self, action: #selector(notificationAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        //Add welcome image and label
        welcomeIamage = UIImageView(frame: CGRect(x: tableView.frame.width*0.5 - 120, y: tableView.frame.height*0.2, width: 250, height: 250))
        welcomeIamage.image = UIImage(named: "addMe")
        welcomeIamage.contentMode = .scaleAspectFit
        
        //Add tap recognizer
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(addMeAction(_:)))
        welcomeIamage.addGestureRecognizer(imageTap)
        welcomeIamage.isUserInteractionEnabled = true
        tableView.addSubview(welcomeIamage)
        
        //Add label
        welcomeLabel = UILabel(frame: CGRect(x: tableView.frame.width*0.5-120, y: tableView.frame.height*0.2+250, width: 240, height: 100))
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont(name: "Helvetica", size: 15)
        welcomeLabel.textColor = .darkGray
        
        let attributedString = NSMutableAttributedString(string: "You haven't got any plant in your farm.\nTap the search button below to add a new plant!")
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        welcomeLabel.attributedText = attributedString
        
        tableView.addSubview(welcomeLabel)
    }
    
    private func updateAppearance() {
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        tableView.backgroundView = image
        
        if plants.isEmpty {
            navigationItem.rightBarButtonItem?.title = "Manage"
            welcomeIamage.isHidden = false
            welcomeLabel.isHidden = false
        } else {
            welcomeIamage.isHidden = true
            welcomeLabel.isHidden = true
        }
        
    }
    
}
