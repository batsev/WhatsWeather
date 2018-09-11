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
    var coreDataArray = [MyWeather]()
    let colors = UIColor.palette()
    
    func appendNewCityToCollectionView(valueSent: Temperature) {
        let context = PersistenceManager.shared.context
        _ = MyWeather.createMyWeather(on: valueSent, with: context)
        PersistenceManager.shared.save()
        self.weatherArray.append(valueSent)
        let insertedIndexPath = IndexPath(item: weatherArray.count - 1, section: 0)
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
        backgroundImage.image = UIImage(named: "backgroundView")
        backgroundImage.contentMode = .scaleAspectFill
        return backgroundImage
    }()
    
    func settingUpCollectionView(){
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
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let forecastController = ForecastController(collectionViewLayout: UltravisualLayout())
        forecastController.temperature = weatherArray[indexPath.item]
        forecastController.modalTransitionStyle = .flipHorizontal
        self.present(forecastController, animated: true, completion: nil)
    }
    
    func fetchWeather(){
        let weatherGetter = GetWeather()
        let myWeather = PersistenceManager.shared.fetch(MyWeather.self)
        self.coreDataArray = myWeather
        var networkCallsDone = 0
        myWeather.forEach({
            guard let city = $0.city else {return}
            weatherGetter.getWeather(city: city) { (temp) in
                networkCallsDone += 1
                guard let temp = temp else {
                    if networkCallsDone == myWeather.count{
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    return
                }
                self.weatherArray.append(temp)
                if networkCallsDone == myWeather.count {
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
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
            weatherArray.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
        }
    }
}




