//
//  ProfileOptionTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 26/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class ProfileOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionIcon: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var badgeBackground: UIView!
    @IBOutlet weak var badgeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        badgeBackground.isHidden = true
        badgeValue.isHidden = true
        
        badgeBackground.layer.cornerRadius = badgeBackground.frame.height/2
        badgeBackground.backgroundColor = UIColor(red: 247/255, green: 81/255, blue: 77/255, alpha: 1)
        badgeValue.textColor = .white
        badgeValue.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ name: String, icon: String) {
        optionName.text = name
        optionIcon.image = UIImage(named: icon)
        optionIcon.image = optionIcon.image?.withRenderingMode(.alwaysTemplate)
        optionIcon.tintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    }

}
