//
//  NetworkHandler.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NetworkHandler {
    
    // MARK: Fetch plant data
    func fetchPlantData() -> [Plant] {
        var plants = [Plant]()
        guard let fileName = Bundle.main.path(forResource: "plantData", ofType: "json") else {fatalError("Can not get plant data json file")}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard let data = optionalData, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {fatalError("Can not get jsonResponse")}
        guard let jsonArray = jsonResponse as? [[String: Any]] else {fatalError()}
        for dic in jsonArray {
            plants.append(Plant(dic))
        }
        return plants
    }
    
}
