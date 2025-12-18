#
//  server.py
//  ShopList
//
//  Created by user277759 on 12/18/25.
//

from flask import Flask, jsonify, request

app = Flask(__name__)

# Categories
categories_data = [
    {"id": 1, "name": "Food",     "info": "Food products"},
    {"id": 2, "name": "Clothes",  "info": "Clothes products"},
    {"id": 3, "name": "Vehicles", "info": "Cars and Bikes"},
]

# Products
products_data = [
    {"id": 1, "name": "Bread",   "price": 4.99,    "category_id": 1},
    {"id": 2, "name": "Potatos", "price": 2.99,    "category_id": 1},

    {"id": 3, "name": "T-Shirt", "price": 19.99,   "category_id": 2},
    {"id": 4, "name": "Hoodie",  "price": 39.99,   "category_id": 2},

    {"id": 5, "name": "Car",     "price": 9999.99, "category_id": 3},
    {"id": 6, "name": "Bike",    "price": 249.99,  "category_id": 3},
]

# Orders
orders_data = [
    {
        "id": 1,
        "total_value": 24.98,  # Bread + T-Shirt (4.99 + 19.99)
        "order_date": "2025-12-01",
        "order_status": "PROCESSING",
        "products": [1, 3],
    },
    {
        "id": 2,
        "total_value": 42.98,  # Potatos + Hoodie (2.99 + 39.99)
        "order_date": "2025-12-02",
        "order_status": "SHIPPED",
        "products": [2, 4],
    },
    {
        "id": 3,
        "total_value": 10249.97,  # Car + Bike (9999.99 + 249.99)
        "order_date": "2026-09-12",
        "order_status": "SEND",
        "products": [5, 6],
    },
]

@app.route("/categories", methods=["GET"])
def get_categories():
    return jsonify(categories_data)

@app.route("/category/<int:category_id>/products", methods=["GET"])
def get_products_for_category(category_id):
    category_products = [p for p in products_data if p["category_id"] == category_id]
    return jsonify(category_products)

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders_data)

@app.route("/product", methods=["POST"])
def add_product():
    data = request.get_json(silent=True) or {}

    name = data.get("name")
    price = data.get("price")
    category_id = data.get("category_id")

    if not name or category_id is None or price is None:
        return jsonify({"error": "Missing fields: name, price, category_id"}), 400

    try:
        price = float(price)
        category_id = int(category_id)
    except ValueError:
        return jsonify({"error": "price must be number and category_id must be int"}), 400

    if not any(c["id"] == category_id for c in categories_data):
        return jsonify({"error": "category_id does not exist"}), 400

    new_id = (max((p["id"] for p in products_data), default=0) + 1)

    new_product = {
        "id": new_id,
        "name": name,
        "price": price,
        "category_id": category_id,
    }

    products_data.append(new_product)

    return jsonify({"id": new_id}), 201


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5050, debug=True)
