//
//  FavouriteTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 27/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var harvestTimeLabel: UILabel!
    @IBOutlet weak var spacingLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            UIView.animate(withDuration: 1.0) {
                self.cellBackground.backgroundColor = .lightGray
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.cellBackground.backgroundColor = .white
            }
        }
    }

}
