import 'package:flutter/material.dart';
import 'package:grocery_app/ui/pages/subscriptions/providers/schedule_view_model_provider.dart';
import 'package:grocery_app/ui/pages/subscriptions/providers/subscriptions_provider.dart';
import 'package:grocery_app/ui/pages/subscriptions/widgets/delivery_schedule_card.dart';
import 'package:grocery_app/ui/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/My_calendar.dart';

class DeliverySchedulesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final subscriptionsStream = watch(subscriptionsProvider);
    final model = watch(scheduleViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Schedule"),
      ),
      body: subscriptionsStream.when(
        data: (subscriptions) => Column(
          children: [
            MyCalendar(),
            Expanded(
              child: ListView(
                children: subscriptions
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
            ),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
