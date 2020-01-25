//
//  ViewModelProtocol.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    var coordinateIndex: Int! {get set}
    func viewDidLoad(viewController: ViewInputProtocol)
    func onButtonClicked()
    func getAnimationTime() -> Double
}
