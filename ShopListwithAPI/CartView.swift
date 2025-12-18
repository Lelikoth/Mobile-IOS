//
//  CartView.swift
//  ShopList
//
//  Created by user277759 on 12/10/25.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cart: itemsInCart
    
    var body: some View {
        
        VStack {
            List {
                ForEach(cart.items.sorted(by: <), id: \.key) { key, value in
                    HStack {
                        Text(key)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Stepper(value: Binding(
                            get: { value },
                            set: { newValue in
                                if newValue == 0 {
                                    cart.items.removeValue(forKey: key)
                                }
                                else{
                                    cart.items[key] = newValue
                                }
                            }
                        )) {
                            Label(
                                title: { Text("\(value)") },
                                icon: { Image(systemName: "42.circle") }
                            ).labelStyle(.titleOnly)
                        }
                    }
                }
            }
        }
    }
}
