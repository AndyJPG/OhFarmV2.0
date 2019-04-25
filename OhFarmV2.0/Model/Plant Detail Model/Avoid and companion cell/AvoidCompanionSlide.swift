//
//  AvoidCompanionSlide.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class AvoidCompanionSlide: UIView {

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configWithData(_ plant: String) {
        plantName.text = plant
        plantImage.image = UIImage(named: plant)
        plantImage.contentMode = .scaleAspectFill
    }

}
