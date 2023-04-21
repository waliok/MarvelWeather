//
//  CoreDataManager.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManger: ObservableObject {
    
    static let shared = CoreDataManger()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CoordinateListModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error load persistent store\(error.localizedDescription)")
            }
        }
    }
}
