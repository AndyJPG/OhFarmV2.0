//
//  LocalData.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 25/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class LocalData {
    
    //MARK: Private save and load user data
    //Save for user
    func saveUserInfo(_ user: User) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: [user], requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    func loadUser() -> [User]?  {
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            return nil
        }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [User]
    }
    
    //Save Plants
    func savePlants(_ plants: [Plant]) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: plants, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "plants")
    }
    
    func loadPlants() -> [Plant]?  {
        guard let data = UserDefaults.standard.data(forKey: "plants") else {
            return nil
        }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Plant]
    }
    
}
