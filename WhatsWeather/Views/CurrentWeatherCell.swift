//
//  CustomCell.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 08.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

protocol CurrentWeatherCellDelegate: AnyObject {
    func delete(cell: CurrentWeatherCell)
}

class CurrentWeatherCell: UICollectionViewCell{
    
    weak var delegate: CurrentWeatherCellDelegate?
    
    var weatherViewModel: WeatherViewModel!{
        didSet{
            self.cityName.text = weatherViewModel.city
            self.temp.text = weatherViewModel.temperature
            weatherViewModel.fetchIcon { [unowned self] iv in
                self.weatherImage.image = iv
            }
            deleteButton.isHidden = true
            
        }
    }
    
    //private let apiClient = APIClient()
    
//    var temperature: Temperature? {
//        didSet{
//            self.cityName.text = self.temperature?.city
//            self.temp.text = self.temperature?.cityTemperature
//            if let icon = self.temperature?.tempIcon {
//            apiClient.iconGetter(icon: icon) { (data) in
//                DispatchQueue.main.async {
//                    if let data = data {
//                    self.weatherImage.image = UIImage(data: data)
//                    }
//                }
//            }
//            }
//            deleteButton.isHidden = true
//        }
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    private let cityName: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    private let temp: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        return tv
    }()
    
    private var weatherImage: UIImageView = {
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
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "delete1").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    @objc func deleteButtonDidTap() {
        delegate?.delete(cell: self)
    }
    
    private func setupViews(){
        [weatherView, cityName, weatherImage, temp, deleteButton].forEach { addSubview($0) }
        weatherView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor)
        cityName.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trail: self.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 10, right: 5), size: .init(width: 0, height: 20))
        temp.anchor(top: nil, leading: nil, bottom: nil, trail: nil, centerX: self.centerXAnchor, centerY: self.centerYAnchor, size: .init(width: 120, height: 80))
        weatherImage.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trail: self.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 10, right: 0) , size: .init(width: 0, height: 50))
        deleteButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trail: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 24, height: 24))
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
