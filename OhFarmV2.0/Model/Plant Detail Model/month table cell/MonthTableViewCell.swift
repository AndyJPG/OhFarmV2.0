//
//  MonthTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 28/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class MonthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var janTag: UIView!
    @IBOutlet weak var febTag: UIView!
    @IBOutlet weak var marTag: UIView!
    @IBOutlet weak var aprTag: UIView!
    @IBOutlet weak var mayTag: UIView!
    @IBOutlet weak var junTag: UIView!
    
    @IBOutlet weak var julTag: UIView!
    @IBOutlet weak var augTag: UIView!
    @IBOutlet weak var septTag: UIView!
    @IBOutlet weak var octTag: UIView!
    @IBOutlet weak var novTag: UIView!
    @IBOutlet weak var decTag: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithData(_ plant: Plant) {
        let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        nameLabel.text = "Suitable Month"
        nameLabel.textColor = color
        iconImage.image = UIImage(named: "month")
        
        for month in plant.getSuitableMonth {
            switch month {
            case "January":
                janTag.backgroundColor = color
            case "February":
                febTag.backgroundColor = color
            case "March":
                marTag.backgroundColor = color
            case "April":
                aprTag.backgroundColor = color
            case "May":
                mayTag.backgroundColor = color
            case "June":
                junTag.backgroundColor =  color
            case "July":
                julTag.backgroundColor = color
            case "August":
                augTag.backgroundColor = color
            case "September":
                septTag.backgroundColor = color
            case "October":
                octTag.backgroundColor = color
            case "November":
                novTag.backgroundColor = color
            case "December":
                decTag.backgroundColor = color
            default: break
            }
        }
    }

}
