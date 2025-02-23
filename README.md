# AI-Powered Sign Language Interpreter App 🤟

A real-time sign language interpretation application powered by Gemini AI, built with Flutter. This app helps bridge communication gaps by translating sign language gestures into text instantly.

---

## App Demo 🎥

[Watch Demo on Google Drive](https://drive.google.com/file/d/1Bir4621T_g01yMsS2wI6nsCnFeg6MYGi/view?usp=drivesdk)
---

## Features ✨

### **1. Real-time Sign Language Detection**
- Live camera feed for instant sign language capture
- Motion detection to optimize processing
- Real-time text translation of sign language gestures

### **2. AI-Powered Translation**
- Powered by Google's Gemini AI model
- Accurate and quick interpretation
- Support for various sign language gestures

### **3. User Experience**
- Clean, modern interface
- Intuitive controls with start/stop functionality
- Translation history with scrollable view
- Smooth animations and transitions

### **4. Onboarding Experience**
- Interactive introduction to app features
- Step-by-step guide for new users
- Animated transitions between onboarding screens

---

## Implementation Details 💻

### **AI Integration**
- Uses `google_generative_ai` package for Gemini API integration
- Optimized image processing for better performance
- Efficient handling of API responses

### **Camera Implementation**
- Real-time camera feed using `camera` package
- Motion detection to reduce unnecessary processing
- Automatic image capture at optimal intervals

### **UI/UX**
- Material Design 3 implementation
- Responsive layout for various screen sizes
- Smooth animations for better user experience
- History view with card-based design

---

## Getting Started 🚀

### **1. Clone the Repository**
```bash
git clone https://github.com/31SUFI/sign-language-interpreter.git
```

### **2. Set Up Gemini API**
1. Get your API key from Google AI Studio
2. Add it to the `GeminiService` class

### **3. Install Dependencies**
```bash
flutter pub get
```

### **4. Run the App**
```bash
flutter run
```

---

## Dependencies 🧩
```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5+9
  google_generative_ai: ^0.2.0
  permission_handler: ^11.3.0
  path_provider: ^2.1.2
  path: ^1.8.3
```

---

## Technical Requirements 📱

- Android: SDK 21 or later
- iOS: 11.0 or later
- Camera permission
- Internet connection for AI processing

---

## Architecture 🏗️

The app follows a clean architecture pattern with:
- **Screens**: UI layer (`onboarding_screen.dart`, `sign_language_interpreter_screen.dart`)
- **Services**: Business logic layer (`gemini_service.dart`)
- **Widgets**: Reusable UI components (`camera_view.dart`, `interpretation_result.dart`)

---

## Contributing 🤝

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create your feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

---



## Acknowledgments 🙏

- Google's Gemini AI for powering the translations
- Flutter team for the amazing framework

---


