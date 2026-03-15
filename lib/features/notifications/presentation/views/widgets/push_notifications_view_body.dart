import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/fetch_notifications/fetch_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/widgets/manual_notification_form.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/widgets/notifications_feed_section.dart';

class PushNotificationsViewBody extends StatefulWidget {
  const PushNotificationsViewBody({super.key});

  @override
  State<PushNotificationsViewBody> createState() =>
      _PushNotificationsViewBodyState();
}

class _PushNotificationsViewBodyState extends State<PushNotificationsViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _userIdController = TextEditingController();
  final _orderIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FetchNotificationsCubit>().fetchNotifications();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _userIdController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ResponsiveContent(
          maxWidth: 960,
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ManualNotificationForm(
                      formKey: _formKey,
                      titleController: _titleController,
                      messageController: _messageController,
                      userIdController: _userIdController,
                      orderIdController: _orderIdController,
                      onSuccess: _clearForm,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Notifications Feed',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const NotificationsFeedSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearForm() {
    _titleController.clear();
    _messageController.clear();
    _userIdController.clear();
    _orderIdController.clear();
  }
}
