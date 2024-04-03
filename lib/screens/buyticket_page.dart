import 'dart:async';

import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/models/ticket_model.dart';
import 'package:event_ticketing_mobile_app/provider/auth.dart';
import 'package:event_ticketing_mobile_app/provider/mpesa.dart';
import 'package:event_ticketing_mobile_app/screens/login/SignupPage.dart';
import 'package:event_ticketing_mobile_app/screens/ticket_receipt_page.dart';
import 'package:event_ticketing_mobile_app/utilities/formfield_widg.dart';
import 'package:event_ticketing_mobile_app/utilities/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyTicketPage extends StatefulWidget {
  final EventModel event;
  const BuyTicketPage({super.key, required this.event});

  @override
  // ignore: library_private_types_in_public_api
  _BuyTicketPageState createState() => _BuyTicketPageState();
}

class _BuyTicketPageState extends State<BuyTicketPage> {
  int selectedFanZone = 0;

  var _phoneNumber = "";
  bool checkAvailability(int fanZone) {
    return true;
  }

  Timer? _timer;
  var isLoading = false;

  Future<void> makePayment(String phoneNumber, int amount) async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    var checkoutRequestID =
        await paymentProvider.initiatePayment(phoneNumber, amount);

    var paymentStatus;

    if (checkoutRequestID != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        try {
          final result =
              await paymentProvider.checkPaymentStatus(checkoutRequestID);

          if (result != null) {
            paymentStatus = result;
            setState(() {});
            if (paymentStatus['ResultCode'] != null) {
              _timer!.cancel();
            }
          }
        } catch (error) {
          errortoast(error.toString());
        }
      });
    }
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
              height: 600,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected Fan Zone: FanZone $selectedFanZone',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: true,
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      Image.asset(
                        'assets/images/mpesa.png',
                        width: 80,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(' Ticket Price: ${price.toString()}'),
                  const SizedBox(height: 16),
                  FormInputField(
                    labelText: 'PhoneNumber',
                    onchanged: (value) {
                      setState(() {
                        _phoneNumber = value!;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone number';
                      }

                      final phoneRegex = RegExp(r'^[0-9]{10}$');

                      if (!phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    ispassword: false,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      //inittiate stk push

                      // check payment if successfull show the receipt in the next page

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketReceiptPage(
                                  ticket: TicketModel(
                                      description: "",
                                      time: "10PM",
                                      title: widget.event.title,
                                      price: " Kh 500",
                                      imageUrl:
                                          "https://pbs.twimg.com/media/DpkN5pOX4AA5zzt.jpg:large",
                                      section: "FanZone#3",
                                      orderNumber: "565656675",
                                      venue: "Eldoret, Sports Club",
                                      date: "24, Aug 2024"),
                                )),
                      );
                    },
                    child: const Text('Pay'),
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
    print("PHONE Value=============$_phoneNumber");

    var user = Provider.of<FbAuthProvider>(context).getCurrentUser();
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
                TextButton(
                  onPressed: () {
                    // Check availability and proceed
                    if (selectedFanZone != 0 &&
                        checkAvailability(selectedFanZone)) {
                      //check if user is logged in
                      if (user == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage(
                                      route: BuyTicketPage(
                                    event: widget.event,
                                  ))),
                        );
                      } else {
                        buyTicket();
                      }
                    } else {
                      errortoast('FanZone not selected or unavailable');
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
