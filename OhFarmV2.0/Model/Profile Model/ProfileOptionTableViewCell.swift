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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ name: String) {
        optionName.text = name
    }

}
