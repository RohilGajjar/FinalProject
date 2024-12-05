import json
from tkinter import messagebox
from PIL import Image, ImageTk
import tkinter
import tkinter.messagebox
import customtkinter

customtkinter.set_appearance_mode("System")  # Modes: "System" (standard), "Dark", "Light"
customtkinter.set_default_color_theme("blue")  # Themes: "blue" (standard), "green", "dark-blue"

class App(customtkinter.CTk):
    
    def __init__(self):
        super().__init__()
        
        self.title("Final Project")
        # self.attributes('-fullscreen',True)
        # width= self.winfo_screenwidth() 
        # height= self.winfo_screenheight()
        # self.geometry("%dx%d" % (width, height))
        self.geometry(f"{1100}x{580}")

        self.grid_columnconfigure(1, weight=1)
        self.grid_columnconfigure((1,2, 3,4), weight=1)
        self.grid_rowconfigure((0, 1,2), weight=1)

        self.bind("<Configure>", self.update_wrap_length)

        self.sidebar_frame = customtkinter.CTkFrame(self, width=140, corner_radius=0)
        self.sidebar_frame.grid(row=0, column=0, rowspan=4, sticky="nsew")
        self.sidebar_frame.grid_rowconfigure(4, weight=1)
        image = Image.open("images/system_img.png")
        image = image.resize((250, 200)) 
        image_tk = ImageTk.PhotoImage(image)

        image_label = customtkinter.CTkLabel(self.sidebar_frame, image=image_tk, text="")
        image_label.image = image_tk
        image_label.grid(row=0, column=0, padx=10, pady=10)
        self.logo_label = customtkinter.CTkLabel(self.sidebar_frame, text="SafeSys Analyzer", font=customtkinter.CTkFont(size=20, weight="bold"))
        self.logo_label.grid(row=1, column=0, padx=20, pady=(10, 10))
        # self.sidebar_button_1 = customtkinter.CTkButton(self.sidebar_frame, command=self.sidebar_button_event, text="Home")
        # self.sidebar_button_1.grid(row=1, column=0, padx=20, pady=10)
        # self.sidebar_button_2 = customtkinter.CTkButton(self.sidebar_frame, command=self.sidebar_button_event, text="About")
        # self.sidebar_button_2.grid(row=2, column=0, padx=20, pady=10)
        # self.sidebar_button_3 = customtkinter.CTkButton(self.sidebar_frame, command=self.sidebar_button_event, text="Help")
        # self.sidebar_button_3.grid(row=3, column=0, padx=20, pady=10)
        self.appearance_mode_label = customtkinter.CTkLabel(self.sidebar_frame, text="Appearance Mode:", anchor="w")
        self.appearance_mode_label.grid(row=5, column=0, padx=20, pady=(10, 0))
        self.appearance_mode_optionemenu = customtkinter.CTkOptionMenu(self.sidebar_frame, values=["Light", "Dark", "System"],
                                                                       command=self.change_appearance_mode_event)
        self.appearance_mode_optionemenu.grid(row=6, column=0, padx=20, pady=(10, 10))
        self.title_bg_color="#242424"
        self.data_bg_color="#333333"
       
        self.textbox = customtkinter.CTkFrame(self)
        self.textbox.grid(row=0, column=1,columnspan=2, padx=(20, 20), pady=(20, 20), sticky="nsew")
        self.textbox_title=customtkinter.CTkLabel(self.textbox,text="Start your auditing",font=customtkinter.CTkFont(size=20, weight="bold"))
        self.textbox_title.grid(row=0, column=0, padx=(10, 0), pady=(5, 0), sticky="nw")
        self.textbox_description=customtkinter.CTkLabel(self.textbox,text="\nTo begin the auditing process, please select the area you would like to audit.\n Choose from the following options to proceed:\n 1. Password Settings: Check for vulnerabilities related to account passwords.\n 2. Firewall Configuration: Audit firewall settings for network protection.\n 3. User Account Management: Review user accounts and permissions.\n",justify="left",wraplength=300)
        self.textbox_description.grid(row=1,column=0,padx=(10,0),pady=(5,0),sticky="nw")

        self.radio_var = tkinter.IntVar(value=0)  # Default selection value is 0

        self.accounts_button = customtkinter.CTkRadioButton(self.textbox, text="Accounts", variable=self.radio_var, value=0)
        self.accounts_button.grid(row=2, column=0, pady=10, padx=10, sticky="w")

        self.audit_button = customtkinter.CTkRadioButton(self.textbox, text="Audit Policy", variable=self.radio_var, value=1)
        self.audit_button.grid(row=2, column=1, pady=10, sticky="w")

        self.password_button = customtkinter.CTkRadioButton(self.textbox, text="Password", variable=self.radio_var, value=2)
        self.password_button.grid(row=3, column=0, pady=10, padx=10, sticky="w")

        self.pub_firewall_button = customtkinter.CTkRadioButton(self.textbox, text="Public Firewall", variable=self.radio_var, value=3)
        self.pub_firewall_button.grid(row=3, column=1, pady=10, sticky="w")

        self.pvt_firewall_button = customtkinter.CTkRadioButton(self.textbox, text="Private Firewall", variable=self.radio_var, value=4)
        self.pvt_firewall_button.grid(row=4, column=0, pady=10, padx=10, sticky="w")

        self.rights_button = customtkinter.CTkRadioButton(self.textbox, text="Rights", variable=self.radio_var, value=5)
        self.rights_button.grid(row=4, column=1, pady=10, sticky="w")

        self.run_btn=customtkinter.CTkButton(self.textbox,text="Run",width=150,command=self.retrive_data)
        self.run_btn.grid(row=5, column=0, padx=10, pady=15, sticky="w")

        # self.data_label = customtkinter.CTkLabel(self.textbox, text="", justify="left")
        # self.data_label.grid(row=6, column=0, padx=10, pady=10, sticky="w")

        # self.tabview = customtkinter.CTkTabview(self, width=250)
        # self.tabview.grid(row=0, column=3, columnspan=2, padx=(20, 20), pady=(20, 0),sticky="nsew")
        # self.tabview.add("Accounts")
        # self.tabview.add("Audit Policy")
        # self.tabview.add("Password")
        # self.tabview.add("Public Firewall")
        # self.tabview.add("Private Firewall")
        # self.tabview.add("Rights")
        # self.tabview.tab("Accounts").grid_columnconfigure(0, weight=1)  # configure grid of individual tabs
        # self.tabview.tab("Audit Policy").grid_columnconfigure(0, weight=1)
        # self.tabview.tab("Password").grid_columnconfigure(0, weight=1)
        # self.tabview.tab("Public Firewall").grid_columnconfigure(0, weight=1)
        # self.tabview.tab("Private Firewall").grid_columnconfigure(0, weight=1)
        # self.tabview.tab("Rights").grid_columnconfigure(0, weight=1)
        # self.tabview1=customtkinter.CTkScrollableFrame(self.tabview.tab("Password"))
        # self.tabview1.grid(padx=0,pady=0,sticky="nsew")
        # self.tabview1_label=customtkinter.CTkLabel(self.tabview1,justify="left")
        # self.tabview1_label.grid(padx=0,pady=0,sticky="nsew")
        # self.password_polocies()
   
        self.scrollable_frame = customtkinter.CTkScrollableFrame(self, label_text="Vulnerabilities")
        self.scrollable_frame.grid(row=0, column=3,columnspan=2, padx=(20, 20), pady=(20, 20), sticky="nsew")
        self.scrollable_frame.grid_columnconfigure(0, weight=1)
        self.load_image_in_scrollable_frame("images/no_data_found_img.png")

        self.data_table = customtkinter.CTkScrollableFrame(self)
        self.data_table.grid(row=1, column=1,rowspan=2,columnspan=3, padx=(20, 20), pady=(20, 20), sticky="nsew")
        self.data_table.grid_columnconfigure(0, weight=1)
        self.data_table.grid_columnconfigure(1, weight=1)
        self.data_table.grid_columnconfigure(2, weight=1)
        self.data_table.grid_columnconfigure(3, weight=1)
        self.data_table.grid_columnconfigure(4, weight=1)


        self.checkbox_slider_frame = customtkinter.CTkFrame(self)
        self.checkbox_slider_frame.grid(row=1, column=4,rowspan=2, padx=(20, 20), pady=(20, 20), sticky="nsew")
        self.checkbox_slider_frame_title=customtkinter.CTkLabel(self.checkbox_slider_frame,text="Download File",font=customtkinter.CTkFont(size=16, weight="bold"))
        self.checkbox_slider_frame_title.grid(row=0,column=0,pady=(20, 0), padx=20)
        self.checkbox_1 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame,text="Accounts")
        self.checkbox_1.grid(row=1, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_2 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame, text="Audit Policy")
        self.checkbox_2.grid(row=2, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_3 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame, text="Password")
        self.checkbox_3.grid(row=3, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_1 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame,text="Public Firewall")
        self.checkbox_1.grid(row=4, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_1 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame,text="Private Firewall")
        self.checkbox_1.grid(row=5, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_1 = customtkinter.CTkCheckBox(master=self.checkbox_slider_frame,text="Rights")
        self.checkbox_1.grid(row=6, column=0, pady=(20, 0), padx=(50,0), sticky="nw")
        self.checkbox_1.select()
        self.download_btn=customtkinter.CTkButton(self.checkbox_slider_frame,text="Download")
        self.download_btn.grid(row=7, column=0, padx=(50,20), pady=30)
  
        self.appearance_mode_optionemenu.set("Dark")
        self.update_wrap_length()
    # def password_polocies(self):
    #     try:
    #         # Load the JSON file (replace with your actual JSON file path)
    #         with open("./JSON/audit_policy/audit_index.json", "r") as file:
    #             data1 = json.load(file)
    #         with open("./JSON/audit_policy/audit_benchmark.json", "r") as file:
    #             data2=json.load(file)
    #         combined_data = []

    #         # Iterate through all three lists using the same index
    #         for i in range(min(len(data1), len(data2))):  # Ensure we don't exceed any list's length
    #             # Format: "Benchmark Value => Description => Additional Value"
    #             combined_entry = f"{data1[i]} {data2[i]}\n"
    #             combined_data.append(combined_entry)  # Add to the combined data list

    #         # Join all combined entries into a single string separated by newlines
    #         formatted_data = "\n".join(combined_data)
    #         self.tabview1_label.configure(text=formatted_data)
    #     except FileNotFoundError:
    #         messagebox.showerror("Error", "JSON file not found!")
    #     except json.JSONDecodeError:
    #         messagebox.showerror("Error", "Invalid JSON format!")
    #     except Exception as e:
    #         tkinter.messagebox.showerror("Error", f"An unexpected error occurred: {str(e)}")
    
    def retrive_data(self):
        self.clear_frame()
        select=(self.radio_var.get())
        if(select==0):
            index_path="JSON/accounts/accounts_index.json"
            benchmark_path="JSON/accounts/accounts_benchmark.json"
            current_path="JSON/accounts/accounts_CurrentValue.json"
            default_path="JSON/accounts/accounts_DefaultValue.json"
            optimal_path="JSON/accounts/accounts_OptimalValue.json"
            error_path="JSON/accounts/accounts_error.json"
        elif(select==1):
            index_path="JSON/audit_policy/audit_index.json"
            benchmark_path="JSON/audit_policy/audit_benchmark.json"
            current_path="JSON/audit_policy/audit_CurrentValue.json"
            default_path="JSON/audit_policy/audit_DefaultValue.json"
            optimal_path="JSON/audit_policy/audit_OptimalValue.json"
            error_path="JSON/audit_policy/audit_error.json"
        elif(select==2):
            index_path="JSON/password/pw_index.json"
            benchmark_path="JSON/password/pw_benchmark.json"
            current_path="JSON/password/pw_CurrentValue.json"
            default_path="JSON/password/pw_DefaultValue.json"
            optimal_path="JSON/password/pw_OptimalValue.json"
            error_path="JSON/password/pw_error.json"
        elif(select==3):
            index_path="JSON/public_firewall/fwpublic_profile.json"
            benchmark_path="JSON/public_firewall/fwpublic_benchmarks.json"
            current_path="JSON/public_firewall/fwpublic_CurrentValue.json"
            default_path="JSON/public_firewall/fwpublic_DefaultValue.json"
            optimal_path="JSON/public_firewall/fwpublic_OptimalValue.json"
            error_path="JSON/public_firewall/fwpublic_err.json"
        elif(select==4):
            index_path="JSON/pvt_firewall/fwprivate_profile.json"
            benchmark_path="JSON/pvt_firewall/fwprivate_benchmark.json"
            current_path="JSON/pvt_firewall/fwprivate_CurrentValue.json"
            default_path="JSON/pvt_firewall/fwprivate_DefaultValue.json"
            optimal_path="JSON/pvt_firewall/fwprivate_OptimalValue.json"
            error_path="JSON/pvt_firewall/fwprivate_error.json"
        elif(select==5):
            index_path="JSON/rights/rights_index.json"
            benchmark_path="JSON/rights/rights_benchmark.json"
            current_path="JSON/rights/rights_CurrentValue.json"
            default_path="JSON/rights/rights_DefaultValue.json"
            optimal_path="JSON/rights/rights_OptimalValue.json"
            error_path="JSON/rights/rights_error.json"
        else:
            return


        try:
            # Load the JSON file (replace with your actual JSON file path)
            with open(index_path, "r", encoding="utf-8-sig") as file:
                index_data = json.load(file)
            with open(benchmark_path, "r", encoding="utf-8-sig") as file:
                benchmark_data=json.load(file)
            with open(current_path, "r", encoding="utf-8-sig") as file:
                current_data=json.load(file)
            with open(default_path, "r", encoding="utf-8-sig") as file:
                default_data=json.load(file)
            with open(optimal_path, "r", encoding="utf-8-sig") as file:
                optimal_data=json.load(file)
            # Format the list into a string, separating items by newlines
            # with open("./JSON/audit_policy/audit_CurrentValue.json", "r") as file:  # Load the third file
            #     data3 = json.load(file)  # Additional values

        # Initialize a list to hold the formatted output
            # combined_data = []
            # self.data_table=customtkinter.CTkFrame(self.textbox)
            # self.data_table.grid(padx=10,pady=10,sticky="nsew")
            self.data_index=[]
            self.data_benchmark=[]
            self.data_current=[]
            self.data_default=[]
            self.data_optimal=[]
            self.data_error=[]
            self.index_title=customtkinter.CTkLabel(self.data_table, text="Index",bg_color=self.title_bg_color,corner_radius=10,wraplength=60 )
            self.index_title.grid(row=0,column=0,padx=3,pady=3,sticky="nsew")
            self.benchmark_title=customtkinter.CTkLabel(self.data_table, text="Benchmark",bg_color=self.title_bg_color,corner_radius=10,wraplength=60 )
            self.benchmark_title.grid(row=0,column=1,padx=3,pady=3,sticky="nsew")
            self.current_title=customtkinter.CTkLabel(self.data_table, text="Current Value",bg_color=self.title_bg_color,corner_radius=10,wraplength=60 )
            self.current_title.grid(row=0,column=2,padx=3,pady=3,sticky="nsew")
            self.default_title=customtkinter.CTkLabel(self.data_table, text="Default Value",bg_color=self.title_bg_color,corner_radius=10,wraplength=60 )
            self.default_title.grid(row=0,column=3,padx=3,pady=3,sticky="nsew")
            self.optimal_title=customtkinter.CTkLabel(self.data_table, text="Optimal Value",bg_color=self.title_bg_color,corner_radius=10,wraplength=60 )
            self.optimal_title.grid(row=0,column=4,padx=3,pady=3,sticky="nsew")
             # Iterate through all three lists using the same index
            for i in range(min(len(index_data), len(benchmark_data))):  # Ensure we don't exceed any list's length
                # Format: "Benchmark Value => Description => Additional Value"
                index_label = customtkinter.CTkLabel(self.data_table, text=index_data[i],bg_color=self.data_bg_color,corner_radius=10,wraplength=60 )
                index_label.grid(row=i+1,column=0,padx=3,pady=3,sticky="nsew")  # Position the label in column 0
                self.data_index.append(index_label)  # Add the label to the index list

                benchmark_label = customtkinter.CTkLabel(self.data_table, text=benchmark_data[i],bg_color=self.data_bg_color,corner_radius=5,wraplength=150)
                benchmark_label.grid(row=i+1,column=1,padx=3,pady=3,stick="nsew")  # Position the label in column 1
                self.data_benchmark.append(benchmark_label) 

                current_label = customtkinter.CTkLabel(self.data_table, text=current_data[i],bg_color=self.data_bg_color,corner_radius=5,wraplength=120)
                current_label.grid(row=i+1,column=2,padx=3,pady=3,stick="nsew")  # Position the label in column 1
                self.data_default.append(current_label) 

                default_label = customtkinter.CTkLabel(self.data_table, text=default_data[i],bg_color=self.data_bg_color,corner_radius=5,wraplength=120)
                default_label.grid(row=i+1,column=3,padx=3,pady=3,stick="nsew")  # Position the label in column 1
                self.data_default.append(default_label) 

                optimal_label = customtkinter.CTkLabel(self.data_table, text=optimal_data[i],bg_color=self.data_bg_color,corner_radius=5,wraplength=120)
                optimal_label.grid(row=i+1,column=4,padx=3,pady=3,stick="nsew")  # Position the label in column 1
                self.data_default.append(optimal_label) 


                # combined_entry = f"{data1[i]} {data2[i]} => \n"
                # combined_data.append(combined_entry)  # Add to the combined data list

            #  # Join all combined entries into a single string separated by newlines
            # formatted_data = "\n".join(combined_data)

            # # Display the formatted list below the Run button
            # self.data_label.configure(text=formatted_data)
        except FileNotFoundError:
            messagebox.showerror("Error", "JSON file not found!")
        except json.JSONDecodeError:
            messagebox.showerror("Error", "Invalid JSON format!")
        except Exception as e:
            tkinter.messagebox.showerror("Error", f"An unexpected error occurred: {str(e)}")
        try:
            with open(error_path, "r", encoding="utf-8-sig") as file:
                error_data=json.load(file)
            for i in range(len(error_data)):
                error_label = customtkinter.CTkLabel(self.scrollable_frame, text=error_data[i],bg_color=self.data_bg_color,corner_radius=50,wraplength=350)
                error_label.grid(row=i,column=0,padx=3,pady=3,sticky="nsew")  # Position the label in column 0
                self.data_error.append(error_label)  # Add the label to the index list
        except Exception as e:
            self.load_image_in_scrollable_frame("images/no_data_found_img.png")
    def clear_frame(self):
        for widgets in self.scrollable_frame.winfo_children():
            widgets.destroy()
    def load_image_in_scrollable_frame(self, image_path):
        """Load and display an image inside the scrollable frame."""
        image = Image.open(image_path)
        image = image.resize((300, 300)) 
        image_tk = ImageTk.PhotoImage(image)

        image_label = customtkinter.CTkLabel(self.scrollable_frame, image=image_tk, text="")
        image_label.image = image_tk
        image_label.grid(row=0, column=0, padx=10, pady=20)

    def update_wrap_length(self, event=None):
        """Dynamically adjust the wrap length based on window size, ensuring words aren't split."""
        # Get the current window width and calculate a percentage for wraplength
        wrap_length = int(self.winfo_width() * 0.4)  # Set wrap length as 40% of window width (adjust as needed)
        self.textbox_description.configure(wraplength=wrap_length)
    def open_input_dialog_event(self):
        dialog = customtkinter.CTkInputDialog(text="Type in a number:", title="CTkInputDialog")
        print("CTkInputDialog:", dialog.get_input())

    def change_appearance_mode_event(self, new_appearance_mode: str):
        customtkinter.set_appearance_mode(new_appearance_mode)
        if(new_appearance_mode=="Light"):
            self.title_bg_color="#c7c7c7"
            self.data_bg_color="#ebebeb"
            self.retrive_data()

    def change_scaling_event(self, new_scaling: str):
        new_scaling_float = int(new_scaling.replace("%", "")) / 100
        customtkinter.set_widget_scaling(new_scaling_float)

    def sidebar_button_event(self):
        print("sidebar_button click")

if __name__ == "__main__":
    app = App()
    app.mainloop()
