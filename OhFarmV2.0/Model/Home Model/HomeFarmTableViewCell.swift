//
//  HomeFarmTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class HomeFarmTableViewCell: UITableViewCell {
    
    // MARK: Variable
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.progressTintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // Animated select
        if selected {
            UIView.animate(withDuration: 1.0) {
                self.cellBackground.backgroundColor = .lightGray
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.cellBackground.backgroundColor = .white
            }
        }
        
    }

}
