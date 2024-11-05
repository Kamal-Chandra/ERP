class Slider {
  final int id;
  final String title;
  final String url;

  Slider({
    required this.id,
    required this.title,
    required this.url,
  });

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      id: json['id'],
      title: json['title'],
      url: json['url'],
    );
  }
}