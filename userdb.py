import sqlite3

# Establish a connection to the database (or create it if it doesn't exist)
conn = sqlite3.connect('database/users.db')

# Create a cursor object to execute SQL commands
cursor = conn.cursor()

# Create the "users" table
cursor.execute('''
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
)
''')

# Commit the changes and close the connection
conn.commit()
conn.close()

print("Database table created successfully.")
