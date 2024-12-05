import customtkinter as ctk
import tkinter.messagebox as tkmb
import sqlite3
import bcrypt

# Selecting GUI theme - dark, light , system (for system default)
ctk.set_appearance_mode("dark")

# Selecting color theme - blue, green, dark-blue
ctk.set_default_color_theme("blue")

app = ctk.CTk()
app.geometry("400x400")
app.title("SafeSys Analyzer")


def login():
    username = user_entry.get()
    password = user_pass.get()
    if not username or not password:
        tkmb.showerror(title="Invalid Input", message="Credentials cannot be blank")
        return

    try:
        conn = sqlite3.connect('database/users.db')
        cursor = conn.cursor()
        cursor.execute("SELECT password FROM users WHERE username = ?", (username,))
        result = cursor.fetchone()

        if result:
            hashed_password = result[0]
            if bcrypt.checkpw(password.encode('utf-8'), hashed_password):
                tkmb.showinfo("Login Successful", "You have logged in successfully!")
            else:
                tkmb.showwarning("Invalid Password", "Incorrect password. Please try again.")
        else:
            tkmb.showwarning(title="False credentials", message="Username or Password incorrect")

    except Exception as e:
        tkmb.showerror(title="Fatal error", message="There was a problem in connecting to the Database!")

    finally:
        conn.close()


def signup():
    def register_user():
        new_username = new_user_entry.get()
        new_password = new_user_pass.get()
        confirm_password = confirm_user_pass.get()

        if not new_username or not new_password or not confirm_password:
            tkmb.showerror("Invalid Input", "All fields are required!")
            return

        if new_password != confirm_password:
            tkmb.showerror("Password Mismatch", "Passwords do not match!")
            return

        try:
            # Connect to the database
            conn = sqlite3.connect('database/users.db')
            cursor = conn.cursor()

            # Hash the password
            hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())

            # Insert the new user into the database
            cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", (new_username, hashed_password))
            conn.commit()

            tkmb.showinfo("Signup Successful", "Your account has been created successfully!")
            signup_window.destroy()  # Close the signup window after success

        except sqlite3.IntegrityError:
            tkmb.showerror("Username Exists", "The username is already taken. Please choose another.")
        except Exception as e:
            tkmb.showerror("Database Error", f"An error occurred: {e}")
        finally:
            conn.close()

    # Create a new signup window
    signup_window = ctk.CTkToplevel(app)
    signup_window.title("Create New Account")
    signup_window.geometry("400x400")

    # Signup form
    ctk.CTkLabel(signup_window, text="Signup Page", font=("Arial", 18)).pack(pady=20)

    new_user_entry = ctk.CTkEntry(signup_window, placeholder_text="Enter Username")
    new_user_entry.pack(pady=10, padx=10)

    new_user_pass = ctk.CTkEntry(signup_window, placeholder_text="Enter Password", show="*")
    new_user_pass.pack(pady=10, padx=10)

    confirm_user_pass = ctk.CTkEntry(signup_window, placeholder_text="Confirm Password", show="*")
    confirm_user_pass.pack(pady=10, padx=10)

    signup_button = ctk.CTkButton(signup_window, text="Sign Up", command=register_user)
    signup_button.pack(pady=20)

    signup_window.mainloop()


label = ctk.CTkLabel(app, text="This is the main UI page")
label.pack(pady=20)

frame = ctk.CTkFrame(master=app)
frame.pack(pady=20, padx=40, fill='both', expand=True)

label = ctk.CTkLabel(master=frame, text='Modern Login System UI')
label.pack(pady=12, padx=10)

user_entry = ctk.CTkEntry(master=frame, placeholder_text="Username")
user_entry.pack(pady=12, padx=10)

user_pass = ctk.CTkEntry(master=frame, placeholder_text="Password", show="*")
user_pass.pack(pady=12, padx=10)

button = ctk.CTkButton(master=frame, text='Login', command=login)
button.pack(pady=12, padx=10)

# checkbox = ctk.CTkCheckBox(master=frame, text='Remember Me')
# checkbox.pack(pady=12, padx=10)

logup = ctk.CTkButton(master=frame, text='Create New Account', command=signup)
logup.pack(pady=12, padx=10)

app.mainloop()
