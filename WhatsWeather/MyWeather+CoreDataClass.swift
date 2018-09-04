//
//  MyWeather+CoreDataClass.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 03.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//
//

import Foundation
import CoreData


public class MyWeather: NSManagedObject {
    class func createMyWeather(weather: WeatherModel) -> MyWeather {
        let cityName = weather.name
        let cityTemp = weather.main.temp.kalvinToCalsius
        let countryName = weather.sys.country
        let myWeather = MyWeather(context: PersistenceManager.shared.context)
        myWeather.city = cityName
        myWeather.cityTemperature = cityTemp
        myWeather.country = countryName
        if let weatherIcon = weather.weather.first?.icon {
        myWeather.tempIcon = weatherIcon
        }
        if let weatherDescription = weather.weather.first?.description{
        myWeather.weatherDescription = weatherDescription
        }
        return myWeather
    }

}
