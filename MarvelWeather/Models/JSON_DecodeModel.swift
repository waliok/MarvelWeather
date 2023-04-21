//
//  JSON_DecodeModel.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import Foundation

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

extension ResponseBody.WeatherResponse {
    var conditionName: String {
        switch id {
        case 200...232:
            return "Moon cloud fast wind"
        case 300...321:
            return "Sun cloud mid rain"
        case 500...531:
            return "Moon cloud mid rain"
        case 600...622:
            return "Tornado"
        case 701...781:
            return "Sun cloud angled rain"
        case 800:
            return "Sun cloud mid rain"
        case 801...804:
            return "Moon cloud fast wind"
        default:
            return "Tornado"
        }
    }
}

extension ResponseBody {
    var ID: UUID { UUID() }
}
