import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/main_navigation.dart';
import 'views/login_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//start of the app, launches the loading screen.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const HomeworkTrackerApp());
}

//not sure what this does 
class HomeworkTrackerApp extends StatelessWidget {
  const HomeworkTrackerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),

    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//This is what controls how the loading screen looks
class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const Text(
                'Homework Tracker',
                style: TextStyle(
                  fontSize: 28, 
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
                LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 50,
                ),
              ],
              ),
            ),
          );  
        // If user is signed in 
        } else if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
