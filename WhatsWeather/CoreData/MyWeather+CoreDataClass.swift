//
//  MyWeather+CoreDataClass.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//
//

import Foundation
import CoreData


public class MyWeather: NSManagedObject {

    class func createMyWeather(on temperature: Temperature, with context: NSManagedObjectContext) -> MyWeather{
        let myWeather = MyWeather(context: context)
        myWeather.city = temperature.city
        return myWeather
    }
}
