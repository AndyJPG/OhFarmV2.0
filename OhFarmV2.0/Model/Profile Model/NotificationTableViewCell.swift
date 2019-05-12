//
//  NotificationTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 11/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.sizeToFit()
        label.numberOfLines = 0
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithDate(_ data: String) {
        let dataSet = data.components(separatedBy: ";")
        
        if dataSet[0].contains("water") {
            iconImage.image = UIImage(named: "watering")
            label.text = dataSet[0]
            timeLabel.text = dataSet[1]
        } else {
            iconImage.image = UIImage(named: "harvest")
            label.text = dataSet[0]
            timeLabel.text = dataSet[1]
        }
    }

}
