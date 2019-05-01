//
//  CACollectionViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 30/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class CACollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ plant: Plant) {
        plantImage.layer.cornerRadius = 20
        plantImage.contentMode = .scaleAspectFill
        plantImage.image = UIImage(named: plant.cropName)
        plantName.text = plant.cropName
    }

}
