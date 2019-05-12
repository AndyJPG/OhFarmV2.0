//
//  NavigationController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 10/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "back")
        
        self.navigationBar.backIndicatorImage = image
        self.navigationBar.backIndicatorTransitionMaskImage = image
        
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = color
        self.navigationBar.barStyle = .black
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
