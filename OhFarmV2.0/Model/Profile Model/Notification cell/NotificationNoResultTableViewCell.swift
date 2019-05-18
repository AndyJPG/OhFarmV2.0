//
//  NotificationNoResultTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 18/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NotificationNoResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithData(_ text: String) {
        label.textAlignment = .center
        label.text = text
        label.textColor = .darkGray
        label.sizeToFit()
        
        self.isUserInteractionEnabled = false
    }

}
