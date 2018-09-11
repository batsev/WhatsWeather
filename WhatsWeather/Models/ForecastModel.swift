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
    
    static func getForecast(forecast: ForecastModel) -> [ForecastTemperature]{
        let cityName = forecast.city.name
        let country = forecast.city.country
        var forecastTemperature = [ForecastTemperature]()
        var temps = [Temperature]()
        var times = [String]()
        var day = forecast.list.first?.dt_txt.dayOfTheWeek
        for threeHourForecast in forecast.list {
            if let weatherIcon = threeHourForecast.weather.first?.icon, let weatherDiscription = threeHourForecast.weather.first?.description{
                let weekday = threeHourForecast.dt_txt.dayOfTheWeek
                let temp = threeHourForecast.main.temp.kalvinToCalsius
                let time = threeHourForecast.dt_txt.timeOfTheDay
                if day == weekday {
                    temps.append(Temperature(city: cityName, cityTemperature: temp, tempIcon: weatherIcon, country: country, weatherDescription: weatherDiscription))
                    times.append(time)
                }
                else {
                    forecastTemperature.append(ForecastTemperature(weekday: day!, forecast: temps, time: times))
                    day=weekday
                    times=[]
                    temps=[]
                    times.append(time)
                    temps.append(Temperature(city: cityName, cityTemperature: temp, tempIcon: weatherIcon, country: country, weatherDescription: weatherDiscription))
                }
            }
        }
        return forecastTemperature
    }
}

struct ForecastModel: Decodable {
    let city: City
    let list: [List]
}

struct List: Decodable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct City: Decodable {
    let name: String
    let country: String
}
