import 'dart:typed_data';
import 'dart:convert';

class Slider {
  final int sliderId;
  final Uint8List imageData;
  final String title;
  final String description;
  final DateTime datePosted;

  Slider({
    this.sliderId = 0,
    required this.imageData,
    required this.title,
    required this.description,
    DateTime? datePosted,
  }) : datePosted = datePosted ?? DateTime.now();

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      sliderId: json['slider_id'],
      imageData: base64Decode(json['image_data']),
      title: json['title'],
      description: json['description'],
      datePosted: DateTime.parse(json['date_posted']),
    );
  }
}