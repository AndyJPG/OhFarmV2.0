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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bothLabel: UILabel!
    @IBOutlet weak var vegetableLabel: UILabel!
    @IBOutlet weak var herbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vegetableLabel.sizeToFit()
        vegetableLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setimage(_ type: Int) {
        
        if type == 0 {
            categoryLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
            bothButton.setImage(UIImage(named: "both"), for: .normal)
            bothButton.setImage(UIImage(named: "bothFill"), for: .selected)
            vegetableButton.setImage(UIImage(named: "veg"), for: .normal)
            vegetableButton.setImage(UIImage(named: "vegFill"), for: .selected)
            herbButton.setImage(UIImage(named: "herb"), for: .normal)
            herbButton.setImage(UIImage(named: "herbFill"), for: .selected)
            
            bothLabel.text = "Both Category"
            vegetableLabel.text = "Vegetable"
            herbLabel.text = "Herb"
            categoryLabel.text = "Category"
            
        } else if type == 1 {
            categoryLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
            bothButton.setImage(UIImage(named: "both"), for: .normal)
            bothButton.setImage(UIImage(named: "bothFill"), for: .selected)
            vegetableButton.setImage(UIImage(named: "veg"), for: .normal)
            vegetableButton.setImage(UIImage(named: "vegFill"), for: .selected)
            herbButton.setImage(UIImage(named: "herb"), for: .normal)
            herbButton.setImage(UIImage(named: "herbFill"), for: .selected)
            
            bothLabel.text = "by alphabetic"
            vegetableLabel.text = "by harvest time"
            herbLabel.text = "by spacing"
            categoryLabel.text = "Sorting method"
            
        }
        
        bothButton.imageView?.contentMode = .scaleAspectFit
        vegetableButton.imageView?.contentMode = .scaleAspectFit
        herbButton.imageView?.contentMode = .scaleAspectFit
    }

}
