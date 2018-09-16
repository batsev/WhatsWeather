//
//  WeatherRequest.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 16.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

class WeatherRequest: APIRequest{
    var method = RequestType.GET
    var path = "weather"
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["q"] = name.getCityUrl
        parameters["APPID"] = "4a962855f207070356a7439004d3e2e5"
    }
}
