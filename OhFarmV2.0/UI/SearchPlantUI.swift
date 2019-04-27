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
    
    //Filter Bottom Button
    func filterBottomButton() -> UIButton {
        let button = UIButton(frame: CGRect(origin: CGPoint(x:view.frame.width/2-143.5, y: view.frame.height-50), size: CGSize(width: 287, height: 40)))
        button.layer.cornerRadius = button.frame.height/2
        button.backgroundColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        button.setTitle("Apply Filter", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        return button
    }
    
    func filterBottomButtonBackground() -> UIView {
        let background = UIView(frame: CGRect(origin: CGPoint(x: 0, y: view.frame.height-60), size: CGSize(width: view.frame.width, height: 60)))
        
        background.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        background.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([blurView.heightAnchor.constraint(equalTo: background.heightAnchor),blurView.widthAnchor.constraint(equalTo: background.widthAnchor),])
        
        return background
    }
    
    //MARK: Search Plant Cell Style
    func searchPlantCell(_ cell: UITableViewCell, plant: Plant) -> UITableViewCell {
        guard let plantCell = cell as? SearchPlantTableViewCell else {fatalError()}
        plantCell.selectionStyle = .none
        plantCell.backgroundColor = .clear
        
        plantCell.cellBackground.layer.cornerRadius = 24
        plantCell.cellBackground.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        plantCell.cellBackground.layer.shadowRadius = 17
        plantCell.cellBackground.layer.shadowOpacity = 0.2
        plantCell.cellBackground.layer.shadowOffset = CGSize.zero
        
        plantCell.plantNameLabel.text = plant.cropName
        
        plantCell.plantHarvestLabel.numberOfLines = 2
        plantCell.plantSpacingLabel.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: plant.getHarvestString)
        let spacingString = NSMutableAttributedString(string: plant.getSpacingString)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        spacingString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, spacingString.length))
        
        // *** Set Attributed String to your label ***
        plantCell.plantHarvestLabel.attributedText = attributedString
        plantCell.plantSpacingLabel.attributedText = spacingString
        
        
        
//        if plant.plantCategory == "vegetable" {
//            plantCell.plantHarvestLabel.textColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
//        } else {
//            plantCell.plantHarvestLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
//        }
        
//        plantCell.plantSpacingLabel.numberOfLines = 2
//        if plant.plantStyle == "Both" {
//            plantCell.plantStyleLabel.text = "Suitable for\nIndoor and Outdoor"
//            plantCell.plantStyleLabel.sizeToFit()
//        } else {
//            plantCell.plantStyleLabel.text = "Suitable for \(plant.plantStyle)"
//        }
        
        plantCell.plantImage.image = plant.plantImage
        plantCell.plantImage.contentMode = .scaleAspectFill
        plantCell.plantImage.layer.cornerRadius = 24
        
        return plantCell
    }
    
}
