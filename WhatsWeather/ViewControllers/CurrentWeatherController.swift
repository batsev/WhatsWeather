//
//  ViewController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class CurrentWeatherController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCityProtocol{
    
    var weatherArray = [Temperature]()
    //var weatherArray = [MyWeather]()
    
    func appendNewCityToCollectionView(valueSent: Temperature) {
        self.weatherArray.append(valueSent)
        let insertedIndexPath = IndexPath(item: weatherArray.count - 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [insertedIndexPath])

        }
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchWeather()
        settingUpNavBarButtons()
        settingUpTranslucentNavBar()
        settingUpCollectionView()
    }
    
    func settingUpTranslucentNavBar(){
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
    
    let backgroundImageView: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundView.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        return backgroundImage
    }()
    
    func settingUpCollectionView(){
        collectionView?.backgroundColor = .clear
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trail: view.trailingAnchor)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
    } 
    @objc func addCity(){
        let choiceController = SearchController()
        choiceController.delegate = self
        present(UINavigationController(rootViewController: choiceController), animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
        cell.temperature = weatherArray[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  (view.frame.size.width - 50) / 2
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: (cellWidth-30)/2, height: (cellWidth-30)/2)
        } else {
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.orientation.isLandscape {
            return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        } else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let forecastController = ForecastController(collectionViewLayout: UltravisualLayout())
        forecastController.temperature = weatherArray[indexPath.item]
        //self.navigationController?.pushViewController(cityForecastController, animated: true)
        self.present(forecastController, animated: true, completion: nil)
    }
    
//    func fetchWeather(){
//        let weatherArray = PersistenceManager.shared.fetch(MyWeather.self)
//        self.weatherArray = weatherArray
//        DispatchQueue.main.async {
//            collectionView?.reloadData()
//        }
//    }
    
//    let cities = ["Moscow", "London", "Tokyo", "Paris"]
//
//    func fetchWeather(){
//        let weatherGetter = GetWeather()
//        self.arrayWithCityTemperatures = [Temperature]()
//        var networkCallsDone = 0
//        for city in cities {
//            weatherGetter.getWeather(city: city) { (temp) in
//                networkCallsDone += 1
//                guard let temp = temp else {
//                    if networkCallsDone == self.cities.count{
//                        DispatchQueue.main.async {
//                            self.collectionView?.reloadData() // In case the last network call to finish does not return valid data
//                        }
//                    }
//                    return
//                }
//                self.arrayWithCityTemperatures.append(temp)
//                if networkCallsDone == self.cities.count {
//                    DispatchQueue.main.async {
//                        self.collectionView?.reloadData()
//                    }
//                }
//            }
//        }
//    }
}

extension CurrentWeatherController: CurrentWeatherCellDelegate {
    func delete(cell: CurrentWeatherCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            weatherArray.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
        }
    }
}




