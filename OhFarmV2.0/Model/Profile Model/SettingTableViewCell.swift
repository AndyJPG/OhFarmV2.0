//
//  SettingTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 26/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrowIcon.image = arrowIcon.image?.withRenderingMode(.alwaysTemplate)
        arrowIcon.tintColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
