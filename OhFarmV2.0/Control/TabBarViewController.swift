//
//  TabBarViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        UITabBar.appearance().tintColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        UITabBar.appearance().backgroundColor = .white
    }

}
