class Review {
  final String id;
  final String siteId;
  final String userId;
  final String userName;
  final String comment;
  final int rating; // 1-5 estrellas
  final DateTime createdAt;
  final String? response;

  Review({
    required this.id,
    required this.siteId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.response,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      siteId: map['site_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      comment: map['comment'] ?? '',
      rating: map['rating'] ?? 1,
      createdAt: DateTime.parse(map['created_at']),
      response: map['response'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'site_id': siteId,
      'user_id': userId,
      'user_name': userName,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'response': response,
    };
  }
}
