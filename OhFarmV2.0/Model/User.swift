//
//  User.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class User {
    
    // MARK: Variable
    var userName: String
    var farmPlants: [Plant]
    
    init(name: String, plants: [Plant]){
        self.userName = name
        self.farmPlants = plants
    }
    
}
