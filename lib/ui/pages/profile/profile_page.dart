import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/profile_provider.dart';
import '../auth/widgets/update_display_name_sheet.dart';
import 'widgets/add_wallet_amount_sheet.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    var profile = watch(profileProvider).data!.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(2.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(profile.name),
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => UpdateDisplayNameSheet(
                              initialValue: profile.name),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(profile.mobile),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet_outlined),
                    title: Text('Wallet Amount:'),
                    trailing: Text('₹' + profile.walletAmount.toString()),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 20, bottom: 20),
                    child: MaterialButton(
                      color: theme.accentColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text("Wallet Amount"),
                        ],
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => AddWalletAmountSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
