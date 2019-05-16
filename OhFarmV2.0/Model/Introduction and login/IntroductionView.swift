//
//  IntroductionView.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 1/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class IntroductionView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!

    //For last page
    @IBOutlet weak var lastPageImage: UIImageView!
    @IBOutlet weak var lastPageLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configWithData(_ data: [String]) {
        //Set hidden for last page image and label
        lastPageImage.isHidden = true
        lastPageLabel.isHidden = true
        button.isHidden = true
        
        //Setup for image view
        imageView.layer.cornerRadius = 24
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        imageView.layer.shadowRadius = 17
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize.zero
        imageView.contentMode = .scaleAspectFill
        
        title.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        detail.textColor = .darkGray
        
        if data[1] == "Last" || data[1] == "First" {
            lastPageImage.isHidden = false
            lastPageLabel.isHidden = false
            button.isHidden = false
            detail.isHidden = true
            title.isHidden = true
            skipButton.isHidden = true
            
            lastPageImage.image = UIImage(named: data[0])
            lastPageImage.contentMode = .scaleAspectFit
            lastPageLabel.text = data[2]
            lastPageLabel.textAlignment = .center
            lastPageLabel.textColor = .white
            
            //Setup get start button
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setTitle("Get started", for: .normal)
            button.tintColor = .darkGray
            
            imageView.backgroundColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        } else {
            imageView.image = UIImage(named: data[0])
            title.text = data[1]
            detail.text = data[2]
        }
        
    }
}
