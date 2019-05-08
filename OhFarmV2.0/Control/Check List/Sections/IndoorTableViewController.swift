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
    let cellIdentifier = "CheckListTableViewCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
    //Checklist track
    var checkList = [String]()
    var listTracking = [Int]()
    
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
        if sender.tag == 3 && sender.isSelected == false {
            startConfirmation(sender)
        } else if sender.tag == 6 && sender.isSelected == false {
            startConfirmation(sender)
        }
        
        //Check for selection
        if sender.tag == count {
            sender.isSelected = !sender.isSelected
            listTracking[count] = 1
            count += 1
        } else if (plantStyle == styleID.indoor.rawValue && (sender.tag < 3 || sender.tag > 3)) || (plantStyle == styleID.outdoor.rawValue && (sender.tag < 6 || sender.tag > 6)) {
            sender.isSelected = !sender.isSelected
            listTracking[count-1] = 0
            count -= 1
        } else if sender.tag > count {
            uiAlert(0)
        } else if sender.tag < count-1 {
            uiAlert(1)
        }
        
        //Keep count to local
        if plantStyle == styleID.indoor.rawValue {
            plant.indoorList = count
        } else {
            plant.outdoorList = count
        }
    }
    
}

//MARK: UI alert
extension IndoorTableViewController {
    
    //Notes user there is a test before it
    private func uiAlert(_ index: Int)  {
        switch index {
        case 0:
            let alert = UIAlertController(title: "", message: "Please finish the task before this task", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        case 1:
            let alert = UIAlertController(title: "", message: "You have completed this task", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            
            present(alert, animated: true, completion: nil)
        default: break
        }
        
    }
    
    private func startConfirmation(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ready to plant", message: "Have you finished all preparation tasks ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            let currentDate = Date()
            let harvestDate = Calendar.current.date(byAdding: .weekOfYear, value: self.plant.maxHarvestTime, to: currentDate)!
            self.plant.harvestDate = harvestDate
            print(self.plant.harvestDate)
        }))
        
        alert.addAction(UIAlertAction(title: "Not yet", style: UIAlertAction.Style.destructive, handler: { _ in
            sender.isSelected = !sender.isSelected
            self.listTracking[self.count-1] = 0
            self.count -= 1
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
