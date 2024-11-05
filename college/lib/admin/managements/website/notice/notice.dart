class Notice {
  final int noticeId;
  final String title;
  final String noticeText;
  final DateTime date;
  final String time;
  final String noticeType;
  final String priority;
  final String attachments;

  Notice({
    required this.noticeId,
    required this.title,
    required this.noticeText,
    required this.date,
    required this.time,
    required this.noticeType,
    required this.priority,
    required this.attachments,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['notice_id'],
      title: json['title'],
      noticeText: json['notice_text'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      noticeType: json['notice_type'],
      priority: json['priority'],
      attachments: json['attachments'],
    );
  }
}