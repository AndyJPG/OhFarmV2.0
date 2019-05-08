//
//  CheckListTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 8/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {
    
    //MARK: Variable
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithData(_ text: String) {
        instruction.text = text
    }
    
    private func setupButton() {
        checkButton.setImage(UIImage(named: "check"), for: .selected)
        checkButton.setImage(UIImage(named: "uncheck"), for: .normal)
    }
    
}
