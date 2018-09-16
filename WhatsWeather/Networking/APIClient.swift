//
//  APIClient.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 16.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import Foundation

class APIClient {
    private var baseURL = URL(string: "http://api.openweathermap.org/data/2.5/")!
    private var iconURL = URL(string: "http://openweathermap.org/img/w/")!
    
    func send<T: Codable>(apiRequest: APIRequest, completion: @escaping (T) -> ()){
        let request = apiRequest.request(with: baseURL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let model: T = try JSONDecoder().decode(T.self, from: data)
                completion(model)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func iconGetter(icon: String, completion: @escaping (Data?) -> ()){
        let iconRequest = URL(string: icon, relativeTo: iconURL)
        URLSession.shared.dataTask(with: iconRequest!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                completion(nil)
                return
            }
            completion(data)
            }.resume()
        
    }
}
