//
//  MarvelWeatherApp.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

@main
struct MarvelWeatherApp: App {
    
    let persistentContainer = CoreDataManger.shared.container
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .purple
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16, *) {
                ContentView()
                    .persistentSystemOverlays(.hidden)
                    .environment(\.managedObjectContext, persistentContainer.viewContext)
            } else {
                ContentView()
                    .withHostingWindow { window in
                        let contentView = ContentView()
                            .environment(\.managedObjectContext, persistentContainer.viewContext)
                        window?.rootViewController = HideHomeIndicatorController(rootView: contentView)
                    }
            }
            
        }
    }
}

//MARK: - Extensions for hide Home button indicator under iOS 16

extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

class HideHomeIndicatorController<Content:View>: UIHostingController<Content> {
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
}
