//
//  WeatherModel.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

struct Temperature {
    let city: String
    let cityTemperature: String
    let tempIcon: String
    let country: String
    let weatherDescription: String
    init(city: String, cityTemperature: String, tempIcon: String, country: String, weatherDescription: String) {
        self.city = city
        self.cityTemperature = cityTemperature
        self.tempIcon = tempIcon + ".png"
        self.country = country
        self.weatherDescription = weatherDescription
    }
}

struct WeatherModel: Codable {
    let name: String
    let main: Main
    let sys: Sys
    let weather: [Weather]
}

struct Sys: Codable {
    let country: String
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
}
