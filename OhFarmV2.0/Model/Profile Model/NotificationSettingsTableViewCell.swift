//
//  NotificationSettingsTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 11/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NotificationSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        switchButton.setOn(false, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
