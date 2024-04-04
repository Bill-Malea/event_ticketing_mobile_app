import 'dart:async';
import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/models/ticket_model.dart';
import 'package:event_ticketing_mobile_app/provider/auth.dart';
import 'package:event_ticketing_mobile_app/provider/mpesa.dart';
import 'package:event_ticketing_mobile_app/provider/ticketing.dart';
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

  int selectedFanZonePrice = 1;

  var _phoneNumber = "";

  bool checkAvailability(int fanZone) {
    return true;
  }

  Timer? _timer;

  var isLoading = false;

  String getFanZone(int fanZone) {
    return 'FanZone#$fanZone';
  }

  Future<void> makePayment(
      String phoneNumber, int amount, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

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
            _timer!.cancel();
            //upon successfull payment create ticket

            if (result == "0") {
              final ticket = TicketModel(
                  title: widget.event.title,
                  imageUrl: widget.event.imageUrl,
                  venue: widget.event.venue,
                  time: widget.event.time,
                  date: widget.event.date,
                  description: widget.event.description,
                  price: selectedFanZonePrice.toString(),
                  checkedIn: false,
                  section: getFanZone(selectedFanZone),
                  orderNumber: "");
              // ignore: use_build_context_synchronously
              await Provider.of<TicketProvider>(context, listen: false)
                  .createTicket(ticket: ticket, eventId: widget.event.id)
                  .then((value) => {
                        setState(() {
                          isLoading = false;
                        })
                      });
            } else {
              setState(() {
                isLoading = false;
              });
              errortoast("Payment Failed Try Again");
            }
            setState(() {
              isLoading = false;
            });
          }
        } catch (error) {
          errortoast(error.toString());
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  int fetchPricing(int fanZone) {
    return 50;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FbAuthProvider>(context).getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Section'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AvailabilityIndicator(
                          color: Color.fromARGB(255, 26, 194, 236),
                          status: 'Available'),
                      AvailabilityIndicator(
                          color: Colors.black87, status: 'Sold Out'),
                      AvailabilityIndicator(
                          color: Color.fromARGB(255, 127, 250, 131),
                          status: 'Selected'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                                height: 230,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: selectedFanZone == 1
                                            ? const Color.fromARGB(
                                                255, 127, 250, 131)
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        color: selectedFanZone == 2
                                            ? const Color.fromARGB(
                                                255, 127, 250, 131)
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
                                height: 230,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
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
                      ],
                    ),
                  ),
                  selectedFanZone == 0
                      ? const SizedBox(
                          height: 1,
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Selected Fan Zone: FanZone $selectedFanZone',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                              Text(' Ticket Price: $selectedFanZonePrice'),
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
                              isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                      ),
                                      onPressed: () async {
                                        //inittiate stk push

                                        if (_phoneNumber.length != 10) {
                                          errortoast(
                                              "Enter a valid phonenumber");
                                          return;
                                        }

                                        await makePayment(_phoneNumber,
                                            selectedFanZonePrice, context);
                                      },
                                      child: const Text('Pay'),
                                    ),
                            ],
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
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
