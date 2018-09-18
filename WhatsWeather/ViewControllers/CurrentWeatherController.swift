//
//  ViewController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class CurrentWeatherController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCityProtocol{
    
    var weatherViewModels = [WeatherViewModel]()
    var coreDataArray = [MyWeather]()
    let colors = UIColor.palette()
    private let apiClient = APIClient()
    
    func appendNewCityToCollectionView(valueSent: Temperature) {
        let context = PersistenceManager.shared.context
        _ = MyWeather.createMyWeather(on: valueSent, with: context)
        PersistenceManager.shared.save()
        self.weatherViewModels.append(WeatherViewModel(weather: valueSent))
        let insertedIndexPath = IndexPath(item: weatherViewModels.count - 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [insertedIndexPath])

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather()
        settingUpNavBarButtons()
        settingUpTranslucentNavBar()
        settingUpCollectionView()
    }
    
    private func settingUpTranslucentNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func settingUpNavBarButtons(){
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem?.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems{
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? CurrentWeatherCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    private let backgroundImageView: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundView")
        backgroundImage.contentMode = .scaleAspectFill
        return backgroundImage
    }()
    
    private func settingUpCollectionView(){
        collectionView?.backgroundColor = .clear
        view.setGradientBackground(colorOne: colors[0], colorTwo: colors[4])
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
    } 
    @objc func addCity(){
        let choiceController = SearchController()
        choiceController.delegate = self
        present(UINavigationController(rootViewController: choiceController), animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
        //cell.temperature = weatherViewModels[indexPath.item]
        cell.weatherViewModel = weatherViewModels[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  (view.frame.size.width - 50) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let forecastController = ForecastController(collectionViewLayout: UltravisualLayout())
        forecastController.temperature = weatherViewModels[indexPath.item]
        forecastController.modalTransitionStyle = .flipHorizontal
        self.present(forecastController, animated: true, completion: nil)
    }
    
    private func fetchWeather(){
        let myWeather = PersistenceManager.shared.fetch(MyWeather.self)
        self.coreDataArray = myWeather
        myWeather.forEach({
            guard let city = $0.city else {return}
            let request = WeatherRequest(name: city)
            apiClient.send(apiRequest: request) { (temp: WeatherModel) in
                let cityName = temp.name
                let cityTemp = temp.main.temp.kalvinToCalsius
                let countryName = temp.sys.country
                guard let weatherIcon = temp.weather.first?.icon, let weatherDiscription = temp.weather.first?.description  else {return}
                let temperature = Temperature(city: cityName, cityTemperature: cityTemp, tempIcon: weatherIcon, country: countryName, weatherDescription: weatherDiscription)
                self.weatherViewModels.append(WeatherViewModel(weather: temperature))
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        })
    }
}

extension CurrentWeatherController: CurrentWeatherCellDelegate {
    func delete(cell: CurrentWeatherCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            let objectToDelete = coreDataArray[indexPath.item]
            PersistenceManager.shared.context.delete(objectToDelete)
            PersistenceManager.shared.save()
            weatherViewModels.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
        }
    }
}




