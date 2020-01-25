//
//  Locations.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation

struct Locations: Decodable {
    var locations: [Location] = []
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var location: Location?
        while !container.isAtEnd {
            location = try container.decode(Location.self)
            if let loc = location {
                locations.append(loc)
            }
        }
        
      }
}
