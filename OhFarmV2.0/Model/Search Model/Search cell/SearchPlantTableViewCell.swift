//
//  SearchPlantTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class SearchPlantTableViewCell: UITableViewCell {
    
    //MARK: Variable
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantSpacingLabel: UILabel!
    @IBOutlet weak var plantHarvestLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var cellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
