//
//  FilterCategoryTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterCategoryTableViewCell: UITableViewCell {
    
    //MARK: Variable
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var vegetableButton: UIButton!
    @IBOutlet weak var herbButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}