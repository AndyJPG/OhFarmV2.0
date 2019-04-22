//
//  FilterHarvestTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterHarvestTableViewCell: UITableViewCell {
    
    //MARK: Variable
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}