class EventModel {
  final String id;
  final String title;
  final String imageUrl;
  final String venue;
  final String time;
  final String date;
  final List<FanZone>? section;
  final String description;
  final bool recommended;
  final bool upcoming;

  EventModel({
    required this.section,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.venue,
    required this.time,
    required this.date,
    required this.description,
    required this.recommended,
    required this.upcoming,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      section: null,
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      venue: json['venue'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      recommended: json['recommended'] ?? false,
      upcoming: json['upcoming'] ?? false,
    );
  }
}

class FanZone {
  final String name;
  final int capacity;
  final double price;
  final bool available;

  FanZone({
    required this.name,
    required this.capacity,
    required this.price,
    required this.available,
  });

  factory FanZone.fromJson(Map<String, dynamic> json) {
    return FanZone(
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      price: json['price'] ?? 0.0,
      available: json['available'] ?? false,
    );
  }
}
