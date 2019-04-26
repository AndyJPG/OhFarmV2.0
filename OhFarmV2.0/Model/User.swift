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
    var userImage: UIImage
    var farmPlants: [Plant] = []
    var favoritePlants: [Plant] = []
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    //MARK: Types
    struct PropertyKey {
        static let userName = "userName"
        static let image = "profileImage"
    }
    
    init(name: String, userImage: UIImage?) {
        self.userName = name
        self.userImage = userImage ?? UIImage()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey: PropertyKey.userName)
        aCoder.encode(userImage, forKey: PropertyKey.image)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let userName = aDecoder.decodeObject(forKey: PropertyKey.userName) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage else {
            os_log("Unable to decode the image", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: userName, userImage: image)
        
    }
    
}
