# 📖 Quran Learning Academy App

A comprehensive, high-performance Flutter application designed to bridge the gap between Quran teachers and students globally. This platform facilitates seamless learning through real-time video classrooms, structured booking systems, and interactive communication.

---

## 🚀 Features

### 👨‍🏫 For Teachers
- **Dynamic Dashboard**: Manage upcoming classes, student progress, and earnings at a glance.
- **Availability Management**: Custom slot scheduling to define teaching hours.
- **Progress Notes**: Detailed feedback and tracking for each student after sessions.
- **Classroom Control**: High-quality video calls with students via Agora integration.

### 🎓 For Students
- **Teacher Discovery**: Browse and book qualified Quran teachers.
- **Flexible Booking**: Schedule classes based on personal availability.
- **Real-time Chat**: Direct messaging with teachers for queries and coordination.
- **Interactive Learning**: Join live classrooms with interactive video/audio tools.

### 🛠️ Core Functionalities
- **Secure Authentication**: Robust login/signup system powered by Firebase.
- **Instant Notifications**: Automated reminders for upcoming classes and new messages.
- **Role-Based Access**: Dedicated interfaces for Student and Teacher personas.
- **Modern UI/UX**: Clean, intuitive, and responsive design using Google Fonts and custom themes.

---

## 📸 Screenshots

| Splash & Auth | Student Dashboard | Teacher Dashboard |
| :---: | :---: | :---: |
| ![Splash](https://via.placeholder.com/200x400?text=Splash+Screen) | ![Student](https://via.placeholder.com/200x400?text=Student+Dashboard) | ![Teacher](https://via.placeholder.com/200x400?text=Teacher+Dashboard) |

| Video Classroom | Chat System | Booking Flow |
| :---: | :---: | :---: |
| ![Classroom](https://via.placeholder.com/200x400?text=Video+Class) | ![Chat](https://via.placeholder.com/200x400?text=Chat+Interface) | ![Booking](https://via.placeholder.com/200x400?text=Booking+System) |

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (3.x)
- **State Management**: [Riverpod](https://riverpod.dev/) (NotifierProvider)
- **Backend**: [Firebase](https://firebase.google.com/) (Firestore, Auth, Messaging)
- **Video/Audio**: [Agora RTC SDK](https://www.agora.io/)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Local Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- **Styling**: Google Fonts, Flutter SVG, Custom Design System

---

## ⚙️ Installation & Setup

### Prerequisites
- Flutter SDK installed (`flutter doctor` should be green)
- Firebase Account
- Agora Console Account (for App ID)

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/quran_learning_app.git
   cd quran_learning_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**:
   - Create a new Firebase project.
   - Add Android/iOS apps in Firebase Console.
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Place them in `android/app/` and `ios/Runner/` respectively.

4. **Agora Configuration**:
   - Create a project on [Agora Console](https://console.agora.io/).
   - Obtain your **App ID**.
   - Update the App ID in your configuration file (usually found in `lib/core/constants/` or passed via environment variables).

5. **Run the App**:
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
lib/
├── core/           # Navigation, Theme, Services, Constants
├── features/       # Feature-based modules (Auth, Teacher, Student, Profile)
├── models/         # Data models & JSON serialization
├── provider/       # Riverpod providers for state management
└── main.dart       # App entry point
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

Developed with ❤️ for the Quranic Community.
