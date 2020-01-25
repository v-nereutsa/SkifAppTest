//
//  ViewModelNetworkOutputProtocol.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation

protocol ViewModelNetworkOutputProtocol {
    func onDataReceived(data: Locations)
    func onErrorReceived()
}
