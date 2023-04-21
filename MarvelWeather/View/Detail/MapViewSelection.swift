//
//  MapViewSelection.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI
import MapKit

struct MapViewSelection: View{
    
    @Environment(\.managedObjectContext) var persistentContainer
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @FetchRequest(entity: CoordinateList.entity() , sortDescriptors: []) var listCoordinates: FetchedResults<CoordinateList>
    
    var body: some View {
        ZStack{
            MapViewHelper()
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
            
            // MARK: Displaying Data
            if let place = locationManager.pickedPlaceMark{
                VStack(spacing: 15){
                    Text("Confirm Location")
                        .font(.title2.bold())
                        .foregroundColor(Color("Color4"))
                    
                    HStack(spacing: 15){
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.forecastCardBackground)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                                .foregroundColor(Color("Color4"))
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(Color("Color4"))
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.vertical,10)
                    
                    Button {
                        saveCoordinates()
                        dismiss()
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,12)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color("PlusButtonStoke"))
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(scheme == .dark ? Color("Background 1") : Color("Background 2"))
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity,alignment: .bottom)
            }
        }
        .onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}

extension MapViewSelection {
    func saveCoordinates() {
        let coordinates = CoordinateList(context: persistentContainer)
        coordinates.latitude = locationManager.pickedLocation?.coordinate.latitude ?? 0
        coordinates.longitude = locationManager.pickedLocation?.coordinate.longitude ?? 0
        try! persistentContainer.save()
    }
}

// MARK: UIKit MapView
struct MapViewHelper: UIViewRepresentable{
    @ObservedObject var locationManager = LocationManager.shared
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}


struct MapViewSelection_Previews: PreviewProvider {
    static var previews: some View {
        MapViewSelection()
    }
}
