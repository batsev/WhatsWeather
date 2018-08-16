//
//  CustomCell.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 08.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func delete(cell: CustomCell)
}

class CustomCell: UICollectionViewCell{
    
    weak var delegate: CustomCellDelegate?
    
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
            deleteButton.isHidden = !isEditing
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    let cityName: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    let temp: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let weatherView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        view.layer.cornerRadius = 36
        return view
    }()
    
    var isEditing: Bool = false {
        didSet{
            deleteButton.isHidden = !isEditing
        }
    }
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "delete1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteButtonDidTap() {
        delegate?.delete(cell: self)
    }
    
    private func setupViews(){
        [weatherView, cityName, weatherImage, temp, deleteButton].forEach { addSubview($0) }
        weatherView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor)
        cityName.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 10, right: 5), size: .init(width: 0, height: 30))
        temp.anchor(top: nil, leading: self.leadingAnchor, bottom: cityName.topAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 5, right: 5), size: .init(width: 0, height: 80))
        weatherImage.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trail: self.trailingAnchor, size: .init(width: 0, height: 50))
        deleteButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trail: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 24, height: 24))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
