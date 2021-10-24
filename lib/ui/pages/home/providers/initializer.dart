import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/ui/pages/orders/orders_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final initializer = Provider.family<void, BuildContext>((ref, context) {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final theme = Theme.of(context);
  messaging.subscribeToTopic("order");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification!.title ?? ''),
          content: Text(message.notification!.body ?? ''),
          actions: [
            MaterialButton(
              color: theme.accentColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OKAY"),
            )
          ],
        ),
      );
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrdersPage(),
      ),
    );
  });
});
