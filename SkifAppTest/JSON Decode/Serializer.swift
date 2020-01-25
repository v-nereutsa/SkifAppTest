//
//  Serializer.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation

class Serializer {
    
    static let shared = Serializer()
    
    func decode(data: Data) throws -> Locations? {
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let location = try decoder.decode(Locations.self, from: data)
            return location
        } catch let error {
            print(error)
            return nil
        }
    }
    
}
