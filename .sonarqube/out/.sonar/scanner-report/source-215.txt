import requests
r = requests.post("http://localhost:5246/api/auth/login", json={"username": "admin", "password": "Admin123!"})
token = r.json()["token"]

r2 = requests.get("http://localhost:5246/api/users", headers={"Authorization": f"Bearer {token}"})
for u in r2.json():
    if u["username"] == "AI developer 1":
        print(f"User: {u['username']}, Roles: {u['roleIds']}")
