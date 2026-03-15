import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_button.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/send_notification/send_notification_cubit.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manager/send_notification/send_notification_state.dart';

class ManualNotificationForm extends StatelessWidget {
  const ManualNotificationForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.messageController,
    required this.userIdController,
    required this.orderIdController,
    required this.onSuccess,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final TextEditingController userIdController;
  final TextEditingController orderIdController;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Manual Notification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (Arabic)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message (Arabic)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Message is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'Target User ID (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: orderIdController,
                decoration: const InputDecoration(
                  labelText: 'Order ID (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              BlocConsumer<SendNotificationCubit, SendNotificationState>(
                listener: (context, state) {
                  if (state is SendNotificationSuccess) {
                    onSuccess();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification sent successfully'),
                      ),
                    );
                  }
                  if (state is SendNotificationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is SendNotificationLoading;
                  return IgnorePointer(
                    ignoring: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.6 : 1,
                      child: CustomButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          context
                              .read<SendNotificationCubit>()
                              .sendManualNotification(
                                titleAr: titleController.text,
                                messageAr: messageController.text,
                                userId: userIdController.text,
                                orderId: orderIdController.text,
                              );
                        },
                        text: isLoading ? 'Sending...' : 'Send Notification',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
