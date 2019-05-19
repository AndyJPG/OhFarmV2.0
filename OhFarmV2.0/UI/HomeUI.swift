//
//  HomeUI.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class HomeUI: UIViewController {
    
    // MARK: Home plant cell style
    func homePlantCellStyle(_ cell: UITableViewCell, plant: Plant) -> UITableViewCell {
        let indoorPlantPoint = 4
        let outdoorPlantPoint = 5
        
        guard let plantCell = cell as? HomeFarmTableViewCell else {fatalError()}
        plantCell.selectionStyle = .none
        plantCell.backgroundColor = .clear
        
        plantCell.cellBackground.layer.cornerRadius = 24
        plantCell.cellBackground.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        plantCell.cellBackground.layer.shadowRadius = 17
        plantCell.cellBackground.layer.shadowOpacity = 0.2
        plantCell.cellBackground.layer.shadowOffset = CGSize.zero
        
        plantCell.plantNameLabel.text = plant.cropName
        
        //Progress day
        //Calculate progress
        let calendar = Calendar.current
//        guard let current = calendar.date(byAdding: .weekOfYear, value: 10, to: Date()) else {fatalError()}
        let current = Date()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: current)
        let date2 = calendar.startOfDay(for: plant.harvestDate)
        
        let components = calendar.dateComponents([.weekOfYear], from: date1, to: date2)
        guard let weeks = components.weekOfYear else {fatalError()}
        
        //Change text color and text display
        plantCell.categoryLabel.textColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
        
        if plant.harvested {
            plantCell.categoryLabel.text = "Ready for harvest"
        } else if plant.indoorList >= indoorPlantPoint || plant.outdoorList >= outdoorPlantPoint {
            plantCell.categoryLabel.text = "\(weeks) weeks to harvest"
        } else {
            plantCell.categoryLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
            plantCell.categoryLabel.text = plant.plantCategory.capitalized
        }
        
        let imageURL = plant.plantImageURL
        plantCell.plantImage.downloaded(from: imageURL[0])
        plantCell.plantImage.contentMode = .scaleAspectFill
        plantCell.plantImage.layer.cornerRadius = 24
        
        return plantCell
    }
    
    func addPlantImage() -> UIView {
        let background = UIView(frame: CGRect(origin: CGPoint(x: view.frame.width/2-100, y: view.frame.height/2-150), size: CGSize(width: 200, height: 200)))
        background.backgroundColor = .clear
        
        let image = UIImage(named: "addPlant")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        background.addSubview(imageView)
        
        return background
    }
    
    //MARK: Favourite Plant Cell Style
    func favouriteCell(_ cell: UITableViewCell, plant: Plant) -> UITableViewCell {
        guard let plantCell = cell as? FavouriteTableViewCell else {fatalError()}
        plantCell.selectionStyle = .none
        plantCell.backgroundColor = .clear
        
        plantCell.cellBackground.layer.cornerRadius = 24
        plantCell.cellBackground.layer.shadowColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
        plantCell.cellBackground.layer.shadowRadius = 17
        plantCell.cellBackground.layer.shadowOpacity = 0.2
        plantCell.cellBackground.layer.shadowOffset = CGSize.zero
        
        plantCell.plantNameLabel.text = plant.cropName
        
        plantCell.harvestTimeLabel.numberOfLines = 2
        plantCell.spacingLabel.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: plant.getHarvestString)
        let spacingString = NSMutableAttributedString(string: plant.getSpacingString)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        spacingString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, spacingString.length))
        
        // *** Set Attributed String to your label ***
        plantCell.harvestTimeLabel.attributedText = attributedString
        plantCell.spacingLabel.attributedText = spacingString
        
        let imageURL = plant.plantImageURL
        plantCell.plantImage.downloaded(from: imageURL[0])
        plantCell.plantImage.contentMode = .scaleAspectFill
        plantCell.plantImage.layer.cornerRadius = 24
        
        return plantCell
    }
    
    
}

//Bage button
class SSBadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    var badgeBackgroundColor = UIColor(red: 247/255, green: 81/255, blue: 77/255, alpha: 1) {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeToButon(badge: nil)
    }
    
    func addBadgeToButon(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addBadgeToButon(badge: nil)
        fatalError("init(coder:) has not been implemented")
    }
}
