//
//  HomeUI.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class HomeUI: UIViewController {
    
    // MARK: Home plant cell style
    func homePlantCellStyle(_ cell: UITableViewCell, plant: Plant) -> UITableViewCell {
        guard let plantCell = cell as? HomeFarmTableViewCell else {fatalError()}
        plantCell.selectionStyle = .none
        plantCell.backgroundColor = .clear
        
        plantCell.cellBackground.layer.cornerRadius = 24
        plantCell.cellBackground.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        plantCell.cellBackground.layer.shadowRadius = 17
        plantCell.cellBackground.layer.shadowOpacity = 0.2
        plantCell.cellBackground.layer.shadowOffset = CGSize.zero
        
        plantCell.plantNameLabel.text = plant.cropName
        
        //Progress day
        //Calculate progress
        let calendar = Calendar.current
        let current = Date()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: current)
        let date2 = calendar.startOfDay(for: plant.harvestDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day else {fatalError()}
        
        if plant.harvested {
            plantCell.categoryLabel.text = "Ready for harvest"
        } else if plant.indoorList >= 3 || plant.outdoorList >= 6 {
            plantCell.categoryLabel.text = "\(days) days to go"
        } else {
            plantCell.categoryLabel.text = ""
        }
        
//        if plant.plantCategory == "vegetable" {
//            plantCell.categoryLabel.textColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
//        } else {
//            plantCell.categoryLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
//        }
        
        plantCell.categoryLabel.textColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
        
        plantCell.plantImage.image = plant.plantImage
        plantCell.plantImage.contentMode = .scaleAspectFill
        plantCell.plantImage.layer.cornerRadius = 24
        
        return plantCell
    }
    
    func addPlantImage() -> UIView {
        let background = UIView(frame: CGRect(origin: CGPoint(x: view.frame.width/2-100, y: view.frame.height/2-150), size: CGSize(width: 200, height: 200)))
        background.backgroundColor = .clear
        
        let image = UIImage(named: "addPlant")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        background.addSubview(imageView)
        
        return background
    }
    
    //MARK: Favourite Plant Cell Style
    func favouriteCell(_ cell: UITableViewCell, plant: Plant) -> UITableViewCell {
        guard let plantCell = cell as? FavouriteTableViewCell else {fatalError()}
        plantCell.selectionStyle = .none
        plantCell.backgroundColor = .clear
        
        plantCell.cellBackground.layer.cornerRadius = 24
        plantCell.cellBackground.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        plantCell.cellBackground.layer.shadowRadius = 17
        plantCell.cellBackground.layer.shadowOpacity = 0.2
        plantCell.cellBackground.layer.shadowOffset = CGSize.zero
        
        plantCell.plantNameLabel.text = plant.cropName
        
        plantCell.harvestTimeLabel.numberOfLines = 2
        plantCell.spacingLabel.numberOfLines = 2
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
        plantCell.harvestTimeLabel.attributedText = attributedString
        plantCell.spacingLabel.attributedText = spacingString
        
        
        plantCell.plantImage.image = plant.plantImage
        plantCell.plantImage.contentMode = .scaleAspectFill
        plantCell.plantImage.layer.cornerRadius = 24
        
        return plantCell
    }
    
}
