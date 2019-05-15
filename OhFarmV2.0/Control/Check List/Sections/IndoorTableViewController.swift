//
//  IndoorTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 8/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class IndoorTableViewController: UITableViewController, IndicatorInfoProvider {
    
    //MARK: variable
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let cellIdentifier = "CheckListTableViewCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
    //Checklist track
    var checkList = [String]()
    var listTracking = [Int]()
    
    //Plant point
    let indoorPlantPoint = 3
    let indoorMoveOut = 8
    let outdoorPlantPoint = 4
    
    //User and plant Index
    var plant: Plant!
    var plantStyle: String {
        return itemInfo.title!.lowercased()
    }
    
    enum styleID: String {
        case indoor
        case outdoor
    }
    
    //Tracking count
    var count = 0
    
    //Initiation for table view controller
    init(style: UITableView.Style, itemInfo: IndicatorInfo, checkList: [String], plant: Plant) {
        self.itemInfo = itemInfo
        self.checkList = checkList
        self.plant = plant
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keep count to local
        if plantStyle == styleID.indoor.rawValue {
            self.count = plant.indoorList
        } else {
            self.count = plant.outdoorList
        }
        
        //Assign tracking list
        for index in 0..<checkList.count {
            if index < count {
                listTracking.append(1)
            } else {
                listTracking.append(0)
            }
        }
        
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CheckListTableViewCell else { fatalError() }
        cell.configWithData(checkList[indexPath.row])
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)
        
        //Check if it is checked
        if listTracking[indexPath.row] == 1 {
            cell.checkButton.isSelected = true
        } else {
            cell.checkButton.isSelected = false
        }
        return cell
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

//MARK: Actions
extension IndoorTableViewController {
    
    //Check list button action
    @objc private func checkButton(_ sender: UIButton) {
        
        //Check if user reach the planting part
        if sender.tag == listTracking.count-1 && sender.isSelected {
            listTracking[sender.tag] = 0
            count -= 1
            sender.isSelected = !sender.isSelected
        } else if sender.tag > count {
            uiAlert(0)
        } else if sender.tag < count && listTracking[sender.tag+1] != 0 {
            uiAlert(1)
        } else if sender.tag == count && !sender.isSelected {
            listTracking[count] = 1
            count += 1
            sender.isSelected = !sender.isSelected
            
            //Notfiy user if they want to start seeding
            if (plantStyle == "indoor" && sender.tag == indoorPlantPoint) || (plantStyle == "outdoor" && sender.tag == outdoorPlantPoint && plant.indoorList < 0) {
                startConfirmation(sender)
            }
            
            //Notify ser if they want to move plant out
            if plantStyle == "indoor" && sender.tag == indoorMoveOut {
                moveOutConfirmation(sender)
            }
            
        } else if sender.tag == count-1 && listTracking[sender.tag+1] == 0 {
            
            if (plantStyle == "indoor" && sender.tag != indoorPlantPoint && sender.tag != indoorMoveOut) || (plantStyle == "outdoor" && sender.tag != outdoorPlantPoint) {
                listTracking[sender.tag] = 0
                count -= 1
                sender.isSelected = !sender.isSelected
            } else {
                uiAlert(2)
            }
            
        }
        
        if plantStyle == "indoor" {
            plant.indoorList = count
            print(plant.indoorList)
            print(count)
        } else {
            plant.outdoorList = count
            print(plant.outdoorList)
            print(count)
        }
        
    }
    
}

//MARK: UI alert
extension IndoorTableViewController {
    
    //Notes user there is a test before it
    private func uiAlert(_ index: Int)  {
        switch index {
        case 0:
            //Clicked future task
            let alert = UIAlertController(title: "", message: "Please finish the task before this task", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        case 1:
            //Clicked completed task
            let alert = UIAlertController(title: "", message: "You have completed this task", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        case 2:
            //Mistake clicked plant seed
            let alert = UIAlertController(title: "You have planted seed", message: "If you have checked this task by mistake, use rest button to rest.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        default: break
        }
        
    }
    
    //Confirmation for starting planting seed
    private func startConfirmation(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ready to plant", message: "Have you finished all preparation tasks ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            let currentDate = Date()
            let harvestDate = Calendar.current.date(byAdding: .weekOfYear, value: self.plant.maxHarvestTime, to: currentDate)!
            let nextWateringDate = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
            
            self.plant.harvestDate = harvestDate
            self.plant.nextWateringDate = nextWateringDate
            print(self.plant.harvestDate)
            print("Next watering date")
            print(self.plant.nextWateringDate)
            
            //ADD FIRST NOTIFICATION FOR NEW PLANT
            //Date formater
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let nextWaterString = dateFormatter.string(from: Date())
            
            if self.delegate.user!.wateringNotif {
                self.delegate.user?.notificationList.append("Please water the \(self.plant.cropName).;\(nextWaterString)")
            }
            
        }))
        
        //Not yet solution if user dont want to plant now
        alert.addAction(UIAlertAction(title: "Not yet", style: UIAlertAction.Style.destructive, handler: { _ in
            //deselect check box and update the tracker and counter
            sender.isSelected = !sender.isSelected
            self.listTracking[self.count-1] = 0
            self.count -= 1
            
            //Set plant counter to sync with count
            if self.plantStyle == "indoor" {
                self.plant.indoorList = self.count
            } else {
                self.plant.outdoorList = self.count
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //Confirmation if user want to move plant outside
    private func moveOutConfirmation(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Move outdoor or keep indoor", message: "Do you want to move your plant to outdoor or keep it indoor ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Indoor", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        
        //Not yet solution if user dont want to plant now
        alert.addAction(UIAlertAction(title: "Outdoor", style: UIAlertAction.Style.default, handler: { _ in
            self.plant.outdoorList = 0
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("Delete dimiss")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Appearance
extension IndoorTableViewController {
    
    private func setupTable() {
        tableView.register(UINib(nibName: "CheckListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        
        //Table style
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        
        //Setup background
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        tableView.backgroundView = image
        
    }
    
}
