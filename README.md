Secure System Audit Application (CIS Benchmark Compliance)
📌 Overview
The Secure System Audit Application is a Windows-based cybersecurity tool designed to evaluate a system’s security posture against CIS (Center for Internet Security) Benchmarks.
It automates system audits using PowerShell scripts and presents the results through a Python-based graphical user interface, helping users identify security gaps efficiently and reliably.

This project was developed as a university-endorsed academic project with a strong focus on security, modular architecture, and usability.

**🎯 Problem Statement**

Manually auditing systems for CIS Benchmark compliance is:

1) Time-consuming

2) Error-prone

3) Requires deep security expertise

This application addresses the problem by automating security checks, generating readable audit reports, and alerting users to potential security risks, all through a user-friendly interface.

**🚀 Key Features**

🔐 Secure User Authentication

Sign up / Sign in with encrypted credential handling

⚙️ Automated System Audits

Executes predefined PowerShell scripts to collect CIS benchmark data

📊 Audit Report Generation

Converts raw audit data into structured, readable reports

🧭 Graphical User Interface

Easy initiation of audits and report viewing

🧾 Logging & Notifications

Tracks audit activity and highlights security red flags

🛡️ Strong Security Practices

Encryption, hashing, and salting for sensitive data

**🧩 System Architecture**

The application follows a modular architecture, consisting of:

User Access Module (UAM) – Manages authentication and access control

PowerShell Module (PSM) – Executes CIS benchmark audit scripts

GUI Module – Provides a user-friendly interface

Report Module (RM) – Generates enhanced audit reports

Logging & Notification Module (LNM) – Logs events and alerts users

Security Module (SM) – Protects credentials and audit data

Audit Management Module (AMM) – Coordinates audit execution

**🛠️ Tech Stack**

Programming Languages

Python

PowerShell

GUI Framework

Tkinter / PyQt (as per implementation)

Database

SQLite

Security

Encryption, hashing, salting techniques

Platform

Windows OS (Windows 10 or higher)

**🖥️ System Requirements**
Hardware

Intel i5 or higher

8 GB RAM or more

256 GB SSD minimum

Software

Windows 10+

Python (with required libraries)

PowerShell (compatible version)

**📂 Project Status**

⚠️ Note:
This project was developed as an academic submission. The application may require environment setup or dependency updates to run on modern systems.
The repository primarily serves as a demonstration of system design, security concepts, and implementation approach.

**📈 Applications**

Corporate IT security audits

Healthcare system compliance

Educational institutions

Financial systems security

Government IT infrastructure

Small & Medium Businesses (SMBs)

**🔮 Future Enhancements**

Web-based version for remote auditing

Advanced analytics and dashboards

Customizable PowerShell audit scripts

Machine learning for predictive security insights

Cross-platform support (Linux/macOS)

Integration with enterprise IT management tools

**📚 References**

CIS Benchmarks – https://www.cisecurity.org/cis-benchmarks

Microsoft PowerShell Documentation – https://learn.microsoft.com/powershell

CustomTkinter – https://customtkinter.tomschimansky

**👨‍💻 Authors**

Rohil Gajjar

Kashish Patel

University-endorsed academic project
