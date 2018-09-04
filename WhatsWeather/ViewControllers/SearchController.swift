//
//  ChoiceController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class SearchController: UITableViewController, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var delegate: AddCityProtocol?

    var temperature: Temperature?
    //var myWeather: MyWeather?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newCity = searchBar.text, !newCity.isEmpty {
            let weatherGetter = GetWeather()
            weatherGetter.getWeather(city: newCity) { (temp) in
                guard let temp = temp else {return}
                //self.myWeather = MyWeather.createMyWeather(weather: temp)
                self.temperature = Temperature(city: temp.city, cityTemperature: temp.cityTemperature, tempIcon: temp.tempIcon, country: temp.country, weatherDescription: temp.weatherDescription)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        //let myWeather = MyWeather(context: PersistenceManager.shared.context)
        //if let cityTemp = myWeather?.city, let cityCountry = myWeather?.country {
        if let cityTemp = temperature?.city, let cityCountry = temperature?.country {
            cell.textLabel?.text = "\(cityTemp), \(cityCountry)"
        }
        return cell
    }
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            if let newCity = self.temperature{
                self.delegate?.appendNewCityToCollectionView(valueSent: newCity)
                //PersistenceManager.shared.save()
            }
        }
    }
    
}

protocol AddCityProtocol {
    func appendNewCityToCollectionView(valueSent: Temperature)
}
