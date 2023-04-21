//
//  HomeView.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI
import BottomSheet
import SpriteKit

struct HomeView: View {
    
    @State var tempMin = ""
    @State var tempMax = ""
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            let imageOffset = screenHeight + 36
            
            ZStack {
                // MARK: Background Color
                Color.background
                    .ignoresSafeArea()
                
                // MARK: Background Image
                Image("Background")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .top)
                    .safeAreaInset(edge: .bottom, content: {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 120)
                    })
                    .offset(y: -abs(bottomSheetTranslationProrated) * imageOffset)
                
                // MARK: House Image
                
                Image("House")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 257)
                    .offset(y: -abs(bottomSheetTranslationProrated) * imageOffset)
                
                SpriteView(scene: SnowFall(), options: [.allowsTransparency])
                    .ignoresSafeArea()
                
                // MARK: Current Weather
                Group {
                    if !locationManager.isLoading, locationManager.location != nil {
                        VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                            Text(locationManager.city)
                                .font(.system(size: 35))
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                                .multilineTextAlignment(.center)
                            
                            VStack {
                                Text(attributedString)
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .multilineTextAlignment(.center)
                                
                                Text("H : \(tempMax)°   L : \(tempMin)°")
                                    .font(.title3.weight(.semibold))
                                    .opacity(1 - bottomSheetTranslationProrated)
                                    .foregroundColor(Color("TextColor"))
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .padding(.top, 51)
                        .offset(y: -bottomSheetTranslationProrated * 46)
                    } else {
                        VStack {
                            ProgressView("Fetching…")
                                .scaleEffect(5)
                                .font(.system(size:8))
                                .padding(.top, 120)
                                .foregroundColor(.primary)
                                .tint(.primary)
                            
                            Spacer()
                        }
                        .offset(y: -bottomSheetTranslationProrated * 150)
                    }
                }
                
                // MARK: Bottom Sheet
                BottomSheetView(position: $bottomSheetPosition) {
                } content: {
                    ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                }
                .onBottomSheetDrag { translation in
                    bottomSheetTranslation = translation / screenHeight
                    
                    withAnimation(.easeInOut) {
                        if bottomSheetPosition == BottomSheetPosition.top {
                            hasDragged = true
                        } else {
                            hasDragged = false
                        }
                    }
                }
                
                // MARK: Tab Bar
                TabBar(action: {
                    bottomSheetPosition = .top
                })
                .offset(y: abs(bottomSheetTranslationProrated * 150))
            }
        }
        .onChange(of: locationManager.location?.latitude) { newValue in
            Task {
                try! await weatherManager.getWeather()
            }
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
    }
    
    private var attributedString: AttributedString {
        var temp = ""
        var weather = ""
        if let temp_Main = weatherManager.weatherData?.main.temp,
           let weather_main = weatherManager.weatherData?.weather.first?.description.capitalizingFirstLetter(),
           let temp_Min = weatherManager.weatherData?.main.tempMin,
           let temp_Max = weatherManager.weatherData?.main.tempMax {
            temp = Int(temp_Main).description
            weather = weather_main
            Task {
                await MainActor.run {
                    tempMin = Int(temp_Min).description
                    tempMax = Int(temp_Max).description
                }
            }
        }
        var string = AttributedString("\(temp)°" + (hasDragged ? " | " : "\n ") + "\(weather)")
        
        if let temp = string.range(of: "\(temp)°") {
            string[temp].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
            string[temp].foregroundColor = hasDragged ? Color("Color4") : Color("TextColor")
        }
        
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
        }
        
        if let weather = string.range(of: "\(weather)") {
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = Color("Color4")
        }
        
        return string
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
