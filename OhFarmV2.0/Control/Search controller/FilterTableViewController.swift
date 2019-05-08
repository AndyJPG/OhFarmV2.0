//
//  FilterTableViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    //MARK: Filter type enum
    
    enum CategoryID: String {
        case vegetable
        case herb
    }
    
    enum PlantLocationID: String {
        case indoor
        case outdoor
    }
    
    enum FilterCellID: String {
        case categoryCell
        case locationCell
        case spacingCell
        case harvestCell
        case monthCell
    }
    
    //MARK: Variable
    
    var orginFilter: Filter!
    var filter: Filter!
    var searchUi = SearchPlantUI()
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    
    //Tracking selected buttons
    var selectedMonth = ["Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0,"May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0, "All": 0]
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setMonthTracker()
        
        //Track orginal filter for cancel button action
        if orginFilter == nil {
            orginFilter = Filter([[filter.category],[filter.location],filter.minSpacing,filter.maxSpacing,filter.minHarvest,filter.maxHarvest,filter.month])
        }
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        
        addBottomButton()
        setupApearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    //Form every filter cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellID.categoryCell.rawValue, for: indexPath)
            guard let categoryCell = searchUi.filterCellStyle(cell) as? FilterCategoryTableViewCell else {fatalError()}
            
            (categoryCell.bothButton.tag, categoryCell.vegetableButton.tag, categoryCell.herbButton.tag) = (0,1,1)
            categoryCell.bothButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            categoryCell.vegetableButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            categoryCell.herbButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            
            if filter.category.count == 2 {
                categoryCell.bothButton.isSelected = true
                categoryCell.vegetableButton.isSelected = false
                categoryCell.herbButton.isSelected = false
            } else if filter.category[0] ==  CategoryID.vegetable.rawValue {
                categoryCell.vegetableButton.isSelected = true
            } else {
                categoryCell.herbButton.isSelected = true
            }
            
            return categoryCell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellID.locationCell.rawValue, for: indexPath)
            guard let locationCell = searchUi.filterCellStyle(cell) as? FilterLocationTableViewCell else {fatalError()}
            
            (locationCell.bothButton.tag, locationCell.indoorButton.tag, locationCell.outdoorButton.tag) = (2,3,3)
            locationCell.bothButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            locationCell.indoorButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            locationCell.outdoorButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            
            if filter.location.count == 2 {
                locationCell.bothButton.isSelected = true
                locationCell.indoorButton.isSelected = false
                locationCell.outdoorButton.isSelected = false
            } else if filter.location[0] == PlantLocationID.indoor.rawValue {
                locationCell.indoorButton.isSelected = true
            } else {
                locationCell.outdoorButton.isSelected = true
            }
            
            return locationCell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellID.monthCell.rawValue, for: indexPath) as? FilterMonthTableViewCell else {fatalError()}
            
            cell.setButton(filter.month)
            
            let cellButtons = [cell.janButton,cell.febButton,cell.marButton,cell.aprButton,cell.mayButton,cell.junButton,cell.julButton,cell.augButton,cell.sepButton,cell.octButton,cell.novButton,cell.decButton,cell.anyButton]
            
            for index in 0 ..< cellButtons.count {
                guard let button = cellButtons[index] else {fatalError()}
                button.tag = index
                button.addTarget(self, action: #selector(monthButton(_:)), for: .touchUpInside)
                
                guard let buttonText = button.titleLabel?.text else {fatalError()}
                if selectedMonth[buttonText] == 1 {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellID.spacingCell.rawValue, for: indexPath)
            guard let spacingCell = searchUi.filterCellStyle(cell) as? FilterSpacingTableViewCell else {fatalError()}
            
            spacingCell.rangeSlider.setNeedsLayout()
            spacingCell.rangeSlider.delegate = self
            spacingCell.rangeSlider.tag = 0
            spacingCell.rangeSlider.selectedMinValue = CGFloat(filter.minSpacing)
            spacingCell.rangeSlider.selectedMaxValue = CGFloat(filter.maxSpacing)
            if filter.minSpacing != 0 || filter.maxSpacing != 200 {
                spacingCell.valueLabel.text = "\(filter.minSpacing) cm to \(filter.maxSpacing) cm"
            } else {
                spacingCell.valueLabel.text = "Any Spacing"
            }
            
            return spacingCell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellID.harvestCell.rawValue, for: indexPath)
            guard let harvestCell = searchUi.filterCellStyle(cell) as? FilterHarvestTableViewCell else {fatalError()}
            
            harvestCell.rangeSlider.setNeedsLayout()
            harvestCell.rangeSlider.delegate = self
            harvestCell.rangeSlider.tag = 1
            harvestCell.rangeSlider.selectedMinValue = CGFloat(filter.minHarvest)
            harvestCell.rangeSlider.selectedMaxValue = CGFloat(filter.maxHarvest)
            
            if filter.minHarvest != 0 || filter.maxHarvest != 200 {
                harvestCell.valueLabel.text = "\(filter.minHarvest) weeks to \(filter.maxHarvest) weeks"
            } else {
                harvestCell.valueLabel.text = "Any Time"
            }
            
            return harvestCell
        
        default: break
        }

        return cell
    }
    
    //MARK: Set month filter
    private func setMonthTracker() {
        
        for month in filter.month {
            selectedMonth[month] = 1
            count += 1
        }
        
    }
    
    //MARK: Action
    //MARK: Add button to table view
    
    private func addBottomButton() {
        let button = searchUi.filterBottomButton()
        let back = searchUi.filterBottomButtonBackground()
        button.addTarget(self, action: #selector(bottomButtonAction(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(back)
        navigationController?.view.addSubview(button)
    }
    
}

