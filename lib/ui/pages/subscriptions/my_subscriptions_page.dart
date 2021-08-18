import 'package:flutter/material.dart';
import 'widgets/subscription_card.dart';
import '../../widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/subscriptions_provider.dart';

class SubscriptionsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final subscriptionsStream = watch(subscriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Subscriptions"),
      ),
      body: subscriptionsStream.when(
        data: (subscriptions) => ListView(
          padding: EdgeInsets.all(4),
          children: subscriptions
              .map(
                (e) => SubscriptionCard(subscription: e)
              )
              .toList(),
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
