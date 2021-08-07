import 'package:flutter/material.dart';
import 'package:grocery_app/ui/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/orders_provider.dart';
import 'widgets/order_card.dart';

class OrdersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ordersStream = watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: ordersStream.when(
        data: (orders) => ListView(
          padding: EdgeInsets.all(4),
          children: orders
              .map(
                (e) => OrderCard(order: e),
              )
              .toList(),
        ),
        loading: () => Loading(),
        error: (e, s) => SizedBox(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
