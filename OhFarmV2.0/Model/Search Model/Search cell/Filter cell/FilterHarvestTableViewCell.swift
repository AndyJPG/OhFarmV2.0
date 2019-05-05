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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSlider()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupSlider() {
        let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        titleLabel.textColor = color
        rangeSlider.maxValue = 200
        rangeSlider.handleColor = .white
        rangeSlider.handleDiameter = 25.0
        rangeSlider.handleBorderWidth = 0.5
        rangeSlider.handleBorderColor = .lightGray
        rangeSlider.selectedHandleDiameterMultiplier = 1.0
        rangeSlider.lineHeight = 3
        rangeSlider.hideLabels = true
        rangeSlider.colorBetweenHandles = color
        rangeSlider.tintColor = .lightGray
    }

}
