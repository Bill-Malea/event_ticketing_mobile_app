import 'package:event_ticketing_mobile_app/models/ticket_model.dart';
import 'package:flutter/material.dart';

class TicketReceiptPage extends StatelessWidget {
  final TicketModel ticket;
  const TicketReceiptPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please show this ticket at the entrance:',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text('Date: ${ticket.date}'),
            Text('Venue: ${ticket.venue}'),
            Text('Section: $ticket.section}'),
            Text('Cost: \$${ticket.price}'),
            Text('Order Number: ${ticket.orderNumber}'),
            const SizedBox(height: 16),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  'Barcode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
