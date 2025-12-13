class FaqModel {
  String id;
  String text;
  bool isLiked;
  DateTime timestamp;

  FaqModel({
    required this.id,
    required this.text,
    this.isLiked = false,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isLiked': isLiked,
    'timestamp': timestamp.toIso8601String(),
  };

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    id: json['id'],
    text: json['text'],
    isLiked: json['isLiked'] ?? false,
    timestamp: DateTime.parse(json['timestamp']),
  );
}
