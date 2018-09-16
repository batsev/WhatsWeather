//
//  ForecastModel.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 24.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

struct ForecastTemperature {
    let weekday: String
    let forecast: [Temperature]
    let time: [String]
}

struct ForecastModel: Codable {
    struct List: Codable {
        let main: Main
        let weather: [Weather]
        let dt_txt: String
    }
    struct City: Codable {
        let name: String
        let country: String
    }
    let city: City
    let list: [List]
}

