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
  TicketModel({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.venue,
    required this.time,
    required this.date,
    required this.section,
    required this.orderNumber,
    required this.price,
  });
}
