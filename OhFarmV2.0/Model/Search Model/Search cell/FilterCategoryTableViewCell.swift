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
        setimage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setimage() {
        bothButton.setImage(UIImage(named: "both"), for: .normal)
        bothButton.setImage(UIImage(named: "bothFill"), for: .selected)
        vegetableButton.setImage(UIImage(named: "veg"), for: .normal)
        vegetableButton.setImage(UIImage(named: "vegFill"), for: .selected)
        herbButton.setImage(UIImage(named: "herb"), for: .normal)
        herbButton.setImage(UIImage(named: "herbFill"), for: .selected)
        
        bothButton.imageView?.contentMode = .scaleAspectFit
        vegetableButton.imageView?.contentMode = .scaleAspectFit
        herbButton.imageView?.contentMode = .scaleAspectFit
    }

}
