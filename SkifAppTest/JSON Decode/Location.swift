//
//  Location.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Decodable {
    var time: Date
    var coordinate: CLLocationCoordinate2D
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var time = Date()
        var latitude = 0.0
        var longitude = 0.0
        while !container.isAtEnd {
            time = try container.decode(Date.self)
            latitude = try container.decode(Double.self)
            longitude = try container.decode(Double.self)
        }
        self.time = time
        self.coordinate = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        
    }
}
