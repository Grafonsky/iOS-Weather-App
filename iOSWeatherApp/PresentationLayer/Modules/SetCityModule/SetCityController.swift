//
//  SetCityController.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 10.01.2022.
//

import UIKit

class SetCityController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var input: SetCityPresenterInput = SetCityPresenterImp()
    var isSearch : Bool = false

    //MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        input.viewIsReady()
    }
    
    //MARK: - Configuration

    private func config() {
        configTableView()
        configSearchBar()
        tableView.reloadData()
    }
    
    private func configSearchBar() {
        searchBar.delegate = self
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

}

//MARK: - Extensions

    
extension SetCityController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return input.filteredTableData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        if isSearch {
            let city = input.filteredTableData[indexPath.row]
            cell.textLabel?.text = "\(city.name), \(city.country)"
            return cell
        }
        else {
            let key = input.citiesData[indexPath.row].name
            cell.textLabel?.text = key
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = input.filteredTableData[indexPath.row]
        let lat = input.filteredTableData[indexPath.row].lat
        let lon = input.filteredTableData[indexPath.row].lon
        input.transferCityData(transferedLat: lat, transferedLon: lon)
        dismiss(animated: true)
    }
}

extension SetCityController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false
            self.tableView.reloadData()
        } else {
            input.filteredTableData = input.citiesData.filter {
                $0.name.contains(searchText)
            }.sorted(by: {$0.name < $1.name})
            if(input.filteredTableData.count == 0){
                isSearch = false
            } else {
                isSearch = true
            }
            self.tableView.reloadData()
        }
    }
}
