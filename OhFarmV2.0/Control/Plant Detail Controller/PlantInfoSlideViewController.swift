//
//  PlantInfoSlideViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 24/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlantInfoSlideViewController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    
    // MARK: Variable
    var plant: Plant!
    var isFromHome: Bool!

    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 10
        settings.style.selectedBarBackgroundColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
//        buttonBarView.backgroundColor = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
        
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = PlantInfoOneTableViewController(style: .plain, itemInfo: "Sow", plant: plant, fromHome: isFromHome)
        let child_2 = PlantingInfoTableViewController(style: .plain, itemInfo: "Planting", plant: plant, fromHome: isFromHome)
        let child_3 = CulinaryHintsViewController(itemInfo: "Hints", plant: plant)
        
        guard isReload else {
            return [child_1, child_2, child_3]
        }
        
        var childViewControllers = [child_1, child_2, child_3]
        
        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
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
