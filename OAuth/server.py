from flask import Flask, request, jsonify
import secrets

app = Flask(__name__)

users_db = [
    {"id": "u1", "username": "admin", "password": "admin1", "first_name": "Admin", "last_name": "Admini"},
    {"id": "u2", "username": "user1", "password": "password1", "first_name": "Jan", "last_name": "Nowak"},
]

# (provider, provider_user_id) -> user_id + raw token
oauth_db = {}

# accessToken -> user_id
sessions = {}

def user_to_public(u):
    return {"username": u["username"], "firstName": u["first_name"], "lastName": u["last_name"]}

def new_session(user_id):
    token = secrets.token_urlsafe(32)
    sessions[token] = user_id
    return token

def find_user_by_username(username):
    for u in users_db:
        if u["username"] == username:
            return u
    return None

def find_user_by_id(uid):
    for u in users_db:
        if u["id"] == uid:
            return u
    return None

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"message": "Missing username or password"}), 400

    user = find_user_by_username(username)
    if not user or user["password"] != password:
        return jsonify({"message": "Invalid credentials"}), 401

    access = new_session(user["id"])
    return jsonify({"user": user_to_public(user), "accessToken": access}), 200

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json() or {}
    username = data.get("username")
    password = data.get("password")
    first_name = data.get("first_name")
    last_name = data.get("last_name")

    if not all([username, password, first_name, last_name]):
        return jsonify({"message": "Missing fields"}), 400

    if find_user_by_username(username):
        return jsonify({"message": "Username already exists"}), 409

    uid = secrets.token_hex(8)
    new_user = {"id": uid, "username": username, "password": password, "first_name": first_name, "last_name": last_name}
    users_db.append(new_user)

    access = new_session(uid)
    return jsonify({"user": user_to_public(new_user), "accessToken": access}), 201

@app.route("/oauth", methods=["POST"])
def oauth():
    data = request.get_json() or {}
    provider = data.get("provider")              # google / facebook
    provider_user_id = data.get("provider_user_id")
    token = data.get("token")

    if not provider or not provider_user_id or not token:
        return jsonify({"message": "Missing provider/provider_user_id/token"}), 400

    key = (provider, provider_user_id)

    record = oauth_db.get(key)

    if record:
        user = find_user_by_id(record["user_id"])
    else:
        uid = secrets.token_hex(8)
        username = f"{provider}_{provider_user_id}"
        user = {"id": uid, "username": username, "password": "", "first_name": provider.capitalize(), "last_name": "User"}
        users_db.append(user)
        oauth_db[key] = {"user_id": uid, "token": token}

    oauth_db[key]["token"] = token

    access = new_session(user["id"])
    return jsonify({"user": user_to_public(user), "accessToken": access}), 200

@app.route("/me", methods=["GET"])
def me():
    auth = request.headers.get("Authorization", "")
    if not auth.startswith("Bearer "):
        return jsonify({"message": "Missing bearer token"}), 401

    access = auth.removeprefix("Bearer ").strip()
    user_id = sessions.get(access)
    if not user_id:
        return jsonify({"message": "Invalid session"}), 401

    user = find_user_by_id(user_id)
    if not user:
        return jsonify({"message": "User not found"}), 404

    return jsonify(user_to_public(user)), 200

if __name__ == "__main__":
    app.run(debug=True)

