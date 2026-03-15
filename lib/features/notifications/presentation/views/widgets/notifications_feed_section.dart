import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/fetch_notifications/fetch_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/fetch_notifications/fetch_notifications_state.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/widgets/notification_list_item.dart';

class NotificationsFeedSection extends StatelessWidget {
  const NotificationsFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchNotificationsCubit, FetchNotificationsState>(
      builder: (context, state) {
        if (state is FetchNotificationsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is FetchNotificationsFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text(state.errMessage)),
          );
        }
        if (state is FetchNotificationsSuccess) {
          if (state.notifications.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No notifications yet.'),
              ),
            );
          }

          return Column(
            children: [
              for (int index = 0;
                  index < state.notifications.length;
                  index++) ...[
                NotificationListItem(
                  notification: state.notifications[index],
                ),
                if (index != state.notifications.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
