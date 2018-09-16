//
//  ForecastCell.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 30.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var forecastTemperature: ForecastTemperature? {
        didSet{
            weekdayLabel.text = forecastTemperature?.weekday
        }
    }
    
    private let apiClient = APIClient()
    var temperature: Temperature?

    var firstCell: Bool!{
        didSet{
            if let cityName = temperature?.city, let country = temperature?.country {
                cityLabel.text = "\(cityName), \(country)"
            }
            weatherDescriptionLabel.text = firstCell ? temperature?.weatherDescription : forecastTemperature?.forecast[5].weatherDescription
            temp.text = firstCell ? temperature?.cityTemperature : forecastTemperature?.forecast[5].cityTemperature
            if let icon = firstCell ? temperature?.tempIcon : (forecastTemperature?.forecast[5].tempIcon)!{
                //            weatherGetter.getWeatherIcon(icon: icon!) { (data) in
                //                if let data = data {
                //                    DispatchQueue.main.async {
                //                        self.weatherIcon.image = UIImage(data: data)
                //                    }
                //                }
                //            }
                apiClient.iconGetter(icon: icon) { (data) in
                    DispatchQueue.main.async {
                        if let data = data {
                            self.weatherIcon.image = UIImage(data: data)
                        }
                    }
                }
            }
            
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
//        let minAlpha: CGFloat = 0.3
//        let maxAlpha: CGFloat = 0.75
        let scale = max(delta, 0.5)
        weekdayLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        weatherIcon.transform = CGAffineTransform(scaleX: scale, y: scale)
        weatherDescriptionLabel.alpha = delta
        forecastCollectionView.alpha = delta
        temp.alpha = delta
        cityLabel.alpha = delta
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = forecastTemperature?.forecast.count {
            return count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let cellCount = forecastTemperature?.forecast.count else {return UIEdgeInsetsMake(0, 0, 0, 0)}
        if cellCount < 8 {
            let cellWidth = 50
            let cellSpacing = 10
            let edgeInset = CGFloat((cellWidth + cellSpacing)/2)
            return UIEdgeInsetsMake(0, edgeInset*(6 - CGFloat(cellCount)) + CGFloat(cellSpacing/2), 0, 0)
        } else {
        return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleForecastCell.identifier, for: indexPath) as! SingleForecastCell
        cell.temperature = forecastTemperature?.forecast[indexPath.item]
        cell.timeOfForecast = forecastTemperature?.time[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 38)
        label.textAlignment = .center
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage()
        iv.contentMode = .scaleAspectFill
        return iv

    }()
    
    private let temp: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    private func setupViews(){
        [cityLabel ,weatherIcon, weekdayLabel, weatherDescriptionLabel, forecastCollectionView, temp].forEach { addSubview($0) }
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
        
        forecastCollectionView.register(SingleForecastCell.self, forCellWithReuseIdentifier: SingleForecastCell.identifier)
        weatherIcon.anchor(top: nil, leading: nil, bottom: nil, trail: nil, centerX: centerXAnchor, centerY: centerYAnchor, size: .init(width: 80, height: 80))
        weekdayLabel.anchor(top: topAnchor, leading: self.leadingAnchor, bottom: nil, trail: self.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 44))
        cityLabel.anchor(top: nil, leading: leadingAnchor, bottom: weekdayLabel.topAnchor, trail: trailingAnchor, size: .init(width: 0, height: 14))
        weatherDescriptionLabel.anchor(top: weekdayLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trail: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 23))
        temp.anchor(top: nil, leading: nil, bottom: forecastCollectionView.topAnchor, trail: nil, centerX: centerXAnchor, padding: .init(top: 0, left: 0, bottom: -10, right: 0), size: .init(width: 60, height: 60))
        forecastCollectionView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 3, right: 5), size: .init(width: 0, height: 80))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SingleForecastCell: UICollectionViewCell{
    
    private let apiClient = APIClient()
    
    var temperature: Temperature?{
        didSet{
            temp.text = temperature?.cityTemperature
            
            if let icon = self.temperature?.tempIcon {
                apiClient.iconGetter(icon: icon) { (data) in
                    DispatchQueue.main.async {
                        if let data = data {
                            self.weatherIcon.image = UIImage(data: data)
                        }
                    }
                }
            }
//            weatherGetter.getWeatherIcon(icon: (self.temperature?.tempIcon)!) { (data) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        self.weatherIcon.image = UIImage(data: data)
//                    }
//                }
//            }
           
        }
    }
    var timeOfForecast: String?{
        didSet{
            time.text = timeOfForecast
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let temp: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    private let time: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    private func setupViews() {
        backgroundColor = .clear
        [time, weatherIcon, temp].forEach {addSubview($0)}
        time.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trail: trailingAnchor, size: .init(width: 0, height: 20))
        weatherIcon.anchor(top: time.bottomAnchor, leading: leadingAnchor, bottom: nil, trail: trailingAnchor)
        temp.anchor(top: weatherIcon.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trail: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 3, right: 0))
        
    }
}



