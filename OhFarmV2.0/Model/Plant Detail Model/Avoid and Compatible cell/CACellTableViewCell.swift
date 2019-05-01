//
//  CACellTableViewCell.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 30/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class CACellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        
        setupCollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Setup collection view
    private func setupCollection() {
        //TODO: need to setup collection view flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 100)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.collectionView.collectionViewLayout = flowLayout
        
    }
    
}
