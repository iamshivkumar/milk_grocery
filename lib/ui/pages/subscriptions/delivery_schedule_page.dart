import 'package:flutter/material.dart';
import 'package:grocery_app/enums/subscription_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/loading.dart';
import 'providers/schedule_view_model_provider.dart';
import 'providers/subscriptions_provider.dart';
import 'widgets/My_calendar.dart';
import 'widgets/delivery_schedule_card.dart';

class DeliverySchedulesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final subscriptionsStream = watch(subscriptionsProvider);
    final model = watch(scheduleViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Schedule"),
      ),
      body: Column(
        children: [
          MyCalendar(),
          Expanded(
            child: subscriptionsStream.when(
              data: (subscriptions) => ListView(
                children: subscriptions.where((element) => element.status==SubscriptionStatus.active)
                    .where(
                      (element) => element.deliveries
                          .where((d) => d.date == model.selectedDate)
                          .isNotEmpty,
                    )
                    .map(
                      (e) => DeliveryScheduleCard(
                        dateTime: model.selectedDate,
                        subscription: e,
                      ),
                    )
                    .toList(),
              ),
              loading: () => Loading(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
