import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MaintenancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(
              "assets/undraw_Maintenance.svg",
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "App is an under maintenance. Please try again later.",
              style: style.headline6,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
