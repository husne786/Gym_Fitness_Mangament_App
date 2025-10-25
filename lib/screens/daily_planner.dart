import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(const DailyPlanner());

class Event {
  String title;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String type;
  bool hasReminder;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.hasReminder,
  });

  IconData get icon {
    switch (type) {
      case 'Workout':
        return Icons.fitness_center;
      case 'Nutrition':
        return Icons.restaurant_menu;
      case 'Yoga':
        return Icons.local_florist;
      default:
        return Icons.event;
    }
  }

  Color get color {
    switch (type) {
      case 'Workout':
      case 'Yoga':
        return const Color(0xFF6A1B9A);
      case 'Nutrition':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get time {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
}

class DailyPlanner extends StatefulWidget {
  const DailyPlanner({super.key});

  @override
  DailyPlannerState createState() => DailyPlannerState();
}

class DailyPlannerState extends State<DailyPlanner> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    // Add sample events for today
    DateTime today = DateTime.now();
    DateTime sampleDay = DateTime(today.year, today.month, today.day);
    _events[sampleDay] = [
      Event(
        title: 'Full Body Workout',
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 8, minute: 0),
        type: 'Workout',
        hasReminder: true,
      ),
      Event(
        title: 'Nutrition Consultation',
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
        type: 'Nutrition',
        hasReminder: false,
      ),
      Event(
        title: 'Yoga Session',
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 19, minute: 0),
        type: 'Yoga',
        hasReminder: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar & Planner'),
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
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                return _events[DateTime(day.year, day.month, day.day)] ?? [];
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF6A1B9A),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _selectedDay == null
                  ? const Center(child: Text('Select a date to view events'))
                  : _buildEventsList(_selectedDay!),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_selectedDay == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select a day first')),
              );
              return;
            }
            _addEvent(_selectedDay!);
          },
          backgroundColor: const Color(0xFF6A1B9A),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEventsList(DateTime day) {
    DateTime key = DateTime(day.year, day.month, day.day);
    List<Event>? events = _events[key];
    if (events == null || events.isEmpty) {
      return const Center(child: Text('No events for this day'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        Event event = events[index];
        return _buildEventCard(event, day, index);
      },
    );
  }

  Widget _buildEventCard(Event event, DateTime day, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(event.icon, color: event.color),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.time),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_active,
              size: 20,
              color: event.hasReminder ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _showEventDetails(event, day, index),
      ),
    );
  }

  void _showEventDetails(Event event, DateTime day, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${event.time}'),
            Text('Type: ${event.type}'),
            Text('Reminder: ${event.hasReminder ? 'Yes' : 'No'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editEvent(event, day, index);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(day, index);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(
      BuildContext context, TimeOfDay? initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
  }

  void _addEvent(DateTime day) {
    String title = '';
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String type = 'Workout';
    bool hasReminder = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (val) => title = val,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        startTime != null
                            ? 'Start: ${_formatTime(startTime!)}'
                            : 'Select Start Time',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedTime =
                            await _selectTime(context, startTime);
                        if (selectedTime != null) {
                          setDialogState(() {
                            startTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('Pick Start'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        endTime != null
                            ? 'End: ${_formatTime(endTime!)}'
                            : 'Select End Time',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedTime =
                            await _selectTime(context, endTime);
                        if (selectedTime != null) {
                          setDialogState(() {
                            endTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('Pick End'),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: type,
                  items: ['Workout', 'Nutrition', 'Yoga']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      type = val!;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Set Reminder'),
                  value: hasReminder,
                  onChanged: (val) {
                    setDialogState(() {
                      hasReminder = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty && startTime != null && endTime != null) {
                DateTime key = DateTime(day.year, day.month, day.day);
                _events.update(
                  key,
                  (list) => list
                    ..add(
                      Event(
                        title: title,
                        startTime: startTime!,
                        endTime: endTime!,
                        type: type,
                        hasReminder: hasReminder,
                      ),
                    ),
                  ifAbsent: () => [
                    Event(
                      title: title,
                      startTime: startTime!,
                      endTime: endTime!,
                      type: type,
                      hasReminder: hasReminder,
                    ),
                  ],
                );
                setState(() {});
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editEvent(Event oldEvent, DateTime day, int index) {
    String title = oldEvent.title;
    TimeOfDay startTime = oldEvent.startTime;
    TimeOfDay endTime = oldEvent.endTime;
    String type = oldEvent.type;
    bool hasReminder = oldEvent.hasReminder;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: TextEditingController(text: title),
                  onChanged: (val) => title = val,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Start: ${_formatTime(startTime)}'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedTime =
                            await _selectTime(context, startTime);
                        if (selectedTime != null) {
                          setDialogState(() {
                            startTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('Pick Start'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('End: ${_formatTime(endTime)}'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedTime =
                            await _selectTime(context, endTime);
                        if (selectedTime != null) {
                          setDialogState(() {
                            endTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('Pick End'),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: type,
                  items: ['Workout', 'Nutrition', 'Yoga']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      type = val!;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Set Reminder'),
                  value: hasReminder,
                  onChanged: (val) {
                    setDialogState(() {
                      hasReminder = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty) {
                DateTime key = DateTime(day.year, day.month, day.day);
                if (_events.containsKey(key)) {
                  _events[key]![index] = Event(
                    title: title,
                    startTime: startTime,
                    endTime: endTime,
                    type: type,
                    hasReminder: hasReminder,
                  );
                  setState(() {});
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(DateTime day, int index) {
    DateTime key = DateTime(day.year, day.month, day.day);
    if (_events.containsKey(key)) {
      _events[key]!.removeAt(index);
      if (_events[key]!.isEmpty) {
        _events.remove(key);
      }
      setState(() {});
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
