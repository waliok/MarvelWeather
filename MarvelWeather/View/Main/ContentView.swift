//
//  ContentView.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        } else {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
