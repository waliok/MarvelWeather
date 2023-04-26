//
//  LocationManager.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    // MARK: Properties
    @Published var mapView: MKMapView = .init()

    // MARK: Search Bar Text
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    // MARK: User Location
    @Published var userLocation: CLLocation?
    
    // MARK: Final Location
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    @Published var region: MKCoordinateRegion
    @Published var location: CLLocationCoordinate2D?
    @Published var name: String = ""
    @Published var city: String = "Your City"
    @Published var isLoading = false
    
    override private init() {
        let latitude = 0
        let longitude = 0
        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                                                       longitude: CLLocationDegrees(longitude)),
                                         span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        super.init()
        
        // MARK: Setting Delegates
        manager.delegate = self
        mapView.delegate = self
        
        // MARK: Requesting Location Access
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        // MARK: Search Textfield Watching
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
        isLoading = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.userLocation = currentLocation
        location = locations.first?.coordinate
        update()
        isLoading = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .restricted, .denied: handleLocationError()
        case .authorizedAlways, .authorizedWhenInUse: manager.requestLocation()
        @unknown default: ()
        }
    }
    
    func handleLocationError(){
        // HANDLE ERROR
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
        isLoading = false
    }
    
    func fetchPlaces(value: String){
        // MARK: Fetching places using MKLocalSearch & Asyc/Await
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                // We can also Use Mainactor To publish changes in Main Thread
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
            catch{
                // HANDLE ERROR
            }
        }
    }
    
    func update() {
        let latitude = location?.latitude ?? 0
        let longitude = location?.longitude ?? 0
        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                                                       longitude: CLLocationDegrees(longitude)),
                                         span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            let reversedGeoLocation = GeoLocation(with: placemark)
            self.name = reversedGeoLocation.name
            self.city = reversedGeoLocation.city
        }
    }
    
    // MARK: Add Draggable Pin to MapView
    func addDraggablePin(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Coordinate location"
        
        mapView.addAnnotation(annotation)
    }
    
    // MARK: Enabling Dragging
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "LOCATIONPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else{return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation){
        Task{
            do{
                guard let place = try await reverseLocationCoordinates(location: location) else{return}
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            }
            catch{
                // HANDLE ERROR
            }
        }
    }
    
    // MARK: Displaying New Location Data
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
    
    func reverseUpdate() {
        CLGeocoder().geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            let coord = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: CLLocationDegrees(0),
                                                                                 longitude: CLLocationDegrees(0))
            self.region = MKCoordinateRegion(center: coord,
                                             span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self.location = CLLocationCoordinate2D(latitude: placemark.location?.coordinate.latitude ?? 0,
                                                   longitude: placemark.location?.coordinate.longitude ?? 0)
            
        }
    }
}

struct GeoLocation {
    let name: String
    let streetName: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
    }
}
