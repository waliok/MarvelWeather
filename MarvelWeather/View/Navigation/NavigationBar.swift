//
//  Navigationbar.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct NavigationBar: View {
    
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    @ObservedObject var weatherManager = WeatherManager.shared
    @ObservedObject var locationManager = LocationManager.shared
    @FocusState private var focusedField: Bool
    @AppStorage("measurement") var switchTemp: String = "metric"
    @FetchRequest(entity: CoordinateList.entity() , sortDescriptors: []) var listCoordinates: FetchedResults<CoordinateList>
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                // MARK: Back Button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        // MARK: Back Button Icon
                        Image(systemName: "chevron.left")
                            .font(.system(size: 23).weight(.medium))
                            .foregroundColor(Color("Color4"))
                        
                        // MARK: Back Button Label
                        Text("Weather")
                            .font(.title)
                            .foregroundColor(Color("TextColor"))
                    }
                    .frame(height: 44)
                }
                
                Spacer()
                
                // MARK: More Button
                if editMode?.wrappedValue == .active {
                    Button {
                        editMode?.wrappedValue = .inactive
                    } label: {
                        Text("Done")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                } else {
                    Menu {
                        Button {
                            editMode?.wrappedValue = .active
                        } label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                        
                        Picker(selection: $switchTemp) {
                            Label(title: { Text("Celsius") }, icon: { Image("celsius") }).tag("metric")
                            Label(title: { Text("Fahrenheit") }, icon: { Image("fahrenheit") }).tag("imperial")
                            
                        } label: {
                            Text("Units measurement")
                        }
                        .pickerStyle(.menu)
                        .onChange(of: switchTemp) { newValue in
                            
                            weatherManager.weather.removeAll()
                            for item in listCoordinates {
                                Task {
                                    try! await weatherManager.getWeatherForList(item: item)
                                }
                            }
                            Task {
                                guard !locationManager.isLoading, locationManager.location != nil else { return }
                                try! await weatherManager.getWeather()
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 28))
                            .frame(width: 44, height: 44, alignment: .trailing)
                            .foregroundColor(Color("Color4"))
                    }
                }
            }
            .frame(height: 52)
            
            // MARK: Search Bar
            HStack(spacing: 10) {
                
                Image(systemName: "magnifyingglass")
                
                TextField("", text: $searchText)
                    .placeholder("Search for a city or airport", when: searchText.isEmpty, foregroundColor: Color("Color4"))
                    .focused($focusedField)
            }
            .foregroundColor(Color("Color4"))
            .padding(.horizontal, 6)
            .padding(.vertical, 7)
            .frame(height: 36, alignment: .leading)
            .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.25), lineWidth: 2, offsetX: 0, offsetY: 2, blur: 2)
        }
        .frame(height: 106, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.top, 49)
        .backgroundBlur(radius: 20, opaque: true)
        .background(Color.navBarBackground)
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea()
        .onDisappear {
            self.searchText = ""
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(searchText: .constant(""))
    }
}

