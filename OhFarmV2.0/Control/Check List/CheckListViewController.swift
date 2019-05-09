//
//  CheckListViewController.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 8/5/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CheckListViewController: ButtonBarPagerTabStripViewController {
    
    //MARK: Variable
    var plant: Plant!
    var checkList = [String:[String]]()
    var isReload = false
    let color = UIColor(red: 96/255, green: 186/255, blue: 114/255, alpha: 1)
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = color
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 10
        settings.style.selectedBarBackgroundColor = color
        
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let indoorList = checkList["indoor"], let outdoorList = checkList["outdoor"] else {fatalError()}
        let child_1 = IndoorTableViewController(style: .plain, itemInfo: "Indoor", checkList: indoorList, plant: plant)
        let child_2 = IndoorTableViewController(style: .plain, itemInfo: "Outdoor", checkList: outdoorList, plant: plant)
        
        guard isReload else {
            if plant.plantStyle.lowercased() == "both" {
                
                if plant.indoorList >= 0 && plant.outdoorList < 0 {
                    return [child_1]
                } else if plant.indoorList < 0 && plant.outdoorList >= 0 {
                    return [child_2]
                }
                
            } else if plant.plantStyle == "Indoor" {
                return [child_1]
            } else if plant.plantStyle == "Outdoor" {
                return [child_2]
            }
            return [child_1, child_2]
        }
        
        var childViewControllers = [child_1, child_2]
        
        //Return the checklist user choosed
        if plant.plantStyle.lowercased() == "both" {
            
            if plant.indoorList >= 0 && plant.outdoorList < 0 {
                childViewControllers = [child_1]
            } else if plant.indoorList < 0 && plant.outdoorList >= 0 {
                childViewControllers = [child_2]
            }
            
        } else if plant.plantStyle == "Indoor" {
            childViewControllers = [child_1]
        } else if plant.plantStyle == "Outdoor" {
            childViewControllers = [child_2]
        }
        
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
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }

}
