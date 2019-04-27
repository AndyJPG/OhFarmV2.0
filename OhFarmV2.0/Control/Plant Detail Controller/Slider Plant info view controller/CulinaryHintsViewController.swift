//
//  CulinaryHintsViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CulinaryHintsViewController: UIViewController, IndicatorInfoProvider {

    var plant: Plant!
    var itemInfo: IndicatorInfo = "View"
    
    let hintsTitle: UILabel = {
        let label = UILabel()
        label.text = "How to use"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hintsBody: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font.withSize(16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    init(itemInfo: IndicatorInfo, plant: Plant) {
        self.plant = plant
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintsBody.text = plant.culinaryHintsInfo
        
        setupScrollView()
        setupViews()
    }
    
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }
    
    func setupViews(){
        
        contentView.addSubview(hintsTitle)
        hintsTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hintsTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        hintsTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40).isActive = true
        
        contentView.addSubview(hintsBody)
        hintsBody.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hintsBody.topAnchor.constraint(equalTo: hintsTitle.bottomAnchor, constant: 15).isActive = true
        hintsBody.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40).isActive = true
        hintsBody.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}
