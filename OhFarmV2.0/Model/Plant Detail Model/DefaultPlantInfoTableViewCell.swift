//
//  DefaultPlantInfoTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class DefaultPlantInfoTableViewCell: UITableViewCell {
    
    // MARK: Variable
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(_ data: [String]) {
        infoLabel.text = data[0]
        infoDetailLabel.text = data[1]
        infoIcon.contentMode = .scaleAspectFit
        
        if data[0] == "Compatiable Plants" {
            infoIcon.image = UIImage(named: "compat")
        } else if data[0] == "Avoid Plants" {
            infoIcon.image = UIImage(named: "avoid")
        } else {
            infoIcon.image = UIImage(named: data[0])
        }
    }
    
    func changeStylToBlack() {
        infoIcon.layer.cornerRadius = 30.0
        infoDetailLabel.text = nil
        infoLabel.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        infoLabel.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }

}
