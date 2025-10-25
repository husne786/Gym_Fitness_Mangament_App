import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/daily_planner.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<Event>> sampleEvents = {
      DateTime.now(): [
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
      ],
    };

    // Filter events with active reminders
    final reminderEvents = sampleEvents.entries
        .expand((entry) => entry.value
            .asMap()
            .entries
            .map((e) => {'date': entry.key, 'event': e.value, 'index': e.key}))
        .where((e) =>
            (e['event'] as Event).hasReminder) // Cast to Event for null safety
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: reminderEvents.isEmpty
            ? const Center(
                child: Text(
                  'No active reminders',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: reminderEvents.length,
                itemBuilder: (context, index) {
                  final eventData = reminderEvents[index];
                  final Event event =
                      eventData['event'] as Event; // Cast to Event
                  final DateTime date =
                      eventData['date'] as DateTime; // Cast to DateTime
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(event.icon, color: event.color),
                      title: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${event.time} • ${date.day}/${date.month}/${date.year}',
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
