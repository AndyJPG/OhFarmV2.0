//
//  Filter.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class Filter {
    
    //MARK: Variable
    var category: [String]
    var location: [String]
    var minSpacing: Int
    var maxSpacing: Int
    var minHarvest: Int
    var maxHarvest: Int
    
    //Initialisation
    init(_ dic: [Any]){
        self.category = dic[0] as? Array ?? ["vegetable","herb"]
        self.location = dic[1] as? Array ?? ["indoor","outdoor"]
        self.minSpacing = dic[2] as? Int ?? 0
        self.maxSpacing = dic[3] as? Int ?? 100
        self.minHarvest = dic[4] as? Int ?? 0
        self.maxHarvest = dic[5] as? Int ?? 100
    }
}
