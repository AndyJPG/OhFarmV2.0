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
    
    enum segueID: String {
        case HomeToDetailSegue
        case checkListSegue
        case unwindToHomeSegue
        case unwindFromCheckList
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
        
        updateAppearance()
        updateProgressTracker()
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
        
        plantCell.checkListButton.tag = indexPath.row
        plantCell.checkListButton.addTarget(self, action: #selector(checkListButton(_:)), for: .touchUpInside)
        
        plantCell.progressBar.progress = progress
        
        return plantCell
    }
    
    //give click feedback
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    @objc private func addPlantTap(_ sender: UITapGestureRecognizer) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc private func checkListButton(_ sender: UIButton) {
        let plant = plants[sender.tag]
        if plant.plantStyle.lowercased() == "both" && plant.indoorList < 0 && plant.outdoorList < 0 {
            choiceConfirmation(sender)
        } else {
            performSegue(withIdentifier: segueID.checkListSegue.rawValue, sender: sender)
        }
    }
    
    //Update the progress tracking array
    private func updateProgressTracker() {
        var progresses = [Float]()
        for plant in plants {
            if plant.progress <= 1 && (plant.indoorList > 3 || plant.outdoorList > 6) {
                progresses.append(plant.progress)
            } else {
                progresses.append(0.0)
            }
        }
        progressTracker = progresses
        tableView.reloadData()
        
    }
    
}

//MARK: Navigation
extension HomeTableViewController {
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID.HomeToDetailSegue.rawValue {
            guard let nv = segue.destination as? UINavigationController, let detailVC = nv.topViewController as? PlantDetailViewController, let selectedCell = sender as? HomeFarmTableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else {fatalError()}
            detailVC.plant = plants[indexPath.row]
            detailVC.isFromHome = true
            detailVC.user = user
        }
        
        if segue.identifier == segueID.checkListSegue.rawValue {
            guard let nv = segue.destination as? UINavigationController, let vc = nv.topViewController as? CheckListHolderViewController, let button = sender as? UIButton else {fatalError()}
            vc.plant = plants[button.tag]
            vc.checkList = delegate.checkList
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
    }
    
    private func updateAppearance() {
        let image = UIImageView(image: UIImage(named: "background"))
        let image2 = UIImageView(image: UIImage(named: "background1"))
        image.contentMode = .scaleAspectFill
        image2.contentMode = .scaleAspectFill
        if plants.isEmpty {
            tableView.backgroundView = image2
            navigationItem.rightBarButtonItem?.title = "Manage"
        } else {
            tableView.backgroundView = image
        }
        
    }
    
}
