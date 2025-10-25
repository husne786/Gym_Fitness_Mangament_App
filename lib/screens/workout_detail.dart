import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/exercise_player.dart';
import 'package:gym_fitness_app/screens/workout_categories.dart';

class WorkoutDetail extends StatelessWidget {
  const WorkoutDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Plans'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Color(0xFF40C4FF)
                ], // Green to Light Blue
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('45 min • Moderate • Equipment: Dumbbells'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text(
                  'A comprehensive full body workout targeting major muscle groups for balanced strength development.'),
              const SizedBox(height: 24),
              const Text('Exercises',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (SelectedExercises.selected.isEmpty)
                const Text(
                    'No exercises selected yet. Go to categories to add some!'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SelectedExercises.selected.length,
                itemBuilder: (context, index) {
                  var ex = SelectedExercises.selected[index];
                  return _buildExerciseCard(
                    ex['name']!,
                    ex['reps']!,
                    ex['imageUrl']!,
                    ex['description']!,
                  );
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (SelectedExercises.selected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No exercises selected')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExercisePlayer()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 21, 122, 145),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Workout',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
      String name, String reps, String imageUrl, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(reps),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
