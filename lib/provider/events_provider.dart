import 'dart:convert';
import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/utilities/endpoint.dart';
import 'package:http/http.dart' as http;

class EventProvider {
  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$firebaseUrl/events.json'));

      if (response.statusCode == 200) {
        final List<EventModel> events = [];
        final Map<String, dynamic> eventData = jsonDecode(response.body);

        eventData.forEach((key, value) {
          final event = EventModel.fromJson({...value, 'id': key});
          events.add(event);
        });

        return events;
      } else {
        print('Failed to fetch events');
        return [];
      }
    } catch (error) {
      print('Error fetching events: $error');
      return [];
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
