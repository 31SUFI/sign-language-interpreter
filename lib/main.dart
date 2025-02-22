import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/onboarding_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize cameras
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Camera initialization error: ${e.description}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Language Interpreter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
