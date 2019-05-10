//
//  PlantCheckBoxCollectionViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 10/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class PlantCheckBoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var rightBar: UIView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var checkBoxLabel: UILabel!
    
    override func awakeFromNib() {
        checkBox.setImage(UIImage(named: "check"), for: .selected)
        checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
        topBar.backgroundColor = .lightGray
    }
    
}
