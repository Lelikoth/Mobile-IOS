//
//  AddProductView.swift
//  ShopList
//
//  Created by user277759 on 12/18/25.
//

import SwiftUI


struct AddProductView: View {
    
    @ObservedObject var category: Category
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var productAdded = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    private let API = "http://127.0.0.1:5050"
    
    var body: some View {
        Form{
            TextField("Name", text: $name)
            
            TextField("Price", text: $price)
                .keyboardType(.decimalPad)
            
            Button("Add") {
                addProduct()
            }
            .alert("Error", isPresented: $showingAlert){
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
        .onChange(of: productAdded) {_, newValue in
            if newValue { dismiss()}}
    }
    
    private func showAlert(_ message: String) {
            alertMessage = message
            showingAlert = true
        }

        private struct CreateProductResponse: Decodable {
            let id: Int64
        }

        private func addProduct() {
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else {
                showAlert("Name cannot be empty")
                return
            }

            guard let priceValue = Double(price.replacingOccurrences(of: ",", with: ".")),
                  priceValue >= 0 else {
                showAlert("Invalid price. Enter a positive number.")
                return
            }

            guard let url = URL(string: API + "/product") else {
                showAlert("Bad URL")
                return
            }

            let payload: [String: Any] = [
                "name": trimmedName,
                "price": priceValue,
                "category_id": category.id
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                showAlert("Could not encode request")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { showAlert("Network error: \(error.localizedDescription)") }
                    return
                }

                guard let http = response as? HTTPURLResponse else {
                    DispatchQueue.main.async { showAlert("No HTTP response") }
                    return
                }

                guard (200...299).contains(http.statusCode), let data else {
                    DispatchQueue.main.async { showAlert("Server error (HTTP \(http.statusCode))") }
                    return
                }

             
                let newID: Int64?
                if let plain = try? JSONDecoder().decode(Int64.self, from: data) {
                    newID = plain
                } else if let wrapped = try? JSONDecoder().decode(CreateProductResponse.self, from: data) {
                    newID = wrapped.id
                } else {
                    newID = nil
                }

                guard let id = newID else {
                    DispatchQueue.main.async { showAlert("Unexpected server response") }
                    return
                }

                DispatchQueue.main.async {
                    let product = Product(context: viewContext)
                    product.id = id
                    product.name = trimmedName
                    product.price = priceValue
                    product.category_id = category.id
                    product.category = category

                    do {
                        try viewContext.save()
                        productAdded = true
                    } catch {
                        showAlert("Core Data save failed: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
