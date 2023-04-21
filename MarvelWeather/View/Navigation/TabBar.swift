//
//  TabBar.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    var action: () -> Void
    @State var buttonTapped = false
    @State var alertVisible = false
    
    @State var navigationTag: String?
    @State var presentNavigationView: Bool = false
    
    var body: some View {
        ZStack {
            // MARK: Arc Shape
            Arc()
                .fill(Color.tabBarBackground)
                .frame(height: 88)
                .overlay {
                    // MARK: Arc Border
                    Arc()
                        .stroke(Color.tabBarBorder, lineWidth: 0.5)
                }
            
            // MARK: Tab Items
            HStack {
                // MARK: Expand Button
                Button {
                    if locationManager.manager.authorizationStatus == .denied || locationManager.manager.authorizationStatus == .restricted {
                        alertVisible = true
                    } else {
                        locationManager.requestLocation()
                        guard !locationManager.isLoading else { return }
                        Task {
                            try! await weatherManager.getWeather()
                        }
                        locationManager.update()
                    }
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Button {
                    // MARK: Navigating To MapView
                    if #available(iOS 16, *){
                        presentNavigationView.toggle()
                    }else{
                        navigationTag = "MAPVIEW"
                    }
                } label: {
                    Image(systemName: "list.star")
                        .frame(width: 44, height: 44)
                }
                .background{
                    if #available(iOS 16, *){
                        Rectangle()
                            .foregroundColor(.clear)
                            .navigationDestination(isPresented: $presentNavigationView, destination: {
                                WeatherView()
                                    .toolbar(.hidden, for: .navigationBar)
                            })
                    }else{
                        NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                            WeatherView()
                                .navigationBarHidden(true)
                        } label: {}
                            .labelsHidden()
                    }
                }
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 20, leading: 32, bottom: 24, trailing: 32))
            .overlay(alignment: .center) {
                
                midButton
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .alert("Access to your location is requeired.", isPresented: $alertVisible) {
            Button("Cancel", role: .cancel) {}
            Button("Yes", role: .destructive) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)}
        } message: {
            Text("Go to settings?")
        }
    }
    //MARK: - MidButton
    var midButton: some View {
        ZStack {
            MidButtonCurve()
                .fill(LinearGradient(colors: [Color.plusButton2, Color.plusButton1], startPoint: .top, endPoint: .bottom))
                .frame(width: 258, height: 100, alignment: .bottom)
                .overlay {
                    MidButtonCurve()
                        .stroke(Color.tabBarBorder.opacity(0.8), lineWidth: 0.5)
                }
                .offset(y: 4)
            
            Circle()
                .fill(LinearGradient(colors: [.white, Color("Color5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 58, height: 58)
                .shadow(color: .white.opacity(0.25), radius: 10, x: -10, y: -10)
                .shadow(color: Color("Color3"), radius: 20, x: 10, y: 10)
            
            Circle()
                .fill(LinearGradient(colors: [.black.opacity(0.8), .white.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)).blur(radius: 0.3)
                .frame(width: 65, height: 65)
            
            Circle()
                .fill(LinearGradient(colors: [.white, Color("Color5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 58, height: 58)
            
            Circle()
                .fill(LinearGradient(colors: [buttonTapped ? Color("ButtonGradient") : .white, Color.buttonGradient], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 55, height: 55)
                .overlay {
                    Circle()
                        .stroke(LinearGradient(colors: [buttonTapped ? Color("ButtonGradient") : Color("Color5"), Color("Color4")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2).blur(radius: 1)
                        .frame(width: 55, height: 55)
                }
                .onTapGesture {
                    withAnimation {
                        action()
                        buttonTapped.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            buttonTapped.toggle()
                        }
                    }
                }
            
            Image(systemName: "aqi.medium")
                .font(.system(size: 26, weight: .black))
                .foregroundColor(Color.plusSign)
                .frame(width: 44, height: 44, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .offset(y: -10)
        
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(action: {})
            .preferredColorScheme(.dark)
    }
}
