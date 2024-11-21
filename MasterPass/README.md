# MasterPass

**MasterPass** is a modern, secure, and user-friendly password management app designed for iOS. Built with SwiftUI, it combines a sleek, red-and-black themed interface with robust security features, including biometric authentication and passcode protection. MasterPass is perfect for users seeking a reliable way to manage their passwords while maintaining privacy and security.

---

## Features

### 1. **Password Management**
- Add, view, edit, and delete passwords with ease.
- Store service details, website, username, email, and password for each entry.
- Secure passwords with hidden visibility by default.

### 2. **Password Visibility Control**
- Unlock passwords using **Face ID** or **Touch ID**.
- Passcode-based fallback for devices without biometric authentication.
- Auto-hide passwords after a configurable time (10 seconds, 30 seconds, 1 minute, or 5 minutes).

### 3. **Account Management**
- Create an account with a username and password.
- Securely log in and log out, ensuring personalized password storage.
- Protect account credentials using secure hash-based encryption.

### 4. **Random Password Generator**
- Generate strong, random passwords with customizable lengths.
- Quickly add generated passwords to new entries.

### 5. **Passcode Protection**
- Set up a 4-digit passcode for additional security.
- Change passcodes by verifying the old passcode.

### 6. **User-Centered Design**
- Red-and-black themed interface with a **colorful MasterPass logo**.
- Launch screen for branding and smooth transitions.
- Intuitive navigation between core features:
  - **Create Password**
  - **Saved Passwords**
  - **Create/Edit Passcode**
  - **Log Out**

---

## Technologies Used

- **SwiftUI**: For building a dynamic and modern user interface.
- **LocalAuthentication**: To enable Face ID and Touch ID for authentication.
- **UserDefaults**: For secure, local storage of passwords and user settings.
- **CryptoKit**: For hashing user passwords during account creation and login.
- **GitHub**: For version control and collaborative development.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/andrewibrah/MasterPass.git
