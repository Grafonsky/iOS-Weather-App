//
//  IconsModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 20.01.2022.
//

import Foundation

struct WeatherIconsModel {
    var iconsDict = ["01d": "sun.max.fill",
                     "02d": "cloud.sun.fill",
                     "03d": "cloud.fill",
                     "04d": "smoke.fill",
                     "09d": "cloud.drizzle.fill",
                     "10d": "cloud.sun.rain.fill",
                     "11d": "cloud.bolt.rain.fill",
                     "13d": "snowflake",
                     "50d": "cloud.fog.fill",
                     
                     "01n": "moon.stars.fill",
                     "02n": "cloud.moon.fill",
                     "03n": "cloud.fill",
                     "04n": "smoke.fill",
                     "09n": "cloud.drizzle.fill",
                     "10n": "cloud.moon.rain.fill",
                     "11n": "cloud.bolt.rain.fill",
                     "13n": "snowflake",
                     "50n": "cloud.fog.fill"]
}

struct SpriteKitNodes {
    let nodes: [String: [String]] = ["01d": ["Sun"],
                                     "02d": ["Sun", "Clouds"],
                                     "03d": ["Clouds"],
                                     "04d": ["Clouds"],
                                     "09d": ["Rain", "Clouds"],
                                     "10d": ["Rain", "Clouds"],
                                     "11d": ["Rain", "Clouds"],
                                     "13d": ["Snow", "Clouds"],
                                     "50d": ["Fog", "Clouds"],
                                     
                                     "01n": ["Stars"],
                                     "02n": ["Stars", "Clouds"],
                                     "03n": ["Clouds"],
                                     "04n": ["Clouds"],
                                     "09n": ["Rain", "Clouds"],
                                     "10n": ["Rain", "Clouds"],
                                     "11n": ["Rain", "Clouds"],
                                     "13n": ["Stars", "Snow", "Clouds"],
                                     "50n": ["Stars", "Fog", "Clouds"]]
}

struct GradientColors {
    let colors: [String: [String]] = ["01d": ["#a1c4fd", "#c2e9fb"],
                                      "02d": ["#a1c4fd", "#c2e9fb"],
                                      "03d": ["#516183", "#414d67"],
                                      "04d": ["#516183", "#414d67"],
                                      "09d": ["#1f2531", "#323d53"],
                                      "10d": ["#1f2531", "#323d53"],
                                      "11d": ["#1f2531", "#323d53"],
                                      "13d": ["#6d7992", "#454d5f"],
                                      "50d": ["#1f2531", "#323d53"],
                                      
                                      "01n": ["#22282c", "#161a1c"],
                                      "02n": ["#22282c", "#161a1c"],
                                      "03n": ["#22282c", "#161a1c"],
                                      "04n": ["#22282c", "#161a1c"],
                                      "09n": ["#22282c", "#161a1c"],
                                      "10n": ["#22282c", "#161a1c"],
                                      "11n": ["#22282c", "#161a1c"],
                                      "13n": ["#22282c", "#161a1c"],
                                      "50n": ["#22282c", "#161a1c"]]
}
