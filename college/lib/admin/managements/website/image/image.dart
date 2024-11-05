class ERPImage {
  final int id;
  final String url;

  ERPImage({
    required this.id,
    required this.url,
  });

  factory ERPImage.fromJson(Map<String, dynamic> json) {
    return ERPImage(
      id: json['id'],
      url: json['url'],
    );
  }
}