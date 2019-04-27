//
//  PlantInfoOneTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlantInfoOneTableViewController: UITableViewController, IndicatorInfoProvider {

    // MARK: Variable
    var plant: Plant!
    var isFromHome: Bool!
    let cellIdentifier = "defaultPlantInfoCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
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
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plant.plantInfoOne.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DefaultPlantInfoTableViewCell else { return DefaultPlantInfoTableViewCell() }
        let data = plant.plantInfoOne[indexPath.row]
        
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
    
    private func setupTableStyle() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 93, bottom: 0, right: 0)
        
        tableView.register(UINib(nibName: "DefaultPlantCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        if isFromHome {
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        } else {
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
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
