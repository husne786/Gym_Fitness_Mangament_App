import 'package:flutter/material.dart';

class SelectedExercises {
  static List<Map<String, String>> selected = [];
}

class WorkoutHistory {
  static List<Map<String, dynamic>> history = [];
  static void addWorkout(String name, int duration, String status) {
    history.add({
      'name': name,
      'date': DateTime.now().toString().substring(0, 10),
      'duration': duration,
      'status': status,
      'imageUrl':
          'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg',
    });
  }
}

class WorkoutCategories extends StatelessWidget {
  const WorkoutCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Categories'),
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
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCategoryCard(
              context,
              'Strength Training',
              Icons.fitness_center,
              const Color(0xFFFF6B6B),
              'Building muscle strength and endurance using resistance.',
              [
                {
                  'name': 'Barbell Squats',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/barbell-back-squat.jpg',
                  'videoPath': 'assets/videos/barbell_squats.mp4',
                  'reps': '3 sets x 12 reps',
                  'description':
                      'A fundamental lower body exercise that targets the quads, hamstrings, and glutes.'
                },
                {
                  'name': 'Deadlifts',
                  'imageUrl':
                      'https://i.ytimg.com/vi/1ZXobu7JvvE/maxresdefault.jpg',
                  'videoPath': 'assets/videos/deadlift.mp4',
                  'reps': '3 sets x 8 reps',
                  'description':
                      'Great for building back strength and overall power.'
                },
                {
                  'name': 'Bench Press',
                  'imageUrl':
                      'https://i.ytimg.com/vi/SCVCLChPQFY/maxresdefault.jpg',
                  'videoPath': 'assets/videos/bench_press.mp4',
                  'reps': '3 sets x 10 reps',
                  'description':
                      'Classic upper body exercise for chest, shoulders, and triceps.'
                },
                {
                  'name': 'Overhead Press',
                  'imageUrl':
                      'https://i.ytimg.com/vi/5yWaNOvgFCM/maxresdefault.jpg',
                  'videoPath': 'assets/videos/overhead_press.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Targets the shoulders and upper body.'
                },
                {
                  'name': 'Pull-Ups / Lat Pulldown',
                  'imageUrl':
                      'https://i.ytimg.com/vi/aAggnpPyR6E/maxresdefault.jpg',
                  'videoPath': 'assets/videos/pull_up.mp4',
                  'reps': '3 sets x 8 reps',
                  'description': 'Builds back and arm strength.'
                },
                {
                  'name': 'Leg Press',
                  'imageUrl':
                      'https://i.ytimg.com/vi/IZxyjW7MPJQ/maxresdefault.jpg',
                  'videoPath': 'assets/videos/Leg_press.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Machine-based leg exercise.'
                },
              ],
              'Barbells, Dumbbells, Machines, Resistance Bands',
              'https://res.cloudinary.com/hydrow/image/upload/f_auto/w_3840/q_80/v1741799501/Blog/the-15-best-strength-training-exercises.jpg',
            ),
            _buildCategoryCard(
              context,
              'Cardio',
              Icons.directions_run,
              const Color(0xFF4ECDC4),
              'Improving heart health and stamina through continuous movement.',
              [
                {
                  'name': 'Treadmill Running / Walking',
                  'imageUrl':
                      'https://www.shutterstock.com/shutterstock/videos/1017638224/thumb/1.jpg',
                  'videoPath': 'assets/videos/treadmill.mp4',
                  'reps': '30 min',
                  'description': 'Cardio on treadmill.'
                },
                {
                  'name': 'Cycling (Spin Bike)',
                  'imageUrl':
                      'https://i.ytimg.com/vi/udhRFATkN44/maxresdefault.jpg',
                  'videoPath': 'assets/videos/cycling.mp4',
                  'reps': '45 min',
                  'description': 'Spin class or bike ride.'
                },
                {
                  'name': 'Jump Rope',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2014/10/jump-rope-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/jumpping_rope.mp4',
                  'reps': '10 min',
                  'description': 'High intensity cardio.'
                },
                {
                  'name': 'Stair Climber',
                  'imageUrl':
                      'https://cdn.prod.website-files.com/66c501d753ae2a8c705375b6/6786c99afc87df89645659a4_677e55d60d26b92738fcb0b4_HERO_Stair-Climber-101-1024x683.jpeg',
                  'videoPath': 'assets/videos/stair_climber.mp4',
                  'reps': '20 min',
                  'description': 'Legs and cardio.'
                },
                {
                  'name': 'Rowing Machine',
                  'imageUrl':
                      'https://i.ytimg.com/vi/H0r_ZPXJLtg/maxresdefault.jpg',
                  'videoPath': 'assets/videos/rowing_machine.mp4',
                  'reps': '30 min',
                  'description': 'Full body cardio.'
                },
                {
                  'name': 'Zumba / Dance Cardio',
                  'imageUrl':
                      'https://i.ytimg.com/vi/HRkNfdlm5Qs/maxresdefault.jpg',
                  'videoPath': 'assets/videos/zumba.mp4',
                  'reps': '60 min',
                  'description': 'Fun dance workout.'
                },
              ],
              'Treadmill, Stationary Bike, Elliptical, Jump Rope',
              'https://media.gettyimages.com/id/1703973106/photo/cardio-workout-routine-on-an-elliptical-machine.jpg?s=612x612&w=gi&k=20&c=2Ds3BaOvNpAeprlCAeTOMOuLtp9qvg5IieHjuWyiv10=',
            ),
            _buildCategoryCard(
              context,
              'Yoga & Pilates',
              Icons.local_florist,
              const Color(0xFF45B7D1),
              'Flexibility, balance, posture, and mind-body connection.',
              [
                {
                  'name': 'Sun Salutation',
                  'imageUrl':
                      'https://i.ytimg.com/vi/L4Z7lix6Qao/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAI85y3x-yoOK-fMGzfrTb4Uf3xrA',
                  'videoPath': 'assets/videos/sun_salutation.mp4',
                  'reps': '5 rounds',
                  'description': 'Full body yoga flow.'
                },
                {
                  'name': 'Downward Dog',
                  'imageUrl':
                      'https://i.ytimg.com/vi/j97SSGsnCAQ/maxresdefault.jpg',
                  'videoPath': 'assets/videos/downward_dog.mp4',
                  'reps': 'Hold 30s',
                  'description': 'Stretch the hamstrings and back.'
                },
                {
                  'name': 'Plank to Cobra',
                  'imageUrl':
                      'https://s3assets.skimble.com/assets/1570697/image_iphone.jpg',
                  'videoPath': 'assets/videos/plank_to_cobra.mp4',
                  'reps': '10 reps',
                  'description': 'Transition for core and back.'
                },
                {
                  'name': 'Bridge Pose',
                  'imageUrl':
                      'https://i.ytimg.com/vi/NnbvPeAIhmA/sddefault.jpg',
                  'videoPath': 'assets/videos/bridge_pose.mp4',
                  'reps': 'Hold 30s',
                  'description': 'Opens the hips and chest.'
                },
                {
                  'name': 'Pilates Roll-Up',
                  'imageUrl':
                      'https://gethealthyu.com/wp-content/uploads/2014/07/Full-Body-Roll-Up_Exercise.jpg',
                  'videoPath': 'assets/videos/pilates_roll_up.mp4',
                  'reps': '10 reps',
                  'description': 'Core engagement.'
                },
                {
                  'name': 'Leg Circles',
                  'imageUrl':
                      'https://i.ytimg.com/vi/RZqtVL6K8DM/maxresdefault.jpg',
                  'videoPath': 'assets/videos/leg_circles.mp4',
                  'reps': '10 per leg',
                  'description': 'Hip stability.'
                },
                {
                  'name': 'Boat Pose',
                  'imageUrl':
                      'https://i.ytimg.com/vi/gWEey6tp7-c/sddefault.jpg',
                  'videoPath': 'assets/videos/boat_pose.mp4',
                  'reps': 'Hold 30s',
                  'description': 'Balances core.'
                },
                {
                  'name': 'Cat-Cow Stretch',
                  'imageUrl':
                      'https://backintelligence.com/wp-content/uploads/2018/01/Cat-cow-graphic-pinterest.webp',
                  'videoPath': 'assets/videos/cat_cow_stretch.mp4',
                  'reps': '10 reps',
                  'description': 'Spine flexibility.'
                },
              ],
              'Yoga Mat, Pilates Ring, Resistance Bands',
              'https://www.shutterstock.com/image-photo/fitness-pilates-class-women-on-260nw-2392786287.jpg',
            ),
            _buildCategoryCard(
              context,
              'HIIT',
              Icons.flash_on,
              const Color(0xFFF9CA24),
              'Short bursts of intense activity with rest intervals — great for fat burn.',
              [
                {
                  'name': 'Jump Squats',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2015/08/jump-squat-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/jump_squats.mp4',
                  'reps': '3 sets x 15 reps',
                  'description': 'Explosive lower body move.'
                },
                {
                  'name': 'Burpees',
                  'imageUrl':
                      'https://i.ytimg.com/vi/auBLPXO8Fww/maxresdefault.jpg',
                  'videoPath': 'assets/videos/burpees.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Full body explosive exercise.'
                },
                {
                  'name': 'Mountain Climbers',
                  'imageUrl':
                      'https://i.ytimg.com/vi/cnyTQDSE884/sddefault.jpg',
                  'videoPath': 'assets/videos/mountain_climbers.mp4',
                  'reps': '3 sets x 20 reps per side',
                  'description': 'Cardio and core burner.'
                },
                {
                  'name': 'High Knees',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2014/10/high-knees-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/high_knees.mp4',
                  'reps': '3 sets x 30s',
                  'description': 'High intensity knee lifts.'
                },
                {
                  'name': 'Jumping Lunges',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2015/02/jumping-lunges-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/jumping_lunges.mp4',
                  'reps': '3 sets x 12 reps per leg',
                  'description': 'Alternating lunges with jump.'
                },
                {
                  'name': 'Push-Up + Shoulder Tap',
                  'imageUrl':
                      'https://gethealthyu.com/wp-content/uploads/2014/08/Shoulder-Tap-Push-Up_Exercise.jpg',
                  'videoPath': 'assets/videos/push_up_shoulder_tap.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Push-up with shoulder tap for stability.'
                },
                {
                  'name': 'Plank Jacks',
                  'imageUrl':
                      'https://i.ytimg.com/vi/cnyTQDSE884/sddefault.jpg',
                  'videoPath': 'assets/videos/plank_jacks.mp4',
                  'reps': '3 sets x 20 reps',
                  'description': 'Plank with jumping feet.'
                },
                {
                  'name': 'Sprints',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2014/10/high-knees-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/sprints.mp4',
                  'reps': '3 sets x 30s',
                  'description': 'Short bursts of running.'
                },
              ],
              'Minimal — bodyweight or light dumbbells',
              'https://hips.hearstapps.com/hmg-prod/images/athletes-doing-push-ups-with-dumbbells-on-floor-royalty-free-image-1638463573.jpg?crop=1xw:0.84375xh;center,top',
            ),
            _buildCategoryCard(
              context,
              'Bodybuilding',
              Icons.whatshot,
              const Color(0xFFFF9FF3),
              'Muscle hypertrophy (size and definition) with split routines.',
              [
                {
                  'name': 'Bicep Curls',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/dumbbell-curl.jpg',
                  'videoPath': 'assets/videos/bicep_curls.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Targets biceps.'
                },
                {
                  'name': 'Tricep Dips / Pushdowns',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/tricep-pushdown.jpg',
                  'videoPath': 'assets/videos/tricep_dips.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Targets triceps.'
                },
                {
                  'name': 'Leg Extensions / Curls',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/leg-extension.jpg',
                  'videoPath': 'assets/videos/leg_extensions.mp4',
                  'reps': '3 sets x 15 reps',
                  'description': 'Isolates quads and hamstrings.'
                },
                {
                  'name': 'Incline Dumbbell Press',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/incline-dumbbell-press.jpg',
                  'videoPath': 'assets/videos/incline_dumbbell_press.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Upper chest focus.'
                },
                {
                  'name': 'Lateral Raises',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/lateral-raise.jpg',
                  'videoPath': 'assets/videos/lateral_raises.mp4',
                  'reps': '3 sets x 15 reps',
                  'description': 'Shoulder sides.'
                },
                {
                  'name': 'Cable Flys',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/cable-fly.jpg',
                  'videoPath': 'assets/videos/cable_flys.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Chest isolation.'
                },
                {
                  'name': 'Seated Rows',
                  'imageUrl':
                      'https://training.fit/wp-content/uploads/2020/02/rudern-kabelzug.png',
                  'videoPath': 'assets/videos/seated_rows.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Back exercise.'
                },
                {
                  'name': 'Ab Crunch Machine',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/ab-crunch-machine.jpg',
                  'videoPath': 'assets/videos/ab_crunch.mp4',
                  'reps': '3 sets x 15 reps',
                  'description': 'Core work.'
                },
              ],
              'Dumbbells, Barbells, Isolation Machines',
              'https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2017/12/Professional-Physique-Bodybuilder-Lawrence-Ballanger-Posing-And-Working-Out.jpg?quality=86&strip=all',
            ),
            _buildCategoryCard(
              context,
              'Functional Fitness',
              Icons.build,
              const Color(0xFF54A0FF),
              'Movements that mimic everyday actions, improving mobility and stability.',
              [
                {
                  'name': 'Kettlebell Swings',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/kettlebell-swing.jpg',
                  'videoPath': 'assets/videos/kettlebell_swings.mp4',
                  'reps': '3 sets x 15 reps',
                  'description': 'Hip hinge movement.'
                },
                {
                  'name': 'Medicine Ball Slams',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/medicine-ball-slam.jpg',
                  'videoPath': 'assets/videos/medicine_ball_slams.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Full body power.'
                },
                {
                  'name': 'Battle Ropes',
                  'imageUrl':
                      'https://media.istockphoto.com/id/1149242178/photo/fitness-woman-squatting-with-kettle-bell.jpg?s=612x612&w=0&k=20&c=h_st67wn8-yWYgkrVoPDFjR-Gerjth9NK-_2jI8rHxI=',
                  'videoPath': 'assets/videos/battle_ropes.mp4',
                  'reps': '3 sets x 30s',
                  'description': 'Upper body cardio.'
                },
                {
                  'name': 'TRX Rows',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/trx-row.jpg',
                  'videoPath': 'assets/videos/trx_rows.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Back strength.'
                },
                {
                  'name': 'Farmer’s Carry',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/farmers-carry.jpg',
                  'videoPath': 'assets/videos/farmers_carry.mp4',
                  'reps': '3 sets x 30m',
                  'description': 'Grip and core.'
                },
                {
                  'name': 'Step-Ups',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/step-up.jpg',
                  'videoPath': 'assets/videos/step_ups.mp4',
                  'reps': '3 sets x 10 per leg',
                  'description': 'Leg strength.'
                },
                {
                  'name': 'Sled Push/Pull',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/sled-push.jpg',
                  'videoPath': 'assets/videos/sled_push.mp4',
                  'reps': '3 sets x 20m',
                  'description': 'Full body power.'
                },
                {
                  'name': 'Box Jumps',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/box-jump.jpg',
                  'videoPath': 'assets/videos/box_jumps.mp4',
                  'reps': '3 sets x 8 reps',
                  'description': 'Explosive jumps.'
                },
              ],
              'Kettlebells, TRX, Medicine Balls, Resistance Bands',
              'https://media.istockphoto.com/id/1149242178/photo/fitness-woman-squatting-with-kettle-bell.jpg?s=612x612&w=0&k=20&c=h_st67wn8-yWYgkrVoPDFjR-Gerjth9NK-_2jI8rHxI=',
            ),
            _buildCategoryCard(
              context,
              'Weight Loss',
              Icons.trending_down,
              const Color(0xFF5F27CD),
              'Fat burning through a mix of cardio, HIIT, and light resistance.',
              [
                {
                  'name': 'Treadmill Intervals',
                  'imageUrl':
                      'https://www.shutterstock.com/shutterstock/videos/1017638224/thumb/1.jpg',
                  'videoPath': 'assets/videos/treadmill.mp4',
                  'reps': '20 min',
                  'description': 'Alternating speed.'
                },
                {
                  'name': 'Jump Rope',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2014/10/jump-rope-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/jumpping_rope.mp4',
                  'reps': '10 min',
                  'description': 'High calorie burn.'
                },
                {
                  'name': 'Bodyweight Circuits',
                  'imageUrl':
                      'https://i.ytimg.com/vi/auBLPXO8Fww/maxresdefault.jpg',
                  'videoPath': 'assets/videos/bodyweight_circuits.mp4',
                  'reps': '3 rounds',
                  'description': 'Mix of bodyweight exercises.'
                },
                {
                  'name': 'Rowing Machine',
                  'imageUrl':
                      'https://i.ytimg.com/vi/H0r_ZPXJLtg/maxresdefault.jpg',
                  'videoPath': 'assets/videos/rowing_machine.mp4',
                  'reps': '30 min',
                  'description': 'Full body cardio.'
                },
                {
                  'name': 'Jumping Jacks',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2014/10/jumping-jacks-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/jumping_jacks.mp4',
                  'reps': '3 sets x 30s',
                  'description': 'Simple cardio.'
                },
                {
                  'name': 'Squat to Press',
                  'imageUrl':
                      'https://spotebi.com/wp-content/uploads/2015/08/jump-squat-exercise-illustration.jpg',
                  'videoPath': 'assets/videos/squat_to_press.mp4',
                  'reps': '3 sets x 12 reps',
                  'description': 'Full body move.'
                },
                {
                  'name': 'Burpees',
                  'imageUrl':
                      'https://i.ytimg.com/vi/auBLPXO8Fww/maxresdefault.jpg',
                  'videoPath': 'assets/videos/burpees.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'High intensity.'
                },
                {
                  'name': 'Cycling Intervals',
                  'imageUrl':
                      'https://i.ytimg.com/vi/udhRFATkN44/maxresdefault.jpg',
                  'videoPath': 'assets/videos/cycling_intervals.mp4',
                  'reps': '20 min',
                  'description': 'Alternating intensity.'
                },
              ],
              'Bodyweight, Cardio Machines, Light Dumbbells',
              'https://media1.popsugar-assets.com/files/thumbor/TOR0jDvHpQdInTp91t5ygMvwnXY=/0x0:3944x2694/fit-in/792x541/top/filters:format_auto():upscale()/2023/08/15/970/n/1922729/0f92346364dbf9770c4d89.94072438_.jpg',
            ),
            _buildCategoryCard(
              context,
              'Muscle Gain',
              Icons.trending_up,
              const Color(0xFF00D2D3),
              'Progressive overload with compound lifts and protein-rich recovery.',
              [
                {
                  'name': 'Deadlifts',
                  'imageUrl':
                      'https://i.ytimg.com/vi/1ZXobu7JvvE/maxresdefault.jpg',
                  'videoPath': 'assets/videos/deadlifts.mp4',
                  'reps': '3 sets x 8 reps',
                  'description': 'Compound back exercise.'
                },
                {
                  'name': 'Squats',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/barbell-back-squat.jpg',
                  'videoPath': 'assets/videos/squats.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Leg builder.'
                },
                {
                  'name': 'Bench Press',
                  'imageUrl':
                      'https://i.ytimg.com/vi/SCVCLChPQFY/maxresdefault.jpg',
                  'videoPath': 'assets/videos/bench_press.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Chest development.'
                },
                {
                  'name': 'Barbell Rows',
                  'imageUrl':
                      'https://training.fit/wp-content/uploads/2020/02/rudern-kabelzug.png',
                  'videoPath': 'assets/videos/barbell_rows.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Back thickness.'
                },
                {
                  'name': 'Shoulder Press',
                  'imageUrl':
                      'https://i.ytimg.com/vi/5yWaNOvgFCM/maxresdefault.jpg',
                  'videoPath': 'assets/videos/shoulder_press.mp4',
                  'reps': '3 sets x 10 reps',
                  'description': 'Shoulder mass.'
                },
                {
                  'name': 'Pull-Ups',
                  'imageUrl':
                      'https://i.ytimg.com/vi/aAggnpPyR6E/maxresdefault.jpg',
                  'videoPath': 'assets/videos/pull_ups.mp4',
                  'reps': '3 sets x 8 reps',
                  'description': 'Upper back.'
                },
                {
                  'name': 'Bulgarian Split Squats',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/bulgarian-split-squat.jpg',
                  'videoPath': 'assets/videos/bulgarian_split_squats.mp4',
                  'reps': '3 sets x 10 per leg',
                  'description': 'Leg isolation.'
                },
                {
                  'name': 'Weighted Dips',
                  'imageUrl':
                      'https://cdn.muscleandstrength.com/sites/default/files/weighted-dip.jpg',
                  'videoPath': 'assets/videos/weighted_dips.mp4',
                  'reps': '3 sets x 8 reps',
                  'description': 'Chest and triceps.'
                },
              ],
              'Barbells, Dumbbells, Cables',
              'http://ironbullstrength.com/cdn/shop/articles/Best_Workout_Plan_for_Gaining_Muscle.webp?v=1704212230',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String focus,
    List<Map<String, String>> workouts,
    String equipment,
    String imageUrl,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailScreen(
                title: title,
                focus: focus,
                workouts: workouts,
                equipment: equipment,
                color: color,
                imageUrl: imageUrl,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.3)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String title;
  final String focus;
  final List<Map<String, String>> workouts;
  final String equipment;
  final Color color;
  final String imageUrl;

  const CategoryDetailScreen({
    super.key,
    required this.title,
    required this.focus,
    required this.workouts,
    required this.equipment,
    required this.color,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color(0xFF40C4FF)], // Green to Light Blue
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Focus:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              focus,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Common Workouts:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(workouts[index]['imageUrl']!),
                    ),
                    title: Text(
                      workouts[index]['name']!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    subtitle: Text(workouts[index]['reps']!),
                    onTap: () {
                      SelectedExercises.selected.add(workouts[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Added ${workouts[index]['name']} to your workout plan'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Equipment:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: equipment
                  .split(',')
                  .map((e) => Chip(
                        label: Text(e.trim()),
                        backgroundColor: color.withValues(alpha: 0.2),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
