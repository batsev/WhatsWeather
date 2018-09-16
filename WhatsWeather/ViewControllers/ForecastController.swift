//
//  CityForecastController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 20.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class ForecastController: UICollectionViewController {
    
    private let colors = UIColor.palette()
    private let apiClient = APIClient()
    
    var temperature: Temperature?{
        didSet{
            guard let cityName = temperature?.city else {return}
            let request = ForecastRequest(name: cityName)
            var forecastTemperature = [ForecastTemperature]()
            apiClient.send(apiRequest: request) { (temp: ForecastModel) in
                let cityName = temp.city.name
                let country = temp.city.country
                var temps = [Temperature]()
                var times = [String]()
                var day = temp.list.first?.dt_txt.dayOfTheWeek
                for threeHourForecast in temp.list {
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
                self.forecast = forecastTemperature
                DispatchQueue.main.async {
                    self.collectionView?.performBatchUpdates({
                        let indexSet = IndexSet(integersIn: 0...0)
                        self.collectionView?.reloadSections(indexSet)
                    }, completion: nil)
                }
            }
        }
    }
    
    var forecast: [ForecastTemperature]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 0.9)
        let layout = UltravisualLayout()
        collectionView!.collectionViewLayout = layout
        collectionView?.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.identifier)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerAction(_:)))
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func swipeGestureRecognizerAction(_ gesture: UISwipeGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.identifier, for: indexPath) as! ForecastCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        cell.forecastTemperature = forecast?[indexPath.item]
        cell.temperature = self.temperature
        cell.firstCell = indexPath.item == 0
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = forecast?.count {
            return count
        } else {
            return 0
        }
    }
}


