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
    @IBOutlet weak var compareCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        compareCheck.setImage(UIImage(named: "check"), for: .selected)
        compareCheck.setImage(UIImage(named: "uncheck"), for: .normal)
        compareCheck.isHidden = true
//        plantImage.image = UIImage(named: "loadingImage")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            UIView.animate(withDuration: 0.5) {
                self.cellBackground.backgroundColor = .groupTableViewBackground
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.cellBackground.backgroundColor = .white
            }
        }
    }
    
    func loadingMode(_ on: Bool) {
        if on {
            plusButton.isHidden = true
            compareCheck.isHidden = true
            plantNameLabel.text = "                    "
            plantNameLabel.backgroundColor = .groupTableViewBackground
            plantSpacingLabel.text = "        "
            plantSpacingLabel.backgroundColor = .groupTableViewBackground
            plantHarvestLabel.text = "        "
            plantHarvestLabel.backgroundColor = .groupTableViewBackground
            plantImage.backgroundColor = .groupTableViewBackground
        } else {
            plusButton.isHidden = false
            plantNameLabel.backgroundColor = .clear
            plantSpacingLabel.backgroundColor = .clear
            plantHarvestLabel.backgroundColor = .clear
            plantImage.backgroundColor = .clear
        }
    }
    
    func isCompare(_ on: Bool) {
        if on {
            plusButton.alpha = 1
            compareCheck.alpha = 0
            UIView.animate(withDuration: 0.8) {
                self.plusButton.alpha = 0
                self.compareCheck.alpha = 1
            }
        } else {
            plusButton.alpha = 1
            compareCheck.alpha = 0
        }
    }

}
