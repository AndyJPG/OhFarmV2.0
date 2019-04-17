//
//  MKPlacemark+Extension.swift
//  OhFarmV2.0
//
//  Created by Peigeng Jiang on 17/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}

