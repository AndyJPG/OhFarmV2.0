//
//  PlantPhotoCollectionViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 10/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PlantPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    
    override func awakeFromNib() {
        plantImage.layer.cornerRadius = 24
        plantImage.contentMode = .scaleAspectFill
    }
    
}
