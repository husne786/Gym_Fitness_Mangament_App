import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/workout_categories.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class ExercisePlayer extends StatefulWidget {
  const ExercisePlayer({super.key});

  @override
  ExercisePlayerState createState() => ExercisePlayerState();
}

class ExercisePlayerState extends State<ExercisePlayer>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _reps = 0;
  Timer? _timer;
  bool _isResting = false;
  int _restTime = 60;
  Timer? _restTimer;
  late AnimationController _completionAnimationController;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _completionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (SelectedExercises.selected.isNotEmpty) {
      final videoUrl =
          SelectedExercises.selected[_currentExerciseIndex]['videoUrl'] ?? '';
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
            if (_isPlaying) {
              _videoController.play();
              _videoController.setLooping(true);
            }
          });
        }).catchError((error) {
          setState(() {
            _isVideoInitialized = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load video: $error')),
          );
        });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    _completionAnimationController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startTimer();
      if (_isVideoInitialized) {
        _videoController.play();
      }
    } else {
      _timer?.cancel();
      if (_isVideoInitialized) {
        _videoController.pause();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        int targetReps = _parseReps(
            SelectedExercises.selected[_currentExerciseIndex]['reps']!);
        if (_reps < targetReps) _reps++;
      });
    });
  }

  void _startRestTimer() {
    setState(() {
      _isResting = true;
      _restTime = 60;
      if (_isVideoInitialized) {
        _videoController.pause();
      }
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_restTime > 0) {
          _restTime--;
        } else {
          _restTimer?.cancel();
          _isResting = false;
          if (_isPlaying && _isVideoInitialized) {
            _videoController.play();
          }
        }
      });
    });
  }

  void _nextSet() {
    setState(() {
      _currentSet++;
      _reps = 0;
      _isPlaying = false;
      _timer?.cancel();
      _startRestTimer();
    });
  }

  void _nextExercise() {
    setState(() {
      if (_currentExerciseIndex < SelectedExercises.selected.length - 1) {
        _currentExerciseIndex++;
        _currentSet = 1;
        _reps = 0;
        _isPlaying = false;
        _timer?.cancel();
        _videoController.dispose();
        _isVideoInitialized = false;
        _initializeVideoPlayer();
        _startRestTimer();
      } else {
        _timer?.cancel();
        _restTimer?.cancel();
        if (_isVideoInitialized) {
          _videoController.pause();
        }
        WorkoutHistory.addWorkout(
          'Workout Session',
          SelectedExercises.selected.length * 3 * 2,
          'Completed',
        );
        _completionAnimationController.forward().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workout Completed!')),
          );
          Navigator.pop(context);
        });
      }
    });
  }

  void _previousExercise() {
    setState(() {
      if (_currentExerciseIndex > 0) {
        _currentExerciseIndex--;
        _currentSet = 1;
        _reps = 0;
        _isPlaying = false;
        _timer?.cancel();
        _videoController.dispose();
        _isVideoInitialized = false;
        _initializeVideoPlayer();
      }
    });
  }

  void _completeSet() {
    if (_currentSet < 3) {
      _nextSet();
    } else {
      _nextExercise();
    }
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

  @override
  Widget build(BuildContext context) {
    if (SelectedExercises.selected.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Player'),
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
        body: const Center(
          child: Text(
            'No exercises selected. Please select exercises from Workout Categories.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final currentExercise = SelectedExercises.selected[_currentExerciseIndex];
    final exerciseName = currentExercise['name']!;
    final exerciseReps = currentExercise['reps']!;
    final exerciseImage = currentExercise['imageUrl']!;
    final targetReps = _parseReps(exerciseReps);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(exerciseName),
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: LinearProgressIndicator(
                value: (_currentExerciseIndex + (_currentSet - 1) / 3) /
                    SelectedExercises.selected.length,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF6A1B9A)),
                minHeight: 8,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _isVideoInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        )
                      : Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(exerciseImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Exercise ${_currentExerciseIndex + 1} of ${SelectedExercises.selected.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          if (_isResting)
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: _restTime / 60,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF6A1B9A)),
                                ),
                                Text(
                                  '$_restTime s',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            Text(
                              'Set $_currentSet of 3',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Reps: $_reps / $targetReps',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: 'prev_exercise',
                                onPressed: _currentExerciseIndex > 0
                                    ? _previousExercise
                                    : null,
                                mini: true,
                                backgroundColor: _currentExerciseIndex > 0
                                    ? const Color(0xFF6A1B9A)
                                    : Colors.grey,
                                child: const Icon(Icons.skip_previous),
                              ),
                              FloatingActionButton(
                                heroTag: 'play',
                                onPressed: _isResting ? null : _togglePlay,
                                backgroundColor: _isPlaying
                                    ? Colors.red
                                    : const Color(0xFF6A1B9A),
                                mini: true,
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                              ),
                              FloatingActionButton(
                                heroTag: 'next_exercise',
                                onPressed: _currentExerciseIndex <
                                        SelectedExercises.selected.length - 1
                                    ? _nextExercise
                                    : null,
                                mini: true,
                                backgroundColor: _currentExerciseIndex <
                                        SelectedExercises.selected.length - 1
                                    ? const Color(0xFF6A1B9A)
                                    : Colors.grey,
                                child: const Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_currentExerciseIndex ==
                          SelectedExercises.selected.length - 1 &&
                      _currentSet == 3)
                    FadeTransition(
                      opacity: _completionAnimationController,
                      child: Container(
                        color: const Color(0xFF6A1B9A).withValues(alpha: 0.8),
                        child: const Center(
                          child: Text(
                            'Workout Complete!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isResting ? null : _startRestTimer,
                      icon: const Icon(Icons.timer),
                      label: const Text('Rest 60s'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isResting ? null : _completeSet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Complete Set',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
