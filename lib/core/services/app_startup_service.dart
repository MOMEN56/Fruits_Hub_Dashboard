import 'package:fruit_hub_dashboard/features/notifications/presentation/services/notifications_push_navigation_service.dart';

import 'dashboard_push_notification_service.dart';

abstract final class AppStartupService {
  static void initialize() {
    DashboardPushNotificationService.configureBackgroundHandler();
    NotificationsPushNavigationService.initialize();
  }
}
