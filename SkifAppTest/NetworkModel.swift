//
//  NetworkModel.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation

class NetworkModel: NetworkModelProtocol {
    
    var viewModel: ViewModelNetworkOutputProtocol?
    
    func subscribe(viewModel: ViewModelNetworkOutputProtocol) {
        self.viewModel = viewModel
    }
    
    func getJSONData() {
        URLSession.shared.dataTask(with: URL(string: "https://kz.skif.me/coordinates.json")!) { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    let locations = try Serializer.shared.decode(data: data!)
                    if let data = locations {
                        self.viewModel?.onDataReceived(data: data)
                    }
                } catch {
                    self.viewModel?.onErrorReceived()
                }
            }
        }.resume()
    }
}
