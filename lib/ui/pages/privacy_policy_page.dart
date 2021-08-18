import 'package:flutter/material.dart';
import 'package:grocery_app/utils/datas.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: Datas.values
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.title,
                          style: style.headline6,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.description,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
