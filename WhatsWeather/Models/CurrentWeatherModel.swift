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
}

struct WeatherModel: Decodable {
    let name: String
    let main: Main
    let sys: Sys
    let weather: [Weather]
    
    static func getTemperature(weather: WeatherModel) -> Temperature{
        let cityName = weather.name
        let cityTemp = weather.main.temp.kalvinToCalsius
        let countryName = weather.sys.country
        let weatherIcon = weather.weather.first?.icon
        let weatherDiscription = weather.weather.first?.description
        return Temperature(city: cityName, cityTemperature: cityTemp, tempIcon: weatherIcon!, country: countryName, weatherDescription: weatherDiscription!)
    }
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
