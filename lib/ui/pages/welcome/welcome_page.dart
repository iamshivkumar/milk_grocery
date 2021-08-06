
import 'package:flutter/material.dart';

import '../auth/service.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: MaterialButton(
          color: theme.primaryColor,
          onPressed: () {
            AuthService(context).ready();
          },
          child: Text("CONTINUE"),
        ),
      ),
    );
  }
}
