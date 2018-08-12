//
//  WeatherModel.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let name: String
    let main: Main
    let sys: Sys
    let weather: [Weather]
}

struct Sys: Decodable {
    let country: String
}

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
}

struct Temperature {
    let city: String
    let cityTemperature: String
    let tempIcon: String
    let country: String
}
