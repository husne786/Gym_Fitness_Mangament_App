import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/daily_planner.dart';
import 'package:gym_fitness_app/screens/exercise_player.dart';
import 'package:gym_fitness_app/screens/notification.dart';
import 'package:gym_fitness_app/screens/profile_screen.dart';
import 'package:gym_fitness_app/screens/progress_tracker.dart';
import 'package:gym_fitness_app/screens/settings_screen.dart';
import 'package:gym_fitness_app/screens/workout_categories.dart';
import 'package:gym_fitness_app/screens/workout_detail.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: const AssetImage('assets/images/logo1.jpg'),
          ),
        ),
        title: const Text(
          'Gym & Fitness',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(
                  'assets/images/profile.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section (Vertical Scroll)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  _buildImageCard(
                    context,
                    'assets/images/strength.jpeg', // Ensure these images exist
                    'Strength Training',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WorkoutCategories()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildImageCard(
                    context,
                    'assets/images/cardio.jpg',
                    'Cardio Workout',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WorkoutCategories()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildImageCard(
                    context,
                    'assets/images/yoga.jpeg',
                    'Yoga & Flexibility',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WorkoutCategories()));
                    },
                  ),
                ],
              ),
            ),
            // Activity Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.teal[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today,
                          color: Colors.black54),
                      title: const Text('Daily Planner',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DailyPlanner()));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.orange[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading:
                          const Icon(Icons.play_circle, color: Colors.black54),
                      title: const Text('Exercise Player',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ExercisePlayer()));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.purple[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.track_changes,
                          color: Colors.black54),
                      title: const Text('Progress Tracker',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProgressTracker()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkoutCategories()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WorkoutDetail()));
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
          }
        },
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Workout Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imagePath, String title,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:
            MediaQuery.of(context).size.width - 32, // Full width minus padding
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black54.withOpacity(0.6),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
