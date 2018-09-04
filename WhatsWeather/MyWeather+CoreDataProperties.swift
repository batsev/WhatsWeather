//
//  MyWeather+CoreDataProperties.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 03.09.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//
//

import Foundation
import CoreData


extension MyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyWeather> {
        return NSFetchRequest<MyWeather>(entityName: "MyWeather")
    }

    @NSManaged public var city: String
    @NSManaged public var cityTemperature: String
    @NSManaged public var tempIcon: String
    @NSManaged public var country: String
    @NSManaged public var weatherDescription: String

}
