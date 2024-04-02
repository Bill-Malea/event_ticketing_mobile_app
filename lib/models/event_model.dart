class EventModel {
  final String title;
  final String imageUrl;
  final String venue;
  final String time;
  final String date;

  final String description;
  EventModel({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.venue,
    required this.time,
    required this.date,
  });
}
