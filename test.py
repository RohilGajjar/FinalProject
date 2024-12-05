import json
index_path="JSON/accounts/accounts_benchmark.json"
with open(index_path, "r") as file:
    index_data = json.load(file)
print(index_data)