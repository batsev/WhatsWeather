//
//  CityForecastController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 20.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class ForecastController: UICollectionViewController {
    
    let colors = UIColor.palette()
    
    var temperature: Temperature?{
        didSet{
            let weatherGetter = GetWeather()
            guard let cityName = temperature?.city else {return}
            weatherGetter.getForecast(city: cityName) { (temp) in
                self.forecast = temp
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


