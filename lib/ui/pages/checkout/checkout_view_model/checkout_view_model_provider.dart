import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout_view_model.dart';

final checkoutViewModelProvider =
    ChangeNotifierProvider.autoDispose<CheckoutViewModel>(
  (ref) => CheckoutViewModel(ref),
);
