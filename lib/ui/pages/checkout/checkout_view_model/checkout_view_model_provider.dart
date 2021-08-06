import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:grocery_app/core/repository/repository_provider.dart';

import 'checkout_view_model.dart';

final checkoutViewModelProvider =
    ChangeNotifierProvider.autoDispose<CheckoutViewModel>(
  (ref) {
    final profile = ref.read(profileProvider).data!.value;
    final repository = ref.read(repositoryProvider);
    return CheckoutViewModel(
      // profile: profile,
      // repository: repository,
    );
  },
);
