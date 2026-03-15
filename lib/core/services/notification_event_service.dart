import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/core/utils/backend_endpoint.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationEventService {
  NotificationEventService(
    this._dataService, {
    SupabaseClient? supabaseClient,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  final DatabaseService _dataService;
  final SupabaseClient _supabaseClient;

  Future<void> sendManualNotification({
    required String titleAr,
    required String messageAr,
    String? userId,
    String? orderId,
  }) async {
    final normalizedTitle = titleAr.trim();
    final normalizedMessage = messageAr.trim();
    final normalizedUserId = _normalizeNullable(userId);
    final normalizedOrderId = _normalizeNullable(orderId);

    await _dataService.addData(
      path: BackendEndpoint.notifications,
      data: {
        'type': 'manual',
        'title_ar': normalizedTitle,
        'message_ar': normalizedMessage,
        'user_id': normalizedUserId,
        'order_id': normalizedOrderId,
        'is_read': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      },
    );

    await _tryDispatchPush(
      userId: normalizedUserId,
      orderId: normalizedOrderId,
      target: normalizedUserId == null ? 'all' : 'user',
      type: 'manual',
      titleAr: normalizedTitle,
      messageAr: normalizedMessage,
    );
  }

  Future<void> sendOrderStatusNotification({
    required String userId,
    required String orderId,
    required OrderStatusEnum status,
  }) async {
    final normalizedUserId = _normalizeNullable(userId);
    if (normalizedUserId == null) {
      return;
    }

    final normalizedOrderId = _normalizeNullable(orderId);
    const titleAr =
        '\u062A\u062D\u062F\u064A\u062B \u0627\u0644\u0637\u0644\u0628';
    final messageAr = _resolveOrderStatusMessage(status);

    await _dataService.addData(
      path: BackendEndpoint.notifications,
      data: {
        'type': 'order_status',
        'title_ar': titleAr,
        'message_ar': messageAr,
        'user_id': normalizedUserId,
        'order_id': normalizedOrderId,
        'is_read': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      },
    );

    await _tryDispatchPush(
      userId: normalizedUserId,
      orderId: normalizedOrderId,
      target: 'user',
      type: 'order_status',
      titleAr: titleAr,
      messageAr: messageAr,
      status: status.name,
    );
  }

  Future<void> _tryDispatchPush({
    required String? userId,
    required String? orderId,
    required String target,
    required String type,
    required String titleAr,
    required String messageAr,
    String? status,
  }) async {
    try {
      await _supabaseClient.functions.invoke(
        BackendEndpoint.sendPushNotificationFunction,
        body: {
          'user_id': userId,
          'order_id': orderId,
          'target': target,
          'type': type,
          'title_ar': titleAr,
          'message_ar': messageAr,
          'status': status,
        },
      );
    } catch (_) {}
  }

  String? _normalizeNullable(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  String _resolveOrderStatusMessage(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.pending:
        return '\u064A\u062A\u0645 \u0627\u0644\u0645\u0631\u0627\u062C\u0639\u0629';
      case OrderStatusEnum.accepted:
        return '\u064A\u062A\u0645 \u062A\u062D\u0636\u064A\u0631\u0647';
      case OrderStatusEnum.delivered:
        return '\u062A\u0645 \u0627\u0644\u062A\u0648\u0635\u064A\u0644';
      case OrderStatusEnum.cancelled:
        return '\u0645\u0644\u063A\u064A';
    }
  }
}
