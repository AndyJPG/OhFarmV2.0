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
    
    func configCell(_ name: String) {
        plantImage.layer.cornerRadius = 20
        plantImage.contentMode = .scaleAspectFill
        
        //Get image
        let plantN = name.replacingOccurrences(of: " ", with: "+")
        let imageUrl = "https://s3.amazonaws.com/ohfarmimages/\(plantN).jpg"
        plantImage.downloaded(from: imageUrl)
        
        //From local image file
//        plantImage.image = UIImage(named: name)
        
        plantName.text = name
    }

}
