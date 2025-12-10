//
//  CategoryView.swift
//  ShopList
//
//  Created by user277759 on 12/10/25.
//

import SwiftUI
import CoreData

struct CategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var category: Category
    @ObservedObject var cart: itemsInCart
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var products: FetchedResults<Product>
    
    init(category: Category, cart: itemsInCart) {
        self.category = category
        self.cart = cart
        _products = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "category == %@", argumentArray: [category]),
            animation: .default)
    }
    
    var body: some View {
        VStack {
            Text(category.name ?? "")
                .font(.title)
            VStack {
                Text(category.info ?? "").onTapGesture(perform: {
                    print(category)
                })
            }
            Spacer()
            
            List {
                ForEach(products) { product in
                    HStack{
                        NavigationLink(product.name!, destination: ProductView(product: product, cart: cart))
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
