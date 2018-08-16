//
//  ViewController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class WeatherController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCityProtocol{
    
    var cityWeather: [Temperature] = []
    
    let cellId = "cellId"
    
    func setNewCity(valueSent: Temperature) {
        self.cityWeather.append(valueSent)
        let insertedIndexPath = IndexPath(item: cityWeather.count - 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [insertedIndexPath])

        }
//        DispatchQueue.main.async {
//            self.collectionView?.reloadData()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        fetchWeather()
        //        let image = #imageLiteral(resourceName: "plusSign").withRenderingMode(.alwaysOriginal)
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addCity))
        //        plusButton.setImage(#imageLiteral(resourceName: "plusSign").withRenderingMode(.alwaysOriginal), for: .normal)
        //        plusButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
        settingUpCollectionView()
        //        settingUpPlusButton()
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem?.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems{
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? CustomCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    func settingUpCollectionView(){
        collectionView?.backgroundColor = .clear
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundView.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
    }
    
//    func settingUpPlusButton(){
//        [getWeatherButton].forEach { view.addSubview($0) }
//        getWeatherButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trail: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 25, height: 25))
//    }
//
//    let getWeatherButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("+", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
////        button.setImage(#imageLiteral(resourceName: "plusSign").withRenderingMode(.alwaysOriginal), for: .normal)
////        button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
//        return button
//    }()
    
    @objc func editCells(){
        
    }
    
    @objc func addCity(){
        let choiceController = ChoiceController()
        choiceController.delegate = self
        present(UINavigationController(rootViewController: choiceController), animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityWeather.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.temperature = cityWeather[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  (view.frame.size.width - 50) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    let cities = ["Moscow", "London", "Tokyo", "Paris"]

    func fetchWeather(){
        let weatherGetter = GetWeather()
        self.cityWeather = [Temperature]()
        var networkCallsDone = 0
        for city in cities {
            weatherGetter.getWeather(city: city) { (temp) in
                networkCallsDone += 1
                guard let temp = temp else {
                    if networkCallsDone == self.cities.count{
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData() // In case the last network call to finish does not return valid data
                        }
                    }
                    return
                }
                self.cityWeather.append(temp)
                if networkCallsDone == self.cities.count {
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
}

extension WeatherController: CustomCellDelegate {
    func delete(cell: CustomCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            cityWeather.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
        }
    }
    
    
}




