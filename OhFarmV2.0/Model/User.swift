//
//  User.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 22/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding {
    
    // MARK: Variable
    var userName: String
    var farmPlants: [Plant] = []
    var favoritePlants: [Plant] = []
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    //MARK: Types
    struct PropertyKey {
        static let userName = "userName"
    }
    
    init(name: String) {
        self.userName = name
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey: PropertyKey.userName)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let userName = aDecoder.decodeObject(forKey: PropertyKey.userName) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: userName)
        
    }
    
}
