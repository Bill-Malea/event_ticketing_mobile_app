import 'package:event_ticketing_mobile_app/models/ticket_model.dart';
import 'package:event_ticketing_mobile_app/screens/ticket_receipt_page.dart';
import 'package:flutter/material.dart';

class BuyTicketPage extends StatefulWidget {
  const BuyTicketPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuyTicketPageState createState() => _BuyTicketPageState();
}

class _BuyTicketPageState extends State<BuyTicketPage> {
  int selectedFanZone = 0;

  bool checkAvailability(int fanZone) {
    return true;
  }

  void buyTicket() {
    int price = fetchPricing(selectedFanZone);

    // Show bottom dialog box
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected Fan Zone: FanZone $selectedFanZone',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('Price: \$${price.toString()}'),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Proceed with ticket purchase
                      // Redirect to next page
                      Navigator.pop(context); // Close the bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketReceiptPage(
                                  ticket: TicketModel(
                                      description: "",
                                      time: "",
                                      title: "",
                                      price: "",
                                      imageUrl: "",
                                      section: "",
                                      orderNumber: "",
                                      venue: "",
                                      date: ""),
                                )),
                      );
                    },
                    child: const Text('Buy'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int fetchPricing(int fanZone) {
    return 50; // Example pricing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Section'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AvailabilityIndicator(
                  color: Color.fromARGB(255, 26, 194, 236),
                  status: 'Available'),
              AvailabilityIndicator(color: Colors.black87, status: 'Sold Out'),
              AvailabilityIndicator(
                  color: Color.fromARGB(255, 127, 250, 131),
                  status: 'Selected'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.height * .5,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Center Stage ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFanZone = 3;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selectedFanZone == 3
                              ? const Color.fromARGB(255, 127, 250, 131)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'FanZone #3',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFanZone = 1;
                            });
                          },
                          child: Container(
                            height: 70,
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: selectedFanZone == 1
                                    ? const Color.fromARGB(255, 127, 250, 131)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: selectedFanZone == 1
                                    ? null
                                    : Border.all(width: 1)),
                            child: const Center(
                              child: Text(
                                'FanZone #1',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFanZone = 2;
                            });
                          },
                          child: Container(
                            height: 70,
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: selectedFanZone == 2
                                    ? const Color.fromARGB(255, 127, 250, 131)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: selectedFanZone == 2
                                    ? null
                                    : Border.all(width: 1)),
                            child: const Center(
                              child: Text(
                                'FanZone #2',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFanZone = 4;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selectedFanZone == 4
                              ? const Color.fromARGB(255, 127, 250, 131)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'FanZone #4',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Check availability and proceed
                    if (selectedFanZone != 0 &&
                        checkAvailability(selectedFanZone)) {
                      // Proceed with ticket purchase
                      print('Ticket purchased for FanZone $selectedFanZone');
                    } else {
                      // Show error message or handle accordingly
                      print('FanZone not selected or unavailable');
                    }
                  },
                  child: const Text('Buy Ticket'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AvailabilityIndicator extends StatelessWidget {
  final Color color;
  final String status;

  const AvailabilityIndicator(
      {super.key, required this.color, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 4),
        Text(status),
      ],
    );
  }
}
