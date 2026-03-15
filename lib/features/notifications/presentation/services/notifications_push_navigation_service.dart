import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fruit_hub_dashboard/core/services/app_navigation_service.dart';
import 'package:fruit_hub_dashboard/core/services/dashboard_push_notification_service.dart';
import 'package:fruit_hub_dashboard/core/services/get_it_service.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/orders_view.dart';

abstract final class NotificationsPushNavigationService {
  static bool _isInitialized = false;
  static bool _hasPendingOpen = false;

  static void initialize() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    unawaited(_initializeInternal());
  }

  static Future<void> _initializeInternal() async {
    await getIt<DashboardPushNotificationService>().initialize(
      onNotificationTap: _openNotificationsFromPush,
    );
  }

  static Future<void> _openNotificationsFromPush(RemoteMessage message) async {
    _pushToOrders();
  }

  static void _pushToOrders() {
    final navigatorState = AppNavigationService.navigatorKey.currentState;
    if (navigatorState != null) {
      _hasPendingOpen = false;
      navigatorState.pushNamed(OrdersView.routeName);
      return;
    }

    if (_hasPendingOpen) {
      return;
    }
    _hasPendingOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flushPendingNavigation();
    });
  }

  static void _flushPendingNavigation() {
    if (!_hasPendingOpen) {
      return;
    }

    final navigatorState = AppNavigationService.navigatorKey.currentState;
    if (navigatorState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _flushPendingNavigation();
      });
      return;
    }

    _hasPendingOpen = false;
    navigatorState.pushNamed(OrdersView.routeName);
  }
}
