//
//  SearchPlantUI.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class SearchPlantUI: UIViewController {
    
    //MARK: Cell type enum
    enum FilterCell: String {
        case categoryCell
        case locationCell
        case spacingCell
        case harvestCell
    }
    
    //MARK: Filter cell style section
    func filterCellStyle(_ cell: UITableViewCell) -> UITableViewCell {
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch cell.reuseIdentifier {
        case FilterCell.categoryCell.rawValue:
            guard let categoryCell = cell as? FilterCategoryTableViewCell else {fatalError()}
            
            //Category cell ui need to implement here
            
            return categoryCell
        case FilterCell.locationCell.rawValue:
            guard let locationCell = cell as? FilterLocationTableViewCell else {fatalError()}
            
            //Location cell UI need to implement here
            
            return locationCell
        case FilterCell.spacingCell.rawValue:
            guard let spacingCell = cell as? FilterSpacingTableViewCell else {fatalError()}
            
            spacingCell.rangeSlider.enableStep = true
            spacingCell.rangeSlider.step = 1
            spacingCell.rangeSlider.minDistance = 5
            spacingCell.rangeSlider.selectedMinValue = 0
            spacingCell.rangeSlider.selectedMaxValue = 100
            
            //Need to implement spacing cell ui
            
            spacingCell.valueLabel.sizeToFit()
            return spacingCell
        case FilterCell.harvestCell.rawValue:
            guard let harvestCell = cell as? FilterHarvestTableViewCell else {fatalError()}
            
            harvestCell.rangeSlider.enableStep = true
            harvestCell.rangeSlider.step = 1
            harvestCell.rangeSlider.minDistance = 5
            harvestCell.rangeSlider.selectedMinValue = 0
            harvestCell.rangeSlider.selectedMaxValue = 100
            
            //Need to implement harvest cell ui
            
            harvestCell.valueLabel.sizeToFit()
            return harvestCell
        default: break
        }
        return cell
    }
    
    func filterBottomButton() -> UIButton {
        let button = UIButton(frame: CGRect(origin: CGPoint(x:view.frame.width/2-143.5, y: view.frame.height-80), size: CGSize(width: 287, height: 54)))
        button.layer.cornerRadius = 27
        button.backgroundColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        button.setTitle("APPLY FILTER", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 13)
        return button
    }
    
}
