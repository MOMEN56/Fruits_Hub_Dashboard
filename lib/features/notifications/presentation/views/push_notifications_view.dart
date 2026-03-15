import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/services/get_it_service.dart';
import 'package:fruit_hub_dashboard/core/widgets/build_app_bar.dart';
import 'package:fruit_hub_dashboard/features/notifications/domain/usecases/fetch_notifications_use_case.dart';
import 'package:fruit_hub_dashboard/features/notifications/domain/usecases/send_manual_notification_use_case.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/fetch_notifications/fetch_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/send_notification/send_notification_cubit.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/widgets/push_notifications_view_body.dart';

class PushNotificationsView extends StatelessWidget {
  const PushNotificationsView({super.key});

  static const routeName = 'push-notifications';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchNotificationsCubit>(
          create: (_) =>
              FetchNotificationsCubit(getIt.get<FetchNotificationsUseCase>()),
        ),
        BlocProvider<SendNotificationCubit>(
          create: (_) => SendNotificationCubit(
            getIt.get<SendManualNotificationUseCase>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: buildAppBar('Push Notification'),
        body: const PushNotificationsViewBody(),
      ),
    );
  }
}
