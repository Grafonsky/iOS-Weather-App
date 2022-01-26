//
//  ChoosenCitiesViewController.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationsTableView: UITableView!
  
    var dateFormatterService: DateFormatterService!

    var presenter: FavoritesPresenterInput!
                
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewIsReady()
        config()
    }
    
    // MARK: - Configs
    
    private func config() {
        configSearchBar()
        configLocationsTableView()
    }
    
    private func configLocationsTableView() {
        locationsTableView.backgroundColor = .clear
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        locationsTableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "CityCell")
    }
    
    private func configSearchBar() {
        searchBar.delegate = self
    }
    
}

// MARK: - Extensions

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.locationsEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let location = presenter.locationsEntity[indexPath.row]
            switch indexPath.row {
            case 0:
                if let cell = locationsTableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell {
                    cell.backgroundColor = .clear
                    
                    cell.titleLabel.text = "My Location"
                    cell.subTitleLabel.text = location.cityName
                    cell.weatherLabel.text = location.weatherDesc.firstUppercased
                    cell.tempLabel.text = String(location.temp)
                    cell.maxMinLabel.text = "H:\(location.maxTemp)° L:\(location.minTemp)°"
                    
                    return cell
                }
            default:
                if let cell = locationsTableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell {
                    cell.titleLabel.text = location.cityName
                    cell.subTitleLabel.text = dateFormatterService.dateToString(date: NSDate.now as NSDate, format: "HH:mm")
                    cell.weatherLabel.text = location.weatherDesc.firstUppercased
                    cell.tempLabel.text = "\(round(location.temp - 273.15))°"
                    cell.maxMinLabel.text = "H:\(round(location.maxTemp - 273.15))° L:\(round(location.minTemp - 273.15))°"
                    return cell
                }
            }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}

extension FavoritesViewController: FavoritesPresenterOutput {
    func setLocations() {
        let locations = presenter.locationsEntity
        locationsTableView.reloadData()
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let cityName = searchBar.text else { return }
        presenter.addCity(city: cityName)
        searchBar.text = ""
    }
}
