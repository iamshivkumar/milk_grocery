import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:grocery_app/ui/pages/address/address_page.dart';
import 'package:grocery_app/ui/pages/auth/providers/auth_view_model_provider.dart';
import 'package:grocery_app/ui/pages/profile/profile_page.dart';
import 'package:grocery_app/ui/pages/subscriptions/delivery_schedule_page.dart';
import 'package:grocery_app/ui/pages/subscriptions/my_subscriptions_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../orders/orders_page.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback close;

  const MyDrawer({Key? key, required this.close}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.apply(
      bodyColor: theme.cardColor,
      displayColor: theme.cardColor,
    );
    final authModel = context.read(authViewModelProvider);
    final profileAsync = context.read(profileProvider);

    return Material(
      color: theme.accentColor,
      child: SafeArea(
        child: Theme(
          data: ThemeData.dark(),
          child: ListView(
            children: [
              ListTile(
                title: Text(authModel.user!.displayName ?? ""),
                subtitle: Text(authModel.user!.phoneNumber!),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "₹${profileAsync.data!.value.walletAmount}",
                        style: style.headline6,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                leading: Icon(Icons.person_outline),
                title: Text("My Profile"),
              ),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliverySchedulesPage(),
                    ),
                  );
                },
                leading: Icon(Icons.schedule),
                title: Text("Delivery Schedule"),
              ),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionsPage(),
                    ),
                  );
                },
                leading: Icon(Icons.calendar_view_month),
                title: Text("My Subscriptions"),
              ),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersPage(),
                    ),
                  );
                },
                leading: Icon(Icons.shopping_basket_outlined),
                title: Text("My Orders"),
              ),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressPage(),
                    ),
                  );
                },
                leading: Icon(Icons.location_pin),
                title: Text("My Address"),
              ),
              ListTile(
                onTap: () {
                  launch(
                      "mailto:shivkumarkonade@gmail.com?subject=Feedback from " +
                          authModel.user!.displayName! +
                          " (" +
                          authModel.user!.phoneNumber! +
                          ")");
                },
                title: Text('Feedback'),
                leading: Icon(Icons.feedback_outlined),
              ),
              ListTile(
                onTap: () {
                  launch("mailto:shivkumarkonade@gmail.com?subject=" +
                      authModel.user!.displayName! +
                      " (" +
                      authModel.user!.phoneNumber! +
                      "): <Subject>");
                },
                title: Text('Contact us'),
                leading: Icon(Icons.message_outlined),
              ),
              ListTile(
                onTap: () {
                  // Share.share(
                  //     "https://play.google.com/store/apps/details?id=org.telegram.messenger");
                },
                title: Text('Share'),
                leading: Icon(Icons.share),
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  authModel.signOut();
                  close();
                },
                leading: Icon(Icons.logout),
              ),
              Divider(),
              ListTile(
                title: Text('About'),
              ),
              ListTile(
                title: Text('Privacy Policy'),
              ),
              ListTile(
                title: Text('Terms & conditions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
