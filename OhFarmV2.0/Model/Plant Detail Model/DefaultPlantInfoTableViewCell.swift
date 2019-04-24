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
        infoIcon.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(_ data: [String]) {
        infoLabel.text = data[0]
        infoDetailLabel.text = data[1]
    }
    
    func changeStylToBlack() {
        infoIcon.layer.cornerRadius = 30.0
        infoDetailLabel.text = nil
        infoLabel.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        infoLabel.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }

}
