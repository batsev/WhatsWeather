//
//  WeatherViewModel.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 18.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {
    let temperature: String
    let city: String
    var icon: String
    
    private let apiClient = APIClient()
    
    init(weather: Temperature) {
        self.temperature = weather.cityTemperature
        self.city = weather.city
        self.icon = weather.tempIcon
    }
    func fetchIcon(completion: @escaping (UIImage) -> ()) {
        apiClient.iconGetter(icon: self.icon) { data in
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data)  else {return}
                completion(image)
            }
        }
    }
    
}

