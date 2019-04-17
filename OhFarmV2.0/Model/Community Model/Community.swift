//
//  Community.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 15/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class Community: NSObject, MKAnnotation {
    
    //MARK: Variables
    let title: String?
    let garden: String
    let contactEmail: String
    let coordinate: CLLocationCoordinate2D
    
    //MARK: Initialisation of community object
    init(_ dictionary: [String: Any]){
        self.title = dictionary["Garden"] as? String ?? "Community Garden"
        self.garden = dictionary["Garden"] as? String ?? "Community Garden"
        self.contactEmail = dictionary["ContactEmail"] as? String ?? "No Address"
        
        let latitude = dictionary["Latitude"] as? Double ?? 0
        let longitude = dictionary["Longitude"] as? Double ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //MARK: Set up annoation information
    //Set up subtitle for annoation
    var subtitle: String? {
        let text = "Contact Email: " + self.contactEmail
        return text
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
}
