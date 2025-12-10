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
    
    init(){
        dataLoader()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension ShopListApp {
    
    struct SeedProduct {
        let name: String
        let price: Double
    }
    
    struct SeedCategory {
        let name: String
        let info: String
        let products: [SeedProduct]
    }
    
    var seedCategories: [SeedCategory] {
        [
            SeedCategory(
                name: "Food",
                info: "Food products",
                products: [
                    SeedProduct(name: "Bread", price: 4.99),
                    SeedProduct(name: "Potatos", price: 2.99)
                ]
            ),
            SeedCategory(
                name: "Clothes",
                info: "Clothes products",
                products: [
                    SeedProduct(name: "T-Shirt", price: 19.99),
                    SeedProduct(name: "Hoodie", price: 39.99)
                ]
            ),
            SeedCategory(
                name: "Vehicles",
                info: "Cars and Bikes",
                products: [
                    SeedProduct(name: "Car", price: 9999.99),
                    SeedProduct(name: "Bike", price: 249.99)
                ]
            )
        ]
    }
    
    func dataLoader() {
        let context = persistenceController.container.viewContext
        
        guard !categoriesExist() else { return }
        
        for seedCategory in seedCategories {
            let category = Category(context: context)
            category.name = seedCategory.name
            category.info = seedCategory.info
            
            for seedProduct in seedCategory.products {
                let product = Product(context: context)
                product.name = seedProduct.name
                product.price = seedProduct.price
                product.category = category
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Error adding sample categories: \(error.localizedDescription)")
        }
    }
    
    func categoriesExist() -> Bool {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking categories: \(error.localizedDescription)")
            return false
        }
    }
}
