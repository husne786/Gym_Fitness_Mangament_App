import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class WorkoutHistory {
  static List<Map<String, dynamic>> history = [];
  static void addWorkout(String name, String date, String status, int duration,
      String imageUrl, List<Map<String, dynamic>> exercises) {
    history.add({
      'name': name,
      'date': date,
      'status': status,
      'duration': duration,
      'imageUrl': imageUrl,
      'exercises': exercises,
    });
  }
}

class SelectedExercises {
  static List<Map<String, dynamic>> selected = [];
  static void addExercise(String name, String reps, double weight) {
    selected.add({
      'name': name,
      'reps': reps,
      'weight': weight,
    });
  }
}

class Goal {
  static int weeklyGoal = 5; // Default weekly goal: 5 workouts
  static void setWeeklyGoal(int goal) {
    weeklyGoal = goal;
  }
}

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  ProgressTrackerState createState() => ProgressTrackerState();
}

class ProgressTrackerState extends State<ProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final StreamController<Map<String, dynamic>> _workoutStreamController =
      StreamController.broadcast();
  bool _isTracking = false;
  Timer? _trackingTimer;
  int _currentReps = 0;
  int _currentExerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/workout_history.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        setState(() {
          WorkoutHistory.history =
              jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load history: $e')),
      );
    }
  }

  Future<void> _saveHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/workout_history.json');
      await file.writeAsString(json.encode(WorkoutHistory.history));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save history: $e')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _workoutStreamController.close();
    _trackingTimer?.cancel();
    super.dispose();
  }

  void _startTracking() {
    if (SelectedExercises.selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises selected to track')),
      );
      return;
    }
    setState(() {
      _isTracking = true;
      _currentReps = 0;
      _currentExerciseIndex = 0;
    });
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentExerciseIndex < SelectedExercises.selected.length) {
        final exercise = SelectedExercises.selected[_currentExerciseIndex];
        final targetReps = _parseReps(exercise['reps'] as String);
        if (_currentReps < targetReps) {
          _currentReps++;
          _workoutStreamController.add({
            'exercise': exercise['name'],
            'reps': _currentReps,
            'targetReps': targetReps,
            'index': _currentExerciseIndex,
          });
        } else {
          _currentReps = 0;
          _currentExerciseIndex++;
          if (_currentExerciseIndex < SelectedExercises.selected.length) {
            _workoutStreamController.add({
              'exercise': SelectedExercises.selected[_currentExerciseIndex]
                  ['name'],
              'reps': _currentReps,
              'targetReps': _parseReps(SelectedExercises
                  .selected[_currentExerciseIndex]['reps'] as String),
              'index': _currentExerciseIndex,
            });
          } else {
            _stopTracking();
            WorkoutHistory.addWorkout(
              'Workout Session',
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'Completed',
              SelectedExercises.selected.length * 3,
              'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
              SelectedExercises.selected,
            );
            _saveHistory();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workout completed and saved!')),
            );
          }
        }
      }
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
      _currentReps = 0;
      _currentExerciseIndex = 0;
    });
    _trackingTimer?.cancel();
    _workoutStreamController.add({
      'exercise': '',
      'reps': 0,
      'targetReps': 0,
      'index': 0,
    });
  }

  int _parseReps(String reps) {
    if (reps.contains('reps')) {
      return int.parse(reps.split('x').last.trim().split(' ').first);
    } else if (reps.contains('min') || reps.contains('s')) {
      return 30;
    } else {
      return 10;
    }
  }

  int _calculateWorkoutStreak() {
    if (WorkoutHistory.history.isEmpty) return 0;
    List<Map<String, dynamic>> completedWorkouts = WorkoutHistory.history
        .where((h) => h['status'] == 'Completed')
        .toList();
    if (completedWorkouts.isEmpty) return 0;

    completedWorkouts.sort((a, b) =>
        DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    int streak = 1;
    DateTime previousDate = DateTime.parse(completedWorkouts[0]['date']);
    for (int i = 1; i < completedWorkouts.length; i++) {
      DateTime currentDate = DateTime.parse(completedWorkouts[i]['date']);
      int differenceInDays = previousDate.difference(currentDate).inDays;
      if (differenceInDays == 1) {
        streak++;
        previousDate = currentDate;
      } else if (differenceInDays > 1) {
        break;
      }
    }
    return streak;
  }

  int _calculateWeeklyProgress() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int weeklyCompleted = WorkoutHistory.history.where((h) {
      DateTime date = DateTime.parse(h['date']);
      return date.isAfter(startOfWeek) && h['status'] == 'Completed';
    }).length;
    return weeklyCompleted;
  }

  Map<String, dynamic> _getDailyProgress() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);
    var todayWorkouts =
        WorkoutHistory.history.where((h) => h['date'] == todayStr).toList();
    int completedExercises = 0;
    int totalExercises = SelectedExercises.selected.length;
    if (todayWorkouts.isNotEmpty) {
      completedExercises = todayWorkouts.fold(
          0, (sum, workout) => sum + (workout['exercises'] as List).length);
    }
    return {
      'completed': completedExercises,
      'total': totalExercises,
      'percentage': totalExercises > 0
          ? (completedExercises / totalExercises * 100).toInt()
          : 0,
    };
  }

  String _generateShareMessage() {
    final completedWorkouts =
        WorkoutHistory.history.where((h) => h['status'] == 'Completed').length;
    final totalSets = SelectedExercises.selected.length * 3;
    final totalReps = SelectedExercises.selected.fold<int>(0, (sum, ex) {
      final repsStr = ex['reps'] as String;
      return sum +
          (repsStr.contains('reps')
              ? int.parse(repsStr.split('x').last.trim().split(' ').first) * 3
              : 30);
    });
    final streak = _calculateWorkoutStreak();
    return '''
I just crushed my fitness goals! 💪

• Completed: $completedWorkouts workouts
• Total Sets: $totalSets
• Total Reps: $totalReps
• Current Streak: $streak days 🔥

Join me on my journey with Gym & Fitness app! #GymLife #FitnessProgress
''';
  }

  void _shareProgress() {
    const imagePath =
        'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg';
    final message = _generateShareMessage();
    Share.shareXFiles([XFile(imagePath)], text: message);
  }

  void _setGoal() {
    showDialog(
      context: context,
      builder: (context) {
        int newGoal = Goal.weeklyGoal;
        return AlertDialog(
          title: const Text('Set Weekly Goal'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (val) {
              newGoal = int.tryParse(val) ?? Goal.weeklyGoal;
            },
            decoration:
                const InputDecoration(hintText: 'Enter number of workouts'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Goal.setWeeklyGoal(newGoal);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _generateWeeklyTrendSpots() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, int> dailyCounts = {};
    for (int i = 0; i < 7; i++) {
      String dateStr =
          DateFormat('yyyy-MM-dd').format(startOfWeek.add(Duration(days: i)));
      dailyCounts[dateStr] = 0;
    }
    for (var workout in WorkoutHistory.history) {
      if (workout['status'] == 'Completed') {
        String date = workout['date'];
        if (dailyCounts.containsKey(date)) {
          dailyCounts[date] = dailyCounts[date]! + 1;
        }
      }
    }
    return dailyCounts.entries.toList().asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completedWorkouts =
        WorkoutHistory.history.where((h) => h['status'] == 'Completed').length;
    final totalSets = SelectedExercises.selected.length * 3;
    final totalReps = SelectedExercises.selected.fold<int>(0, (sum, ex) {
      final repsStr = ex['reps'] as String;
      return sum +
          (repsStr.contains('reps')
              ? int.parse(repsStr.split('x').last.trim().split(' ').first) * 3
              : 30);
    });
    final dailyProgress = _getDailyProgress();
    final weeklyProgress = _calculateWeeklyProgress();
    final weeklyGoal = Goal.weeklyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color(0xFF40C4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fitness_center, size: 50),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6A1B9A).withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Your Fitness Journey',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _calculateWorkoutStreak() > 0
                  ? '🔥 ${_calculateWorkoutStreak()}-Day Streak!'
                  : 'Start a workout to build your streak!',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF6A1B9A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Real-Time Workout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    StreamBuilder<Map<String, dynamic>>(
                      stream: _workoutStreamController.stream,
                      initialData: {
                        'exercise': '',
                        'reps': 0,
                        'targetReps': 0,
                        'index': 0,
                      },
                      builder: (context, snapshot) {
                        final data = snapshot.data!;
                        if (!_isTracking || data['exercise'].isEmpty) {
                          return const Text(
                            'Start a workout to track progress live!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              'Current: ${data['exercise']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Reps: ${data['reps']} / ${data['targetReps']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: data['reps'] / data['targetReps'],
                              backgroundColor: Colors.grey[300],
                              color: const Color(0xFF6A1B9A),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isTracking ? _stopTracking : _startTracking,
                      icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(
                          _isTracking ? 'Stop Tracking' : 'Start Tracking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isTracking ? Colors.red : const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Daily Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: dailyProgress['percentage'] / 100,
                            backgroundColor: Colors.grey[300],
                            color: const Color(0xFF6A1B9A),
                            strokeWidth: 10,
                          ),
                        ),
                        Text(
                          '${dailyProgress['percentage']}%',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Today\'s Exercises: ${dailyProgress['completed']}/${dailyProgress['total']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Exercises:'),
                    ...SelectedExercises.selected.map((ex) => ListTile(
                          title: Text(ex['name'] as String),
                          subtitle: Text(
                              'Reps: ${ex['reps']} - Weight: ${ex['weight']} kg'),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Workouts this week: $weeklyProgress / $weeklyGoal',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: weeklyProgress / weeklyGoal.toDouble(),
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF6A1B9A),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '${(weeklyProgress / weeklyGoal * 100).toInt()}% Completed'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _setGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Set Weekly Goal'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Overall Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6A1B9A).withValues(alpha: 0.1),
                      const Color(0xFF6A1B9A).withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetric(
                        'Workouts',
                        '$completedWorkouts',
                        completedWorkouts > 0 ? '+$completedWorkouts' : '0',
                        const Color(0xFF4ECDC4)),
                    _buildMetric(
                        'Sets',
                        '$totalSets',
                        totalSets > 0 ? '+$totalSets' : '0',
                        const Color(0xFFF9CA24)),
                    _buildMetric(
                        'Reps',
                        '$totalReps',
                        totalReps > 0 ? '+$totalReps' : '0',
                        const Color(0xFFFF6B6B)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Workout Trends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            return Text(
                              days[value.toInt() % 7],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateWeeklyTrendSpots(),
                        isCurved: true,
                        color: const Color(0xFF6A1B9A),
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF6A1B9A).withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                    minY: 0,
                    maxY: (_generateWeeklyTrendSpots().isNotEmpty
                            ? _generateWeeklyTrendSpots()
                                .map((spot) => spot.y)
                                .reduce((a, b) => a > b ? a : b)
                            : 1) +
                        1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Workout History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            WorkoutHistory.history.isEmpty
                ? const Text(
                    'No workout history yet. Complete a workout to see your progress!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: WorkoutHistory.history.length,
                    itemBuilder: (context, index) {
                      final history = WorkoutHistory.history[index];
                      return ExpansionTile(
                        title: Text(history['name'] as String),
                        subtitle: Text(
                            '${history['date']} • ${history['duration']} min • ${history['status']}'),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(history['imageUrl'] as String),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.fitness_center),
                        ),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Exercises:'),
                          ),
                          ...(history['exercises']
                                  as List<Map<String, dynamic>>)
                              .map((ex) => ListTile(
                                    title: Text(ex['name'] as String),
                                    subtitle: Text(
                                        'Reps: ${ex['reps']} - Weight: ${ex['weight']} kg'),
                                  )),
                        ],
                      );
                    },
                  ),
            const SizedBox(height: 24),
            const Text(
              'Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildAchievement('10 Workouts', completedWorkouts >= 10),
                const SizedBox(width: 16),
                _buildAchievement(
                    '5-Day Streak', _calculateWorkoutStreak() >= 5),
                const SizedBox(width: 16),
                _buildAchievement(
                    'Weekly Goal Met', weeklyProgress >= weeklyGoal),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  WorkoutHistory.history.clear();
                  _saveHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progress cleared')),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Clear Progress',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _shareProgress,
              icon: const Icon(Icons.share, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              label: const Text(
                'Share My Progress',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, String change, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          change,
          style: TextStyle(
            fontSize: 12,
            color: change.startsWith('+') ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievement(String title, bool achieved) {
    return Expanded(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: achieved
              ? const Color(0xFF6A1B9A).withValues(alpha: 0.1)
              : Colors.grey[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(
                  achieved ? Icons.fitness_center : Icons.star_border,
                  color: achieved ? const Color(0xFF6A1B9A) : Colors.grey,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: achieved ? const Color(0xFF6A1B9A) : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