//MARK: Actions
extension FilterTableViewController {
    
    //MARK: Filter activities handler
    
    //This function can be improve by use array in where it update the filter object attribute
    //Can improve with array when button increases
    @objc func filterButton(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        
        if sender.tag == 0 || sender.tag == 1 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FilterCategoryTableViewCell else {fatalError()}
            
            if sender.tag == 0 {
                cell.bothButton.isSelected = true
                cell.vegetableButton.isSelected = false
                cell.herbButton.isSelected = false
            } else if !cell.vegetableButton.isSelected && !cell.herbButton.isSelected {
                cell.bothButton.isSelected = true
            } else {
                cell.bothButton.isSelected = false
            }
            
            if cell.bothButton.isSelected || (cell.vegetableButton.isSelected && cell.herbButton.isSelected) {
                filter.category = [CategoryID.vegetable.rawValue,CategoryID.herb.rawValue]
            } else if cell.vegetableButton.isSelected {
                filter.category = [CategoryID.vegetable.rawValue]
            } else {
                filter.category = [CategoryID.herb.rawValue]
            }
        }
        
        if sender.tag == 2 || sender.tag == 3 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? FilterLocationTableViewCell else {fatalError()}
            if sender.tag == 2 {
                cell.bothButton.isSelected = true
                cell.indoorButton.isSelected = false
                cell.outdoorButton.isSelected = false
            } else if !cell.indoorButton.isSelected && !cell.outdoorButton.isSelected {
                cell.bothButton.isSelected = true
            } else {
                cell.bothButton.isSelected = false
            }
            
