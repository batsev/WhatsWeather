//
//  ChoiceController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class ChoiceController: UITableViewController, UISearchBarDelegate {
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var delegate: AddCityProtocol?

    var temperature: Temperature?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        //searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
//        tableView.register(myCell.self, forCellReuseIdentifier: cellId)
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newCity = searchBar.text, !newCity.isEmpty {
            let weatherGetter = GetWeather()
            weatherGetter.getWeather(city: newCity) { (temp) in
                guard let temp = temp else {return}
                self.temperature = Temperature(city: temp.city, cityTemperature: temp.cityTemperature, tempIcon: temp.tempIcon, country: temp.country)
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
                self.delegate?.setNewCity(valueSent: newCity)
            }
        }
    }
    
}

protocol AddCityProtocol {
    func setNewCity(valueSent: Temperature)
}
