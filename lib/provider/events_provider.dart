import 'dart:convert';
import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/utilities/endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _recommended = [];
  List<EventModel> _upcoming = [];

  List<EventModel> get events => [..._events];
  List<EventModel> get upcoming => [..._upcoming];

  List<EventModel> get recommended => [..._recommended];
  fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$firebaseUrl/events.json'));

      if (response.statusCode == 200) {
        final List<EventModel> events = [];
        final Map<String, dynamic> eventData = jsonDecode(response.body);

        eventData.forEach((key, value) {
          final event = EventModel.fromJson({...value, 'id': key});
          events.add(event);
        });

        _events = events;

        _upcoming = events.where((event) => event.upcoming).toList();

        _recommended = events.where((event) => event.recommended).toList();

        notifyListeners();
      } else {}
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  Future<List<EventModel>> fetchRecommendedEvents() async {
    final List<EventModel> events = await fetchEvents();
    return events.where((event) => event.recommended).toList();
  }

  Future<List<EventModel>> fetchUpcomingEvents() async {
    final List<EventModel> events = await fetchEvents();
    return events.where((event) => event.upcoming).toList();
  }
}
