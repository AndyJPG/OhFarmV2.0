//
//  NetworkHandler.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NetworkHandler {
    
    // MARK: Fetch Check list data
    func fetchCheckListData() -> [String:[String]] {
        var checkList = [String:[String]]()
        
        guard let fileName = Bundle.main.path(forResource: "checkList", ofType: "json") else {fatalError("Can not get check list data")}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard let data = optionalData, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {fatalError("Can not get jsonResponse")}
        guard let jsonArray = jsonResponse as? [[String: String]] else {fatalError()}
        
        for dic in jsonArray {
            guard let checkListName = dic["checkListType"] else {fatalError()}
            checkList[checkListName] = []
            
            for index in 1..<13 {
                guard let value = dic[String(index)] else {fatalError()}
                if !value.isEmpty {
                    checkList[checkListName]?.append(value)
                }
            }
        }
        
        return checkList
    }
    
    // MARK: Fetch plant data
    func fetchPlantData() -> [Plant] {
        var plants = [Plant]()
        guard let fileName = Bundle.main.path(forResource: "plantData", ofType: "json") else {fatalError("Can not get plant data json file")}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard let data = optionalData, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {fatalError("Can not get jsonResponse")}
        guard let jsonArray = jsonResponse as? [[String: Any]] else {fatalError()}
        for dic in jsonArray {
            guard let cropName = dic["cropName"] as? String else {fatalError()}
            guard let plantCategory = dic["plantCategory"] as? String else {fatalError()}
            guard let suitableMonth = dic["suitableMonth"] as? String else {fatalError()}
            guard let minSpacing = dic["minSpace"] as? Int else {fatalError()}
            guard let maxSpacing = dic["maxSpace"] as? Int else {fatalError()}
            guard let minHarvest = dic["minHarvestTime"] as? Int else {fatalError()}
            guard let maxHarvest = dic["maxHarvestTime"] as? Int else {fatalError()}
            guard let compatiblePlants = dic["compatiblePlants"] as? String else {fatalError()}
            guard let avoidInstructions = dic["avoidInstructions"] as? String else {fatalError()}
            guard let culinaryHints = dic["culinaryHints"] as? String else {fatalError()}
            guard let plantStyle = dic["plantStyle"] as? String else {fatalError()}
            guard let plantingTech = dic["plantingTechnique"] as? String else {fatalError()}
            guard let fertilizer = dic["fertilizerName"] as? String else {fatalError()}

            plants.append(Plant(cropName: cropName, plantCategory: plantCategory, suitableMonth: suitableMonth, minSpacing: minSpacing, maxSpacing: maxSpacing, minHarvestTime: minHarvest, maxHarvestTime: maxHarvest, compatiblePlants: compatiblePlants, avoidInstructions: avoidInstructions, culinaryHints: culinaryHints, plantStyle: plantStyle, plantingTechnique: plantingTech, fertilizer: fertilizer, compPlantList: [], avoidPlantList: [], harvestTime: Date(), indoorList: -1, outdoorList: -1))
        }
        return plants
    }
    
    // Add compa and avoid plant
    func completeData(_ plants: [Plant]) -> [Plant] {
                
        for plant in plants {
            if plant.getCompatiable[0].lowercased() != "none" {
                let compatPlantString = plant.getCompatiable.map({ (name) -> String in
                    return name.lowercased()
                })
                
                let compaPlants = plants.filter { (plant) -> Bool in
                    compatPlantString.contains(where: plant.cropName.lowercased().contains)
                }
                
                let compaPlantName = compaPlants.map { (plant) -> String in
                    return plant.cropName
                }
                
                plant.compPlantList = compaPlantName
            }
            
            if plant.getAvoid[0].lowercased() != "none" {
                let avoidPlantString = plant.getAvoid.map({ (name) -> String in
                    return name.lowercased()
                })
                
                let avoidPlants = plants.filter { (plant) -> Bool in
                    avoidPlantString.contains(where: plant.cropName.lowercased().contains)
                }
                
                let avoidPlantName = avoidPlants.map { (plant) -> String in
                    return plant.cropName
                }
                
                plant.avoidPlantList = avoidPlantName
            }
        }
        
        return plants
        
    }
    
}
