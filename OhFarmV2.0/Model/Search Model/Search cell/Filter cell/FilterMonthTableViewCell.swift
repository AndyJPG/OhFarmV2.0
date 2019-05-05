//
//  FilterMonthTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 4/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterMonthTableViewCell: UITableViewCell {

    @IBOutlet weak var janButton: UIButton!
    @IBOutlet weak var febButton: UIButton!
    @IBOutlet weak var marButton: UIButton!
    @IBOutlet weak var aprButton: UIButton!
    @IBOutlet weak var mayButton: UIButton!
    @IBOutlet weak var junButton: UIButton!
    
    @IBOutlet weak var julButton: UIButton!
    @IBOutlet weak var augButton: UIButton!
    @IBOutlet weak var sepButton: UIButton!
    @IBOutlet weak var octButton: UIButton!
    @IBOutlet weak var novButton: UIButton!
    @IBOutlet weak var decButton: UIButton!
    
    @IBOutlet weak var anyButton: UIButton!
    @IBOutlet weak var cellName: UILabel!
    
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellName.text = "Suitable Month"
        cellName.textColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButton(_ months: [String]) {
        let buttons = [janButton,febButton,marButton,aprButton,mayButton,junButton,julButton,augButton,sepButton,octButton,novButton,decButton,anyButton]
        
        janButton.setTitle("Jan", for: .normal)
        febButton.setTitle("Feb", for: .normal)
        marButton.setTitle("Mar", for: .normal)
        aprButton.setTitle("Apr", for: .normal)
        mayButton.setTitle("May", for: .normal)
        junButton.setTitle("Jun", for: .normal)
        julButton.setTitle("Jul", for: .normal)
        augButton.setTitle("Aug", for: .normal)
        sepButton.setTitle("Sep", for: .normal)
        octButton.setTitle("Oct", for: .normal)
        novButton.setTitle("Nov", for: .normal)
        decButton.setTitle("Dec", for: .normal)
        anyButton.setTitle("All", for: .normal)
        
        let monthsPrefix = months.map { (month) -> String in
            return month.prefix(3).lowercased()
        }
        
        for button in buttons {
            button?.setTitleColor(.lightGray, for: .normal)
            button?.setTitleColor(color, for: .selected)
        }
            
        if months[0].lowercased() == "all" {
            anyButton.isSelected = true
        } else {
            
            for button in buttons {
                if monthsPrefix.contains(button?.title(for: .normal)?.lowercased() ?? "") {
                    button?.isSelected = true
                } else {
                    button?.isSelected = false
                }
            }
            
        }
    }

}
