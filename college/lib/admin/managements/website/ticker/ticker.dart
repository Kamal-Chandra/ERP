class Ticker {
  final int tickerId;
  final String message;
  final DateTime datePosted;
  final String timePosted;
  final DateTime displayUntil;

  Ticker({
    required this.tickerId,
    required this.message,
    required this.datePosted,
    required this.timePosted,
    required this.displayUntil,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      tickerId: json['ticker_id'],
      message: json['message'],
      datePosted: DateTime.parse(json['date_posted']),
      timePosted: json['time_posted'],
      displayUntil: DateTime.parse(json['display_until']),
    );
  }
}