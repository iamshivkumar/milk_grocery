import 'package:grocery_app/core/models/profile.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/providers/repository_provider.dart';

final addWalletAmountViewModelProvider =
    Provider<AddWalletAmountViewModel>((ref) => AddWalletAmountViewModel(ref));

class AddWalletAmountViewModel {
  final ProviderReference ref;

  AddWalletAmountViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider);
  Profile get profile => ref.read(profileProvider).data!.value;
  double? amount;

  final _razorpay = Razorpay();

  void addAmount() {
    final options = {
      'key': "rzp_test_KmPzyFK6pErbkC",

      // 'key': 'rzp_test_x3mfqcbSvLL213',
      'amount': (amount! * 100).toInt(),
      'name': 'Grcoery',
      'description': 'Add Wallet Amount',
      'prefill': {'contact': _repository.user.phoneNumber}
    };

    _razorpay.open(options);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse res) {
      _repository.addWalletAmount(
        amount: amount!,
        paymentId: res.paymentId,
        name: profile.name,
        uid: profile.id,
      );
      _razorpay.clear();
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (res) {
      _razorpay.clear();
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse res) {
      print(res.walletName);
      _razorpay.clear();
    });
  }
}
