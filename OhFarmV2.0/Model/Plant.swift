//
//  Plant.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 20/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class Plant: NSObject, NSCoding {
    
    //MARK: Variable
    let cropName: String
    let plantCategory: String
    let suitableMonth: String
    let minSpacing: Int
    let maxSpacing: Int
    let minHarvestTime: Int
    let maxHarvestTime: Int
    let compatiblePlants: String
    let avoidInstructions: String
    let culinaryHints: String
    let plantStyle: String
    let plantingTechnique: String
    let fertilizer: String
    
    var compPlantList: [Plant] = []
    var avoidPlantList: [Plant] = []
    
    //MARK: Return variable
    var plantImage: UIImage {
        return UIImage(named: cropName) ?? UIImage()
    }
    
    var getSpacingString: String {
        return "Spacing:\n\(minSpacing) cm - \(maxSpacing) cm"
    }
    
    var getHarvestString: String {
        return "Harvest Time:\n\(minHarvestTime) weeks - \(maxHarvestTime) weeks"
    }
    
    var plantInfoOne: [[String]] {
        let month = getSuitableMonth
        let spacing = ["Spacing","\(minSpacing) cm - \(maxSpacing) cm"]
        let harvest = ["Harvest Time","\(minHarvestTime) weeks - \(maxHarvestTime) weeks"]
        return [month,spacing,harvest]
    }
    
    var plantingInfo: [[String]] {
        
        var plantingInfo: [[String]] = []
        
        if plantStyle == "Both" {
            plantingInfo.append(["Location", "Suitable for both Indoor and Outdoor"])
        } else {
            plantingInfo.append(["Location", "Suitable for \(plantStyle)"])
        }
        
        plantingInfo.append(["Fertilizer", fertilizer])
        
        //Planting techniques
        let plantingTech = plantingTechnique.components(separatedBy: ", ")
        
        for item in plantingTech {
            if item.contains("depth") {
                plantingInfo.append(["Depth",item])
            }
            
            if item.contains("temperatures") {
                plantingInfo.append(["Temperature",item])
            }
        }
        
        //Avoid and compatiable
        let plantC: [String] = compatiblePlants.components(separatedBy: ", ")
        
        var cpText = ""
        if plantC[0].lowercased() == "none" {
            cpText = "None"
        } else {
            for cp in plantC {
                cpText += "- \(cp)\n"
            }
        }
        plantingInfo.append(["Compatiable Plants", cpText])
        
        let plantA: [String] = avoidInstructions.components(separatedBy: ", ")
        
        var apText = ""
        if plantA[0].lowercased() == "none" {
            apText = "None"
        } else {
            for ap in plantA {
                apText += "- \(ap)\n"
            }
        }
        plantingInfo.append(["Avoid Plants", apText])
        
        return plantingInfo
    }
    
    var culinaryHintsInfo: String {
        let info = culinaryHints.components(separatedBy: ", ")
        var text = ""
        for hint in info {
            text += "\u{2022} \(hint)\n"
        }
        return text
    }
    
    //Get suitable month string
    var getSuitableMonth: [String] {
        let month = suitableMonth.components(separatedBy: ",")
        return month
    }
    
    //Get compatible plant only string
    var getCompatiable: [String] {
        let compat = compatiblePlants.components(separatedBy: ", ")
        return compat
    }
    
    //Get avoid plant only string
    var getAvoid: [String] {
        let avoid = avoidInstructions.components(separatedBy: ", ")
        return avoid
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("plants")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let plantCategory = "plantCategory"
        static let suitableMonth = "suitableMonth"
        static let minSpace = "minSpace"
        static let maxSpace = "maxSpace"
        static let minHarvest = "minHarvest"
        static let maxHarvest = "maxHarvest"
        static let compatiblePlants = "compatiblePlants"
        static let avoidInstructions = "avoidInstructions"
        static let culinaryHints = "culinaryHints"
        static let plantStyle = "plantStyle"
        static let plantingTechnique = "plantingTechnique"
        static let fertilizer = "fertilizer"
        static let compPlantList = "compatiblePlant"
        static let avoidPlantList = "avoidPlantList"
    }
    
    init(cropName: String, plantCategory: String, suitableMonth: String, minSpacing: Int, maxSpacing: Int, minHarvestTime: Int, maxHarvestTime: Int, compatiblePlants: String, avoidInstructions: String, culinaryHints: String, plantStyle: String, plantingTechnique: String, fertilizer: String, compPlantList: [Plant]?, avoidPlantList: [Plant]?) {
        self.cropName = cropName
        self.plantCategory = plantCategory
        self.suitableMonth = suitableMonth
        self.minSpacing = minSpacing
        self.maxSpacing = maxSpacing
        self.minHarvestTime = minHarvestTime
        self.maxHarvestTime = maxHarvestTime
        self.plantStyle = plantStyle
        self.fertilizer = fertilizer
        self.compatiblePlants = compatiblePlants
        self.avoidInstructions = avoidInstructions
        self.culinaryHints = culinaryHints
        self.plantingTechnique = plantingTechnique
        self.compPlantList = compPlantList ?? []
        self.avoidPlantList = avoidPlantList ?? []
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cropName, forKey: PropertyKey.name)
        aCoder.encode(plantCategory, forKey: PropertyKey.plantCategory)
        aCoder.encode(suitableMonth, forKey: PropertyKey.suitableMonth)
        aCoder.encode(minSpacing, forKey: PropertyKey.minSpace)
        aCoder.encode(maxSpacing, forKey: PropertyKey.maxSpace)
        aCoder.encode(minHarvestTime, forKey: PropertyKey.minHarvest)
        aCoder.encode(maxHarvestTime, forKey: PropertyKey.maxHarvest)
        aCoder.encode(compatiblePlants, forKey: PropertyKey.compatiblePlants)
        aCoder.encode(avoidInstructions, forKey: PropertyKey.avoidInstructions)
        aCoder.encode(culinaryHints, forKey: PropertyKey.culinaryHints)
        aCoder.encode(plantStyle, forKey: PropertyKey.plantStyle)
        aCoder.encode(plantingTechnique, forKey: PropertyKey.plantingTechnique)
        aCoder.encode(fertilizer, forKey: PropertyKey.fertilizer)
        
        aCoder.encode(compPlantList, forKey: PropertyKey.compPlantList)
        aCoder.encode(avoidPlantList, forKey: PropertyKey.avoidPlantList)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let plantCategory = aDecoder.decodeObject(forKey: PropertyKey.plantCategory) as? String else {return nil}
        
        let minSpace = aDecoder.decodeInteger(forKey: PropertyKey.minSpace)
        let maxSpace = aDecoder.decodeInteger(forKey: PropertyKey.maxSpace)
        let minHarvest = aDecoder.decodeInteger(forKey: PropertyKey.minHarvest)
        let maxHarvest = aDecoder.decodeInteger(forKey: PropertyKey.maxHarvest)
        
        guard let compatiblePlants = aDecoder.decodeObject(forKey: PropertyKey.compatiblePlants) as? String else {return nil}
        guard let avoidInstructions = aDecoder.decodeObject(forKey: PropertyKey.avoidInstructions) as? String else {return nil}
        guard let culinaryHints = aDecoder.decodeObject(forKey: PropertyKey.culinaryHints) as? String else {return nil}
        guard let plantStyle = aDecoder.decodeObject(forKey: PropertyKey.plantStyle) as? String else {return nil}
        guard let plantingTechnique = aDecoder.decodeObject(forKey: PropertyKey.plantingTechnique) as? String else {return nil}
        guard let fertilizer = aDecoder.decodeObject(forKey: PropertyKey.fertilizer) as? String else {return nil}
        guard let suitableMonth = aDecoder.decodeObject(forKey: PropertyKey.suitableMonth) as? String else {return nil}
        
        guard let compPlants = aDecoder.decodeObject(forKey: PropertyKey.compPlantList) as? [Plant] else {return nil}
        guard let avoidPlants = aDecoder.decodeObject(forKey: PropertyKey.avoidPlantList) as? [Plant] else {return nil}
        
        
        // Must call designated initializer.
        self.init(cropName: name, plantCategory: plantCategory, suitableMonth: suitableMonth, minSpacing: minSpace, maxSpacing: maxSpace, minHarvestTime: minHarvest, maxHarvestTime: maxHarvest, compatiblePlants: compatiblePlants, avoidInstructions: avoidInstructions, culinaryHints: culinaryHints, plantStyle: plantStyle, plantingTechnique: plantingTechnique, fertilizer: fertilizer, compPlantList: compPlants, avoidPlantList: avoidPlants)
        
    }
    
}
