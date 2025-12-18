//
//  Untitled.swift
//  ShopList
//
//  Created by user277759 on 12/18/25.
//

import SwiftUI

struct OrdersView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)],
        animation: .default
    )
    private var orders: FetchedResults<Order>

    var body: some View {
        NavigationView {
            List {
                ForEach(orders, id: \.objectID) { order in
                    OrderRow(order: order)
                }
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct OrderRow: View {
    @State private var isExpanded = false
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Text("Total Value: \(order.total_value, format: .currency(code: Locale.current.currency?.identifier ?? "PLN"))")
                .font(.subheadline)

            if isExpanded {
                productsList
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                isExpanded.toggle()
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Order Date: \(order.order_date?.formatted(date: .numeric, time: .omitted) ?? "-")")
                .font(.headline)

            Spacer()

            statusIcon
        }
    }

    private var statusIcon: some View {
        let status = order.order_status ?? "UNKNOWN"
        return Group {
            switch status {
            case "PROCESSING":
                Image(systemName: "gear")
                    .foregroundColor(.blue)
            case "SHIPPED":
                Image(systemName: "shippingbox")
                    .foregroundColor(.green)
            case "SENT", "SEND":
                Image(systemName: "paperplane")
                    .foregroundColor(.purple)
            default:
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.secondary)
            }
        }
        .accessibilityLabel(Text(status))
    }

    private var productsList: some View {
        let products = (order.products?.allObjects as? [Product] ?? [])
            .sorted { ($0.name ?? "") < ($1.name ?? "") }

        return VStack(alignment: .leading, spacing: 6) {
            ForEach(products, id: \.objectID) { product in
                HStack {
                    Text(product.name ?? "Unknown Name")
                    Spacer()
                    Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "PLN"))
                }
                .padding(8)
                .background(Color.green.opacity(0.15))
                .cornerRadius(8)
            }
        }
        .padding(.top, 4)
    }
}
