//
//  ShopListApp.swift
//  ShopList
//
//  Created by user277759 on 12/10/25.
//

import SwiftUI
import CoreData

@main
struct ShopListApp: App {
    let persistenceController = PersistenceController.shared
   
    private let API = "http://127.0.0.1:5050"

    
    init(){
        let context = persistenceController.container.viewContext
        let loader = APIDataLoader(api: API, context: context)
        
        loader.clearOrders()
        
        Task {
            await loader.loadAll()
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
