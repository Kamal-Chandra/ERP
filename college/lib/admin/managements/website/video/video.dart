class Video {
  final int id; // Match with backend field
  final String title;
  final String url;

  Video({
    required this.id,
    required this.title,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      url: json['url'],
    );
  }
}