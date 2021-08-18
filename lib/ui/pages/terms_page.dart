import 'package:flutter/material.dart';
import 'package:grocery_app/utils/datas.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24),
      //     child: Text(Datas.terms),
      //   ),
      // ),
    );
  }
}
