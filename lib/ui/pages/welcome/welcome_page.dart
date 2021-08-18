import 'package:flutter/material.dart';

import '../auth/service.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 2 / 5 * height,
        decoration: BoxDecoration(
          color: Color(0xFFE1E2E8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Delivery at Doorship",
                  style: style.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "During these pandemic times, we are maintaining the best possible hygiene factors and delivering by maintaining social distance.",
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: MaterialButton(
                  color: theme.primaryColor,
                  onPressed: () {
                    AuthService(context).show();
                  },
                  child: Text("CONTINUE"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset("assets/Group 8.png"),
        ),
      ),
    );
  }
}
