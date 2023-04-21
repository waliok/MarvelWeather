//
//  WeatherView.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    @Environment(\.managedObjectContext) var persistentContainer
    // MARK: Navigation Tag to Push View to MapView
    @State var navigationTag: String?
    @State var presentNavigationView: Bool = false
    @State var searchText = ""
    @FetchRequest(entity: CoordinateList.entity() , sortDescriptors: []) var listCoordinates: FetchedResults<CoordinateList>
    
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color.background
                .ignoresSafeArea()
            
            // MARK: Weather Widgets
            List {
                Section {
                    WeatherWidget(weather: weatherManager.weatherData)
                }
                .listRowBackground(Color(.clear))
                ForEach(weatherManager.weather, id: \.ID) { weather in
                    WeatherWidget(weather: weather)
                }
                .onDelete(perform: deleteRow)
                .listRowBackground(Color(.clear))
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .top) {
                EmptyView()
                    .frame(height: 110)
            }
            
            // MARK: Navigation Bar
            VStack {
                NavigationBar(searchText: $locationManager.searchText)
                
                if let places = locationManager.fetchedPlaces,!places.isEmpty {
                    List {
                        ForEach(places,id: \.self){place in
                            Button {
                                if let coordinate = place.location?.coordinate{
                                    locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                                
                                // MARK: Navigating To MapView
                                if #available(iOS 16, *){
                                    presentNavigationView.toggle()
                                }else{
                                    navigationTag = "MAPVIEW"
                                }
                            } label: {
                                HStack(spacing: 15){
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color("PlusButtonStoke"))
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                            .foregroundColor(Color("Color4"))
                                        
                                        Text(place.locality ?? "")
                                            .font(.caption)
                                            .foregroundColor(Color("Color4"))
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color("Background 1").opacity(0.8))
                    }
                    .listStyle(.plain)
                    .ignoresSafeArea(edges: .top)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .ignoresSafeArea(edges: .top)
            .background{
                if #available(iOS 16, *){
                    Rectangle()
                        .foregroundColor(.clear)
                        .navigationDestination(isPresented: $presentNavigationView, destination: {
                            MapViewSelection()
                                .toolbar(.hidden, for: .navigationBar)
                        })
                } else {
                    NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                        MapViewSelection()
                            .navigationBarHidden(true)
                    } label: { }
                        .labelsHidden()
                }
            }
        }
        .task {
            weatherManager.weather.removeAll()
            for item in listCoordinates {
                try! await weatherManager.getWeatherForList(item: item)
            }
        }
    }
}

extension WeatherView {
    func deleteRow(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = listCoordinates[index]
            persistentContainer.delete(item)
            try! persistentContainer.save()
            weatherManager.weather.removeAll()
            for item in listCoordinates {
                Task {
                    try! await weatherManager.getWeatherForList(item: item)
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherView()
                .preferredColorScheme(.dark)
        }
    }
}
