import 'dart:convert';
import 'dart:math';
import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/models/ticket_model.dart';
import 'package:event_ticketing_mobile_app/utilities/endpoint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TicketProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkavailability(
      {required EventModel event, required String fanzone}) async {
    try {
      final response = await http.get(
          Uri.parse('$firebaseUrl/events/${event.id}/section/$fanzone.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);

        // If data is not null and contains availability information
        if (data != null && data.containsKey('available')) {
          return data['tickets'] as bool;
        } else {
          // If data is null or does not contain availability information
          return false;
        }
      } else {
        // If HTTP request fails
        print('Failed to check ticket availability');
        return false;
      }
    } catch (error) {
      // If an error occurs
      print('Error checking ticket availability: $error');
      return false;
    }
  }

  Future<void> createTicket(
      {required TicketModel ticket, required String eventId}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return;
      }

      final orderno = generateOrderNumber(user.uid, ticket.section);

      final response = await http.post(
        Uri.parse('$firebaseUrl/tickets/${user.uid}.json'),
        body: jsonEncode({
          'eventName': ticket.title,
          'date': ticket.date,
          'venue': ticket.venue,
          'section': ticket.section,
          'cost': ticket.price,
          'orderNumber': orderno,
          'checkedIn': false,
        }),
      );

      if (response.statusCode == 200) {
        await decrementRemainingTickets(
            eventId: eventId, fanzone: ticket.section);
        print('Ticket created successfully');
      } else {
        print('Failed to create ticket');
      }
    } catch (error) {
      print('Error creating ticket: $error');
    }
  }

  Future<void> decrementRemainingTickets(
      {required String eventId, required String fanzone}) async {
    try {
      //not recommended********since this should be transactional
      final response = await http
          .get(Uri.parse('$firebaseUrl/events/$eventId/section/$fanzone.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if there are available tickets
        if (data.containsKey('tickets')) {
          int remainingTickets = data['tickets'];

          // If there are available tickets, decrement the count

          if (remainingTickets > 0) {
            remainingTickets--;
          }

          await http.patch(
            Uri.parse('$firebaseUrl/events/$eventId/section/$fanzone.json'),
            body: jsonEncode({'available': remainingTickets}),
          );
        }
      } else {
        print('Failed to decrement remaining tickets');
      }
    } catch (error) {
      print('Error decrementing remaining tickets: $error');
    }
  }

  String generateOrderNumber(String userId, String fanZone) {
    // Generate a random number between 1000 and 9999
    final random = Random();
    final randomNumber = 1000 + random.nextInt(9000);

    // Get current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Combine userId, fanZone, timestamp, and randomNumber to generate a unique order number
    final orderNumber = '$userId-$fanZone-$timestamp-$randomNumber';

    return orderNumber;
  }

  Future<List<Map<String, dynamic>>> fetchTickets() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$firebaseUrl/users/${user.uid}/tickets.json'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> ticketsData = jsonDecode(response.body);
        List<Map<String, dynamic>> tickets = [];
        ticketsData.forEach((key, value) {
          tickets.add({...value, 'id': key});
        });
        return tickets;
      } else {
        print('Failed to fetch tickets');
        return [];
      }
    } catch (error) {
      print('Error fetching tickets: $error');
      return [];
    }
  }
}
