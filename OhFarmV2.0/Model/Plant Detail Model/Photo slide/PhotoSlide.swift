//
//  PhotoSlide.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PhotoSlide: UIView {

    @IBOutlet weak var plantImage: UIImageView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configureWithData(_ url: String) {
        plantImage.downloaded(from: url)
        plantImage.contentMode = .scaleAspectFill
    }
}
