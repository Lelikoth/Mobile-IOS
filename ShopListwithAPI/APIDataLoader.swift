//
//  APIDataLoader.swift
//  ShopList
//
//  Created by user277759 on 12/18/25.
//

import Foundation
import CoreData

final class APIDataLoader {
    private let api: String
    private let context: NSManagedObjectContext

    init(api: String, context: NSManagedObjectContext) {
        self.api = api
        self.context = context
    }

    struct SeedProduct: Decodable {
        let id: Int64
        let name: String
        let price: Double
    }

    struct SeedCategory: Decodable {
        let id: Int64
        let name: String
        let info: String
    }

    struct SeedOrder: Decodable {
        let id: Int64
        let total_value: Double
        let order_status: String
        let order_date: String
        let products: [Int64]
    }

    enum APIError: Error { case badURL }


    private func fetchJSON<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: api + path) else { throw APIError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func exists(entityName: String, id: Int64) throws -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %lld", id)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }

    func clearOrders() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Order.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("clearOrders error:", error.localizedDescription)
        }
    }


    func loadAll() async {
        await loadCategoriesFromAPI()
        await loadProductsFromAPI()
        await loadOrdersFromAPI()
    }

    func loadCategoriesFromAPI() async {
        do {
            let categories: [SeedCategory] = try await fetchJSON("/categories", as: [SeedCategory].self)

            for cat in categories {
                if try !exists(entityName: "Category", id: cat.id) {
                    let obj = Category(context: context)
                    obj.id = cat.id
                    obj.name = cat.name
                    obj.info = cat.info
                }
            }
            try context.save()
        } catch {
            print("loadCategoriesFromAPI error:", error)
        }
    }

    func loadProductsFromAPI() async {
        do {
            let req: NSFetchRequest<Category> = Category.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            let categories = try context.fetch(req)

            for category in categories {
                let categoryID = category.id
                let products: [SeedProduct] = try await fetchJSON("/category/\(categoryID)/products",
                                                                 as: [SeedProduct].self)

                for p in products {
                    if try !exists(entityName: "Product", id: p.id) {
                        let obj = Product(context: context)
                        obj.id = p.id
                        obj.name = p.name
                        obj.price = p.price
                        obj.category_id = categoryID
                        obj.category = category
                    }
                }
            }
            try context.save()
        } catch {
            print("loadProductsFromAPI error:", error)
        }
    }

    func loadOrdersFromAPI() async {
        do {
            let orders: [SeedOrder] = try await fetchJSON("/orders", as: [SeedOrder].self)

            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"

            for o in orders {
                guard let date = df.date(from: o.order_date) else { continue }

                if try !exists(entityName: "Order", id: o.id) {
                    let order = Order(context: context)
                    order.id = o.id
                    order.total_value = o.total_value
                    order.order_status = o.order_status
                    order.order_date = date

                    let prodReq: NSFetchRequest<Product> = Product.fetchRequest()
                    prodReq.predicate = NSPredicate(format: "id IN %@", o.products)
                    let products = try context.fetch(prodReq)
                    products.forEach { order.addToProducts($0) }
                }
            }
            try context.save()
        } catch {
            print("loadOrdersFromAPI error:", error)
        }
    }
}
