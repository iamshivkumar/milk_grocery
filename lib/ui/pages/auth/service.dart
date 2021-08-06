import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/auth_view_model_provider.dart';
import 'widgets/sign_in_sheet.dart';
import 'widgets/update_display_name_sheet.dart';

class AuthService {
  final BuildContext context;
  AuthService(this.context);

  AuthViewModel get _model => context.read(authViewModelProvider);
  Future<bool> ready() async {
    if (_model.user == null) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SignInSheet(),
      );
    }
    if (_model.user == null) {
      return false;
    }
    if (_model.user!.displayName == null) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => UpdateDisplayNameSheet(),
      );
    }
    if (_model.user!.displayName == null) {
      return false;
    }
    return true;
  }
}
