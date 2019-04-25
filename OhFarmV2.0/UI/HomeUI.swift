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
        plantCell.categoryLabel.text = plant.plantCategory
        
        if plant.plantCategory == "vegetable" {
            plantCell.categoryLabel.textColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
        } else {
            plantCell.categoryLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        }
        
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
    
}
