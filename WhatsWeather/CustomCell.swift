//
//  CustomCell.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 08.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell{
    var temperature: Temperature? {
        didSet{
            let weatherGetter = GetWeather()
            self.cityName.text = self.temperature?.city
            self.temp.text = self.temperature?.cityTemperature
            weatherGetter.getWeatherIcon(icon: (self.temperature?.tempIcon)!) { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.weatherImage.image = UIImage(data: data)
                    }
                }
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    let cityName: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    let temp: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let weatherView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 16
        return view
    }()
    
    private func setupViews(){
        [weatherView, cityName, weatherImage, temp].forEach { addSubview($0) }
        weatherView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor)
        cityName.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5), size: .init(width: 0, height: 30))
        temp.anchor(top: nil, leading: self.leadingAnchor, bottom: cityName.topAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5), size: .init(width: 0, height: 30))
        weatherImage.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: temp.topAnchor, trail: self.trailingAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
