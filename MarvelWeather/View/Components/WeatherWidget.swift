//
//  WeatherWidget.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct WeatherWidget: View {
    
    var weather: ResponseBody?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Trapezoid
            if let weather = weather {
                Trapezoid()
                    .fill(Color.weatherWidgetBackground)
                    .frame(width: 342, height: 174)
                
                // MARK: Content
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        // MARK: Forecast Temperature
                        Text("\(Int(weather.main.temp))°")
                            .font(.system(size: 64))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            // MARK: Forecast Temperature Range
                            Text("H:\(Int(weather.main.tempMax))°  L:\(Int(weather.main.tempMin))°")
                                .font(.footnote)
                                .foregroundColor(Color("Color4"))
                            
                            // MARK: Forecast Location
                            Text(weather.name)
                                .font(.body)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        // MARK: Forecast Large Icon
                        Image("\(weather.weather.first?.conditionName ?? "Tornado") large")
                            .padding(.trailing, 4)
                        
                        // MARK: Weather
                        if let description = weather.weather.first?.description {
                            Text("\(description.capitalizingFirstLetter())")
                                .font(.footnote)
                                .padding(.trailing, 24)
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 20)
                .padding(.leading, 20)
            } else {
                VStack {
                    ProgressView("Fetching…")
                        .scaleEffect(4)
                        .font(.system(size:8))
                        .foregroundColor(.primary)
                        .tint(.primary)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .offset(y: -100)
                }
            }
        }
        .frame(width: 342, height: 184, alignment: .bottom)
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidget(weather: (ResponseBody(coord: ResponseBody.CoordinatesResponse(lon: 0, lat: 0), weather: [ResponseBody.WeatherResponse(id: 0, main: "", description: "", icon: "")], main: ResponseBody.MainResponse(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0), name: "", wind: ResponseBody.WindResponse(speed: 0, deg: 0))))
            .preferredColorScheme(.dark)
    }
}
