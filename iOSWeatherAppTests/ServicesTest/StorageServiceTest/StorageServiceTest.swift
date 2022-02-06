//
//  StorageServiceTest.swift
//  iOSWeatherAppTests
//
//  Created by Bohdan Hawrylyshyn on 31.01.2022.
//

import XCTest
@testable import iOSWeatherApp

class StorageServiceTest: XCTestCase {
    
    let service = StorageServiceImp()
    
    func testUserDefaults() {
        //arrange
        let key = "TestKey"
        let model: GeoModel = GeoModel.init(city: "TestCity", lat: 1111, lon: 9999)
        
        //act
        let encoder = JSONEncoder()
        let dataToSave = try? encoder.encode(model)
        service.setData(key: key, value: dataToSave)
        
        let decoder = JSONDecoder()
        let dataToLoad = service.getData(key: key)
        guard let entity = try? decoder.decode(GeoModel.self, from: dataToLoad) else { return }
        
        //assert
        XCTAssertEqual(entity.city, model.city)
        XCTAssertEqual(entity.lat, model.lat)
        XCTAssertEqual(entity.lon, model.lon)
        
    }
    
    func testCoreData() {
        //arrange
        let model: GeoModel = GeoModel.init(city: "TestCity", lat: 1111, lon: 9999)
        
        //act
        service.saveWeatherModel(model: model)
        guard let data = service.getWeatherModel() else { return }
        
        let loadedData = service.getWeatherModel()
        guard let loadedCity = loadedData?.city else { return }
        guard let loadedLat = loadedData?.lat else { return }
        guard let loadedLon = loadedData?.lon else { return }
        let loadedModel = GeoModel.init(city: loadedCity, lat: loadedLat, lon: loadedLon)
        
        //assert
        XCTAssertEqual(model.city, loadedModel.city)
        XCTAssertEqual(model.lat, loadedModel.lat)
        XCTAssertEqual(model.lon, loadedModel.lon)
    }
    
}
