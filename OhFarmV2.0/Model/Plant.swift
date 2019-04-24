//
//  Plant.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class Plant {
    
    //MARK: Variable
    let cropName: String
    let plantCategory: String
    let minSpacing: Int
    let maxSpacing: Int
    let minHarvestTime: Int
    let maxHarvestTime: Int
    let compatiblePlants: [String]
    let culinaryHints: [String]
    let plantStyle: String
    let plantingTechnique: [String]
    let fertilizer: String
    
    init(_ dic:[String:Any]) {
        self.cropName = dic["cropName"] as? String ?? ""
        self.plantCategory = dic["plantCategory"] as? String ?? ""
        self.minSpacing = dic["minSpace"] as? Int ?? 0
        self.maxSpacing = dic["maxSpace"] as? Int ?? 0
        self.minHarvestTime = dic["minHarvestTime"] as? Int ?? 0
        self.maxHarvestTime = dic["maxHarvestTime"] as? Int ?? 0
        self.plantStyle = dic["plantStyle"] as? String ?? ""
        self.fertilizer = dic["fertilizerName"] as? String ?? ""
        
        let cp = dic["compatiblePlants"] as? String ?? ""
        self.compatiblePlants = cp.components(separatedBy: ", ")
        let ch = dic["culinaryHints"] as? String ?? ""
        self.culinaryHints = ch.components(separatedBy: ", ")
        let pt = dic["plantingTechnique"] as? String ?? ""
        self.plantingTechnique = pt.components(separatedBy: ", ")
    }
    
    var plantImage: UIImage {
        return UIImage(named: cropName) ?? UIImage()
    }
    
    var plantInfoOne: [[String]] {
        let spacing = ["Spacing","\(minSpacing) cm - \(maxSpacing) cm"]
        let harvest = ["Harvest Time","\(minHarvestTime) weeks - \(maxHarvestTime) weeks"]
        return [spacing,harvest]
    }
    
    var plantingInfo: [[String]] {
        
        var plantingInfo: [[String]] = []
        
        if plantStyle == "Both" {
            plantingInfo.append(["Location", "Suitable for Indoor and Outdoor"])
        } else {
            plantingInfo.append(["Location", plantStyle])
        }
        
        plantingInfo.append(["Fertilizer", fertilizer])
        
        for item in plantingTechnique {
            if item.contains("depth") {
                plantingInfo.append(["Depth",item])
            }
            
            if item.contains("temperatures") {
                plantingInfo.append(["Temperature",item])
            }
        }
        
        return plantingInfo
    }
    
}