            if cell.bothButton.isSelected || (cell.indoorButton.isSelected && cell.outdoorButton.isSelected) {
                filter.location = [PlantLocationID.indoor.rawValue, PlantLocationID.outdoor.rawValue]
            } else if cell.indoorButton.isSelected {
                filter.location = [PlantLocationID.indoor.rawValue]
            } else {
                filter.location = [PlantLocationID.outdoor.rawValue]
            }
        }
    }
    
    //apply filter action
    @objc func bottomButtonAction(_ sender: UIButton) {
        //Assign filter month
        var filterMonths = [String]()
        for (month, value) in selectedMonth {
            if value == 1 {
                filterMonths.append(month)
            }
        }
        filter.month = filterMonths
        
        performSegue(withIdentifier: "filterUnwindSegue", sender: self)
    }
    
    //Cancel action
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        filter = orginFilter
        performSegue(withIdentifier: "filterUnwindSegue", sender: self)
    }
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        filter = Filter([[CategoryID.vegetable.rawValue,CategoryID.herb.rawValue],[PlantLocationID.indoor.rawValue,PlantLocationID.outdoor.rawValue],0,200,0,200,["All"]])
        selectedMonth = ["Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0,"May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0, "All": 1]
        tableView.reloadData()
    }
    
    //Month Button action
    @objc private func monthButton(_ sender: UIButton) {
        
        //Obtain cell and buttons
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as? FilterMonthTableViewCell else {fatalError()}

        //Obtain all the button from the cell
        let cellButtons = [cell.janButton,cell.febButton,cell.marButton,cell.aprButton,cell.mayButton,cell.junButton,cell.julButton,cell.augButton,cell.sepButton,cell.octButton,cell.novButton,cell.decButton]
        
        //Obtain all the tags from the button
        let buttonTags = [cell.JanTag,cell.FebTag,cell.MarTag,cell.AprTag,cell.MayTag,cell.JunTag,cell.JulTag,cell.AugTag,cell.SepTag,cell.OctTag,cell.NovTag,cell.DecTag]

        //Obtain the label text
        guard let label = sender.titleLabel?.text else {fatalError()}
        let index = sender.tag
        
        //Check if the button is not all perform following
        if sender.tag != 12 {
            
            if selectedMonth["All"] == 1 {
                
                sender.isSelected = !sender.isSelected
                buttonTags[index]?.backgroundColor = color
                
                selectedMonth["All"] = 0
                selectedMonth[label] = 1
                cell.anyButton.isSelected = false
                
            } else if !sender.isSelected {
                
                sender.isSelected = !sender.isSelected
                buttonTags[index]?.backgroundColor = color
                
                count += 1
                selectedMonth[label] = 1
                
//                cell.anyButton.isSelected = false
//                selectedMonth["All"] = 0
                
            } else {
                
                sender.isSelected = !sender.isSelected
                
                if count == 1 {
                    
                    selectedMonth[label] = 0
                    buttonTags[index]?.backgroundColor = .white
                    
                    selectedMonth["All"] = 1
                    cell.anyButton.isSelected = true
                    
                } else {
                    
                    count -= 1
                    selectedMonth[label] = 0
                    buttonTags[index]?.backgroundColor = .white
                    
                }
                
            }
        
        //If the button is all perform following
        } else if sender.tag == 12 && !sender.isSelected {
            
            for (position,button) in cellButtons.enumerated() {
                guard let label = button?.titleLabel?.text else {fatalError()}
                button?.isSelected = false
                selectedMonth[label] = 0
                buttonTags[position]?.backgroundColor = .white
            }
            
            count = 1
            cell.anyButton.isSelected = true
            selectedMonth["All"] = 1
        }
        
        print(selectedMonth)
        print(count)
        
    }
    
}

//MARK: Appearence
extension FilterTableViewController {
    
    private func setupApearance() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
    }
    
}

//MARK: Class extension

extension FilterTableViewController: RangeSeekSliderDelegate {
    
    //Tracking value change
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider.tag == 0 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? FilterSpacingTableViewCell else {fatalError()}
            let min = Int(slider.selectedMinValue)
            let max = Int(slider.selectedMaxValue)
            if min == 0 && max == 200 {
                cell.valueLabel.text = "Any Spacing"
            } else {
                cell.valueLabel.text = "\(min) cm to \(max) cm"
            }
        }
        
        if slider.tag == 1 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? FilterHarvestTableViewCell else {fatalError()}
            let min = Int(slider.selectedMinValue)
            let max = Int(slider.selectedMaxValue)
            if min == 0 && max == 200 {
                cell.valueLabel.text = "Any Time"
            } else {
                cell.valueLabel.text = "\(min) weeks to \(max) weeks"
            }
        }
    }
    
    //Assign value when touch ended
    func didEndTouches(in slider: RangeSeekSlider) {
        if slider.tag == 0 {
            let min = Int(slider.selectedMinValue)
            let max = Int(slider.selectedMaxValue)
            (filter.minSpacing, filter.maxSpacing) = (min, max)
        }
        
        if slider.tag == 1 {
            let min = Int(slider.selectedMinValue)
            let max = Int(slider.selectedMaxValue)
            (filter.minHarvest, filter.maxHarvest) = (min, max)
        }
    }
    
}
