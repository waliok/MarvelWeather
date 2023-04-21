//
//  WeatherManager.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI
import MapKit

class WeatherManager: ObservableObject {
    @ObservedObject var dataManager = CoreDataManger.shared
    @ObservedObject var locationManager = LocationManager.shared
    static let shared = WeatherManager()
    let key = "501cc86ae1aeceefe4f61e7d820bbce2"
    let lang = UserDefaults.standard.stringArray(forKey: "AppleLanguages")!.first?.prefix(2) ?? "en"
    
    @Published var weatherData: ResponseBody?
    @Published var weather: [ResponseBody] = []
    @AppStorage("measurement") var switchTemp: String = "metric"
    
    func fetchCurrentWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&lang=\(lang)&appid=\(key)&units=\(switchTemp)") else { fatalError("Missing URL") }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching data") }
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }
    
    func getWeather() async throws {
        guard let location = locationManager.location else { fatalError("Failed to get your location") }
        do {
            weatherData = try await fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }
    
    func getWeatherFromMark() async throws {
        guard let location = locationManager.pickedPlaceMark else { fatalError("Failed to get your location") }
        do {
            let newWeather = try await fetchCurrentWeather(latitude: location.location?.coordinate.latitude ?? 0, longitude: location.location?.coordinate.longitude ?? 0)
            weather.append(newWeather)
        } catch {
            print("Error getting weather: \(error)")
        }
    }
    
    func getWeatherForList(item: CoordinateList) async throws {
        let newWeather = try await fetchCurrentWeather(latitude: item.latitude, longitude: item.longitude)
        weather.append(newWeather)
    }
}
