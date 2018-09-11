//
//  Networking.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 08.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

class GetWeather {
    private let openWeatherBaseUrl = "http://api.openweathermap.org/data/2.5/"
    private let openWeatherAPIKey = "4a962855f207070356a7439004d3e2e5"
    private let openWeatherIcon = "http://openweathermap.org/img/w"
    func getWeather(city: String, completion: @escaping (Temperature?) -> Void){
        let cityUrl = city.getCityUrl
        let weatherRequest = "\(openWeatherBaseUrl)weather?q=\(cityUrl)&APPID=\(openWeatherAPIKey)"
        if let weatherRequestURL = URL(string: weatherRequest) {
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: weatherRequestURL) { (data, response, error) in
                    guard let data = data else {return}
                    do {
                        let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                        completion(WeatherModel.getTemperature(weather: weather))
                    } catch let jsonError {
                        print(jsonError)
                        completion(nil)
                    }
                    }.resume()
            }
        }
    }
    func getForecast(city: String, completion: @escaping ([ForecastTemperature]?) -> Void){
        let cityUrl = city.getCityUrl
        let forecastRequest = "\(openWeatherBaseUrl)forecast?q=\(cityUrl)&APPID=\(openWeatherAPIKey)"
        if let forecastUrl = URL(string: forecastRequest){
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: forecastUrl, completionHandler: { (data, response, error) in
                    guard let data = data else {return}
                    do {
                        let forecast = try JSONDecoder().decode(ForecastModel.self, from: data)
                        completion(ForecastTemperature.getForecast(forecast: forecast))
                    } catch let jsonError{
                        print(jsonError)
                        completion(nil)
                    }
                }).resume()
            }
        }
    }
    
    func getWeatherIcon(icon: String, completion: @escaping (Data?) -> Void){
        let iconRequest = "\(openWeatherIcon)/\(icon).png"
        if let iconRequestURL = URL(string: iconRequest){
            URLSession.shared.dataTask(with: iconRequestURL) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    completion(nil)
                    return
                }
                completion(data)
            }.resume()
        }
    }
}
