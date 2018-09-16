//
//  IconRequest.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 16.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

class ForecastRequest: APIRequest{
    var method = RequestType.GET
    var path = "forecast"
    var parameters = [String : String]()
    
    init(name: String) {
        parameters["q"] = name.getCityUrl
        parameters["APPID"] = "4a962855f207070356a7439004d3e2e5"
    }
    
}
