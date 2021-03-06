import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/ui/pages/privacy_policy_page.dart';
import 'package:grocery_app/ui/pages/terms_page.dart';
import 'package:grocery_app/ui/pages/tranzactions/tranzactions_page.dart';
import 'package:grocery_app/ui/pages/wallet_charges/charges_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../address/address_page.dart';
import '../../auth/providers/auth_view_model_provider.dart';
import '../../orders/orders_page.dart';
import '../../profile/profile_page.dart';
import '../../subscriptions/delivery_schedule_page.dart';
import '../../subscriptions/my_subscriptions_page.dart';

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
    final profile = context.read(profileProvider).data!.value;

    return Material(
      color: theme.accentColor,
      child: SafeArea(
        child: Theme(
          data: ThemeData.dark(),
          child: ListView(
            children: [
              ListTile(
                title: Text(profile.name),
                subtitle: Text(profile.mobile),
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
                        "₹${profile.walletAmount}",
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
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TranzactionsPage(),
                    ),
                  );
                },
                leading: Icon(Icons.history),
                title: Text("Tranzactions History"),
              ),
              ListTile(
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletChargesPage(),
                    ),
                  );
                },
                leading: Icon(Icons.history),
                title: Text("Wallet Charges History"),
              ),
              ListTile(
                onTap: () {
                  launch(
                      "mailto:mailbox.kisannest@gmail.com?subject=Feedback from " +
                          profile.name +
                          profile.mobile +
                          ")");
                },
                title: Text('Feedback'),
                leading: Icon(Icons.feedback_outlined),
              ),
              ListTile(
                onTap: () {
                  close();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Material(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  launch("tel://+916364999917");
                                },
                                child: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: Image.asset("assets/call.png"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  launch("whatsapp://send?phone=+916364999917");
                                },
                                child: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: Image.asset("assets/whats_app.jpeg"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                title: Text('Contact us'),
                leading: Icon(Icons.message_outlined),
              ),
              ListTile(
                onTap: () {
                  Share.share(
                      "https://play.google.com/store/apps/details?id=kisannest.in.daily");
                },
                title: Text('Share'),
                leading: Icon(Icons.share),
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  context.read(authViewModelProvider).signOut();
                  close();
                },
                leading: Icon(Icons.logout),
              ),
              Divider(),
              ListTile(
                title: Text('Privacy Policy'),
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Terms & conditions'),
                onTap: () {
                  close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsPage(),
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
