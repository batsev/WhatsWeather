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
            weatherDescriptionLabel.text = forecastTemperature?.forecast.first?.weatherDescription
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
        weatherDescriptionLabel.alpha = delta
        forecastCollectionView.alpha = delta
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = forecastTemperature?.forecast.count {
            return count
        } else {
            return 0
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        <#code#>
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleForecastCell.identifier, for: indexPath) as! SingleForecastCell
        cell.temperature = forecastTemperature?.forecast[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 38)
        label.textAlignment = .center
        return label
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Clear Sky"
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.textAlignment = .center
        return label
    }()
    
    let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func setupViews(){
        

        [weekdayLabel, forecastCollectionView, weatherDescriptionLabel].forEach { addSubview($0) }
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
        
        forecastCollectionView.register(SingleForecastCell.self, forCellWithReuseIdentifier: SingleForecastCell.identifier)
        
        weekdayLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trail: self.trailingAnchor, centerY: self.centerYAnchor, size: .init(width: 0, height: 44))
        weatherDescriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: forecastCollectionView.topAnchor, trail: self.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 0, height: 23))
        forecastCollectionView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 10, right: 5), size: .init(width: 0, height: 80))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SingleForecastCell: UICollectionViewCell{
    
    var temperature: Temperature?{
        didSet{
            let weatherGetter = GetWeather()
            temp.text = temperature?.cityTemperature
            weatherGetter.getWeatherIcon(icon: (self.temperature?.tempIcon)!) { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.weatherIcon.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "10d")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let temp: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        tv.text = "20°"
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    func setupViews() {
        backgroundColor = .clear
        [weatherIcon, temp].forEach {addSubview($0)}
        weatherIcon.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trail: trailingAnchor, size: .init(width: 0, height: 40))
        temp.anchor(top: weatherIcon.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trail: trailingAnchor)
        
    }
}



