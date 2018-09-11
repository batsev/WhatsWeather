//
//  ChoiceController.swift
//  WhatsWeather
//
//  Created by Никита Бацев on 06.08.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var delegate: AddCityProtocol?

    var temperature: Temperature?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
    }
    
    func setupNavBar(){
        searchBar.becomeFirstResponder()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    func setupViews(){
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        [errorMessage, tableView].forEach { view.addSubview($0) }
        errorMessage.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trail: view.trailingAnchor, size: .init(width: 0, height: 44))
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trail: view.trailingAnchor)
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        return tv
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newCity = searchBar.text, !newCity.isEmpty {
            let weatherGetter = GetWeather()
            weatherGetter.getWeather(city: newCity) { (temp) in
                guard let temp = temp else {
                    DispatchQueue.main.async {
                        searchBar.text = ""
                        self.tableView.isHidden = true
                        self.errorMessage.isHidden = false
                    }
                    return
                    
                }
                self.temperature = Temperature(city: temp.city, cityTemperature: temp.cityTemperature, tempIcon: temp.tempIcon, country: temp.country, weatherDescription: temp.weatherDescription)
                DispatchQueue.main.async {
                    searchBar.text = ""
                    self.tableView.isHidden = false
                    self.errorMessage.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let errorMessage: UILabel = {
        let label = UILabel()
        label.text = "No results found!"
        label.textAlignment = .center
        return label
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        if let cityTemp = temperature?.city, let cityCountry = temperature?.country {
            cell.textLabel?.text = "\(cityTemp), \(cityCountry)"
        }
        return cell
    }
    @objc func cancel() {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        dismiss(animated: true) {
            if let newCity = self.temperature{
                self.delegate?.appendNewCityToCollectionView(valueSent: newCity)
            }
        }
    }
    
}

protocol AddCityProtocol {
    func appendNewCityToCollectionView(valueSent: Temperature)
}
