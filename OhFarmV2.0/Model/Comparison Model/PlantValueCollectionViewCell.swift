//
//  PlantValueCollectionViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 10/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PlantValueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rightBar: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        rightBar.backgroundColor = .lightGray
        topBar.backgroundColor = .lightGray
        value.sizeToFit()
        self.backgroundColor = .white
    }
    
}
