//
//  FilterMonthTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 4/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class FilterMonthTableViewCell: UITableViewCell {

    //MARK: Months button
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
    
    //MARK: Months tag
    @IBOutlet weak var JanTag: UIView!
    @IBOutlet weak var FebTag: UIView!
    @IBOutlet weak var MarTag: UIView!
    @IBOutlet weak var AprTag: UIView!
    @IBOutlet weak var MayTag: UIView!
    @IBOutlet weak var JunTag: UIView!
    
    @IBOutlet weak var JulTag: UIView!
    @IBOutlet weak var AugTag: UIView!
    @IBOutlet weak var SepTag: UIView!
    @IBOutlet weak var OctTag: UIView!
    @IBOutlet weak var NovTag: UIView!
    @IBOutlet weak var DecTag: UIView!
    
    
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellName.text = "Suitable Month"
        cellName.textColor = color
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButton(_ months: [String]) {
        let buttons = [janButton,febButton,marButton,aprButton,mayButton,junButton,julButton,augButton,sepButton,octButton,novButton,decButton,anyButton]
        
        let tags = [JanTag,FebTag,MarTag,AprTag,MayTag,JunTag,JulTag,AugTag,SepTag,OctTag,NovTag,DecTag]
        let monthsText = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec","All"]
        
        let monthsPrefix = months.map { (month) -> String in
            return month.prefix(3).lowercased()
        }
        
        for (index,button) in buttons.enumerated() {
            button?.setTitleColor(.lightGray, for: .normal)
            button?.setTitleColor(color, for: .selected)
            button?.setTitle(monthsText[index], for: .normal)
            
            if monthsPrefix.contains(button?.title(for: .normal)?.lowercased() ?? "") {
                button?.isSelected = true
                if button?.title(for: .normal) != "All" {
                    tags[index]?.backgroundColor = color
                }
            } else {
                button?.isSelected = false
                if button?.title(for: .normal) != "All" {
                    tags[index]?.backgroundColor = .white
                }
            }
        }
            
//        if months[0].lowercased() == "all" {
//            anyButton.isSelected = true
//        } else {
//
//            for button in buttons {
//                if monthsPrefix.contains(button?.title(for: .normal)?.lowercased() ?? "") {
//                    button?.isSelected = true
//                } else {
//                    button?.isSelected = false
//                }
//            }
//        }
    }

}
