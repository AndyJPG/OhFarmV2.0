//
//  FilterLocationTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterLocationTableViewCell: UITableViewCell {

    //MARK: Variable
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var indoorButton: UIButton!
    @IBOutlet weak var outdoorButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
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
        locationLabel.text = "Location"
        locationLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        bothButton.setImage(UIImage(named: "both"), for: .normal)
        bothButton.setImage(UIImage(named: "bothFill"), for: .selected)
        indoorButton.setImage(UIImage(named: "indoor"), for: .normal)
        indoorButton.setImage(UIImage(named: "indoorFill"), for: .selected)
        outdoorButton.setImage(UIImage(named: "outdoor"), for: .normal)
        outdoorButton.setImage(UIImage(named: "outdoorFill"), for: .selected)
        
        bothButton.imageView?.contentMode = .scaleAspectFit
        indoorButton.imageView?.contentMode = .scaleAspectFit
        outdoorButton.imageView?.contentMode = .scaleAspectFit
    }

}
