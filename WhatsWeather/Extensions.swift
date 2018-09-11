//
//  Extensions.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trail: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let trail = trail {
            trailingAnchor.constraint(equalTo: trail, constant: -padding.right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension String {
    var getDate: String {
        return components(separatedBy: " ").first!
    }
    var getTime: String{
        return components(separatedBy: " ").last!
    }
    var timeOfTheDay: String{
        let time = self.getTime
        return String(time.prefix(5))
    }
    var dayOfTheWeek: String{
        let today = self.getDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else {return self}
        let myCalendar = Calendar(identifier: .gregorian)
        let numberOfWeekDay = myCalendar.component(.weekday, from: todayDate)
        return numberOfWeekDay.getDayOfTheWeek
    }
    
    var getCityUrl: String{
        return self.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: ", ", with: ",")
    }
}

extension Int {
    var getDayOfTheWeek: String {
        switch self {
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wendsday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        case 1: return "Sunday"
        default: return "?"
        }
    }
}

extension Double {
    var kalvinToCalsius: String{
        return String(Int(self - 273.15))+"°"
    }
}

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    
    class func colorFromRGB(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(Float(r) / 255), green: CGFloat(Float(g) / 255), blue: CGFloat(Float(b) / 255), alpha: 1)
    }
    
    class func palette() -> [UIColor] {
        let palette = [
            UIColor.colorFromRGB(r: 205, g: 92, b: 92),
            UIColor.colorFromRGB(r:240, g: 128, b: 128),
            UIColor.colorFromRGB(r:250, g: 128, b: 114),
            UIColor.colorFromRGB(r:233, g: 150, b: 122),
            UIColor.colorFromRGB(r:255, g: 160, b: 122)
        ]
        return palette
    }
    
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

