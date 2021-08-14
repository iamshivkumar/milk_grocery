import 'package:flutter/material.dart';

import 'widgets/sign_in_sheet.dart';

class AuthService {
  final BuildContext context;
  AuthService(this.context);
  void show() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SignInSheet(),
    );
  }
}
