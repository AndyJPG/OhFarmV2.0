//
//  AppDelegate.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 15/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: User?
    let localData = LocalData()
    let netWork = NetworkHandler()
    var plants = [Plant]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: Retrieve data
        if let userInfo = localData.loadUser() {
            user = userInfo[0]
        } else {
            user = User(name: "First User", userImage: UIImage(named: "userProfile") ?? UIImage(), farm: [], favourite: [])
        }
        
        let myGroup = DispatchGroup()
        
        //Thread to fetch and complete data
        myGroup.enter()
        plants = netWork.fetchPlantData()
        plants = netWork.completeData(plants)
        myGroup.leave()
        
        myGroup.notify(queue: .main) {
            print("Finished complete data.")
        }
        
        //Load screen
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController = storyBoard.instantiateViewController(withIdentifier: "Onboarding")
        window?.rootViewController = initialViewController
        
        //Check if onboarding performed
        if user?.userName != "First User" {
            
            initialViewController = storyBoard.instantiateViewController(withIdentifier: "Mainapp")
            window?.rootViewController = initialViewController
            
            // Override point for customization after application launch.
            //Share data across tab bar controllers
            guard let tabBarController = window?.rootViewController as? UITabBarController,
                let viewControllers = tabBarController.viewControllers else {
                    return true
            }
            
            for (_, viewController) in viewControllers.enumerated() {
                if let navigationController = viewController as? UINavigationController {
                    if let homeTableVC = navigationController.topViewController as? HomeTableViewController {
                        homeTableVC.user = user
                    } else if let searchTableVC = navigationController.topViewController as? PlantSearchTableViewController {
                        searchTableVC.user = user
                        searchTableVC.originalPlants = plants
                    }
                }
                if let profileTableVC = viewController as? ProfileTableViewController {
                    profileTableVC.user = user
                }
            }
            
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

