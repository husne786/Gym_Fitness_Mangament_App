import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/home_dashboard.dart';
import 'package:gym_fitness_app/screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/workout_categories.dart';
import 'screens/workout_detail.dart';
import 'screens/daily_planner.dart';
import 'screens/progress_tracker.dart';
import 'screens/exercise_player.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeDashboardScreen(),
        '/categories': (context) => WorkoutCategories(),
        '/workoutDetail': (context) => WorkoutDetail(),
        '/calendar': (context) => DailyPlanner(),
        '/progress': (context) => ProgressTracker(),
        '/exercise': (context) => ExercisePlayer(),
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
