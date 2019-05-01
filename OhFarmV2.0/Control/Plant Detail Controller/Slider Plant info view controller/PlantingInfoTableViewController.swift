//
//  PlantingInfoTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlantingInfoTableViewController: UITableViewController, IndicatorInfoProvider {
    
    //MARK: Variable
    var plant: Plant!
    var isFromHome: Bool!
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    let reuseID = "CollectionViewCell"
    
    enum cellID: String {
        case defaultPlantInfoCell
        case CACell
    }
    
    init(style: UITableView.Style, itemInfo: IndicatorInfo, plant: Plant, fromHome: Bool) {
        self.isFromHome = fromHome
        self.plant = plant
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plant.plantingInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = plant.plantingInfo[indexPath.row]
        
        // If the cell need to show avoid plants and compatiable plants
        // Check if the list is empty or not then do following action to pass data into table cell and form collection view
        if (data[0] == "Avoid Plants" && !plant.avoidPlantList.isEmpty) || (data[0] == "Compatiable Plants" && !plant.compPlantList.isEmpty) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.CACell.rawValue, for: indexPath) as? CACellTableViewCell else {fatalError()}
            
            cell.nameLabel.text = data[0]
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            //register the xib for collection view cell
            let cellNib = UINib(nibName: "CACollectionViewCell", bundle: nil)
            cell.collectionView.register(cellNib, forCellWithReuseIdentifier: reuseID)
            
            if data[0] == "Avoid Plants" {
                cell.collectionView.tag = 0
//                cell.plants = plant.avoidPlantList
                cell.cellImage.image = UIImage(named: "avoid")
            } else {
                cell.collectionView.tag = 1
//                cell.plants = plant.compPlantList
                cell.cellImage.image = UIImage(named: "compat")
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.defaultPlantInfoCell.rawValue, for: indexPath) as? DefaultPlantInfoTableViewCell else { return DefaultPlantInfoTableViewCell() }
        
        cell.configureWithData(data)
        if blackTheme {
            cell.changeStylToBlack()
        }
        
        return cell
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // MARK: Appearence
    private func setupTableStyle() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 93, bottom: 0, right: 0)
        
        tableView.register(UINib(nibName: "DefaultPlantCell", bundle: Bundle.main), forCellReuseIdentifier: cellID.defaultPlantInfoCell.rawValue)
        tableView.register(UINib(nibName: "CACellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellID.CACell.rawValue)
        
        if isFromHome {
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        } else {
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        }
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        tableView.backgroundView = image
    }

}

//MARK: Extension for the collection view inside table view cell
//Returen items in each section
extension PlantingInfoTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //TO DO: Need to implement how to interact with collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return plant.avoidPlantList.count
        } else {
            return plant.compPlantList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? CACollectionViewCell else {fatalError()}
        
        if collectionView.tag == 0 {
            cell.configCell(plant.avoidPlantList[indexPath.row])
        } else {
            cell.configCell(plant.compPlantList[indexPath.row])
        }
        
        return cell
    }
    
}
