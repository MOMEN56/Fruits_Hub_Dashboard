class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.titleAr,
    required this.messageAr,
    required this.createdAt,
    this.userId,
    this.orderId,
    this.isRead = false,
  });

  final String id;
  final String type;
  final String titleAr;
  final String messageAr;
  final String? userId;
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;
}
