class TicketModel {
  final String title;
  final String imageUrl;
  final String venue;
  final String time;
  final String date;
  final String section;
  final String orderNumber;
  final String description;
  final String price;
  final bool checkedIn;

  TicketModel({
    required this.title,
    required this.imageUrl,
    required this.venue,
    required this.time,
    required this.date,
    required this.section,
    required this.orderNumber,
    required this.description,
    required this.price,
    required this.checkedIn,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      venue: json['venue'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      section: json['section'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      checkedIn: json['checkedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'venue': venue,
      'time': time,
      'date': date,
      'section': section,
      'orderNumber': orderNumber,
      'description': description,
      'price': price,
      'checkedIn': checkedIn,
    };
  }
}
