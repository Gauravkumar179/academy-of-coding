import 'package:academy_of_coding/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your pages
// Optional: import firebase_options if using flutterfire configure
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (you can pass firebase_options if using flutterfire CLI)
  await Firebase.initializeApp();
  // If using flutterfire CLI:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sign in anonymously (as in your original code)
  await FirebaseAuth.instance.signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academy_of_coding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness:
            Brightness.dark, // looks better with the splash; adjust if needed
      ),
      // Show animated splash first, then navigate to HomePage
      home: const SplashScreen(),
      // If you want named routes later:
      // getPages: [
      //   GetPage(name: '/', page: () => const SplashScreen()),
      //   GetPage(name: '/home', page: () => const HomePage()),
      // ],
    );
  }
}
