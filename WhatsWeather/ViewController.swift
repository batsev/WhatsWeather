//
//  ViewController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var cityWeather: [Temperature]?
    let cities = ["Moscow", "London", "Tokyo", "Paris"]
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 20, bottom: 0, right: 20)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        [getWeatherButton].forEach { view.addSubview($0) }
        getWeatherButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trail: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 25, height: 25))
    }
    
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
                self.cityWeather?.append(temp)
                if networkCallsDone == self.cities.count {
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }
        }
    }
    
    let getWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plusSign").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        return button
    }()
    
//    @objc func addCity(){
//        let choiceController = ChoiceController()
//        present(choiceController, animated: true, completion: nil)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityWeather?.count ?? 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.temperature = cityWeather?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth =  (view.frame.size.width - 50) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}




