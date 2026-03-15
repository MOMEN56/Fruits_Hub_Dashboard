import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fruit_hub_dashboard/core/utils/backend_endpoint.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class DashboardPushNotificationService {
  DashboardPushNotificationService({
    FirebaseMessaging? firebaseMessaging,
    SupabaseClient? supabaseClient,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _supabaseClient = supabaseClient ?? Supabase.instance.client;

  final FirebaseMessaging _firebaseMessaging;
  final SupabaseClient _supabaseClient;

  bool _isInitialized = false;
  Future<void> Function(RemoteMessage message)? _onNotificationTap;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _openAppSubscription;
  String? _lastHandledMessageKey;

  static void configureBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> initialize({
    required Future<void> Function(RemoteMessage message) onNotificationTap,
  }) async {
    _onNotificationTap = onNotificationTap;
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await registerAdminDevice();

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((
      token,
    ) {
      unawaited(_upsertDeviceToken(token));
    });

    _openAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleNotificationTap(initialMessage);
    }
  }

  Future<void> registerAdminDevice() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('[Dashboard Push] FirebaseMessaging.getToken() => ${token ?? 'null'}');
      if (token == null || token.trim().isEmpty) {
        return;
      }
      await _upsertDeviceToken(token);
    } catch (e, stackTrace) {
      log(
        '[Dashboard Push] registerAdminDevice failed: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _upsertDeviceToken(String token) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return;
    }

    final payload = {
      'user_id': BackendEndpoint.adminNotificationsUserId,
      'device_token': normalizedToken,
      'platform': 'dashboard_${Platform.operatingSystem}',
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _supabaseClient
          .from(BackendEndpoint.userDevices)
          .upsert(payload, onConflict: 'user_id,device_token');
      log('[Dashboard Push] Admin device token synced successfully.');
    } catch (e, stackTrace) {
      if (_isMissingOnConflictConstraintError(e)) {
        try {
          await _supabaseClient
              .from(BackendEndpoint.userDevices)
              .insert(payload);
          log(
            '[Dashboard Push] Upsert constraint missing. Fallback insert succeeded.',
          );
          return;
        } catch (insertError, insertStackTrace) {
          log(
            '[Dashboard Push] Fallback insert failed: $insertError',
            stackTrace: insertStackTrace,
          );
          return;
        }
      }
      log(
        '[Dashboard Push] Failed to sync admin device token: $e',
        stackTrace: stackTrace,
      );
    }
  }

  bool _isMissingOnConflictConstraintError(Object error) {
    final text = error.toString();
    return text.contains('42P10') &&
        text.contains(
          'no unique or exclusion constraint matching the ON CONFLICT specification',
        );
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    final uniqueKey = message.messageId ??
        '${message.sentTime?.millisecondsSinceEpoch ?? 0}-${message.data.hashCode}';
    if (_lastHandledMessageKey == uniqueKey) {
      return;
    }
    _lastHandledMessageKey = uniqueKey;
    await _onNotificationTap?.call(message);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _openAppSubscription?.cancel();
  }
}
