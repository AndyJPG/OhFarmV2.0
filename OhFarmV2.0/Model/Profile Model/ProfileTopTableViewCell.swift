//
//  ProfileTopTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 26/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class ProfileTopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        setButtonImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ user: User) {
        if user.userName == "User" || user.userName == "First User" {
            userName.text = "Name"
        } else {
            userName.text = user.userName
        }
        userName.sizeToFit()
        
        profileImage.image = user.userImage
    }
    
    func setButtonImage() {
        
        let editImage = UIImage(named: "edit")
        let tintedImage = editImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        edit.setImage(tintedImage, for: .normal)
        edit.tintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        
        let cameraImage = UIImage(named: "camera")
        let cameraTintedImage = cameraImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        camera.setImage(cameraTintedImage, for: .normal)
        camera.tintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        
    }

}
