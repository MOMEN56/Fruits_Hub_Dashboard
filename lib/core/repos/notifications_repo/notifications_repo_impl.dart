import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/core/services/notification_event_service.dart';
import 'package:fruit_hub_dashboard/core/utils/backend_endpoint.dart';

import 'notification_entity.dart';
import 'notifications_repo.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  NotificationsRepoImpl(this._dataService, this._notificationEventService);

  final DatabaseService _dataService;
  final NotificationEventService _notificationEventService;

  @override
  Stream<Either<Failure, List<NotificationEntity>>>
      fetchNotifications() async* {
    await for (final data in _dataService.streamData(
      path: BackendEndpoint.notifications,
      query: {
        'orderBy': 'created_at',
        'descending': true,
      },
    )) {
      if (data is! List) {
        continue;
      }

      final notifications = <NotificationEntity>[];
      for (final rawItem in data.whereType<Map>()) {
        try {
          notifications.add(
            _NotificationMapper.fromJson(Map<String, dynamic>.from(rawItem)),
          );
        } catch (_) {}
      }

      yield Right(notifications);
    }
  }

  @override
  Future<Either<Failure, void>> sendManualNotification({
    required String titleAr,
    required String messageAr,
    String? userId,
    String? orderId,
  }) async {
    try {
      await _notificationEventService.sendManualNotification(
        titleAr: titleAr,
        messageAr: messageAr,
        userId: userId,
        orderId: orderId,
      );
      return right(null);
    } catch (_) {
      return Left(ServerFailure('Failed to send notification'));
    }
  }
}

class _NotificationMapper {
  static NotificationEntity fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: (json['id'] ?? json['notification_id'] ?? '').toString(),
      type: (json['type'] ?? 'manual').toString(),
      titleAr: (json['title_ar'] ?? json['title'] ?? '').toString(),
      messageAr: (json['message_ar'] ?? json['message'] ?? '').toString(),
      userId: _nullableString(json['user_id']),
      orderId: _nullableString(json['order_id']),
      isRead: _toBool(json['is_read']),
      createdAt: _toDateTime(json['created_at']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final text = (value ?? '').toString().toLowerCase();
    return text == 'true' || text == '1';
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    final parsed = DateTime.tryParse((value ?? '').toString());
    return parsed ?? DateTime.now();
  }

  static String? _nullableString(dynamic value) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }
    return text;
  }
}
