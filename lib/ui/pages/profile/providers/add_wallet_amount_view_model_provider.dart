import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/offer.dart';
import 'package:grocery_app/core/models/profile.dart';
import 'package:grocery_app/core/providers/master_data_provider.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/providers/repository_provider.dart';

final addWalletAmountViewModelProvider =
    ChangeNotifierProvider.autoDispose<AddWalletAmountViewModel>(
        (ref) => AddWalletAmountViewModel(ref));

class AddWalletAmountViewModel extends ChangeNotifier {
  final ProviderReference ref;

  AddWalletAmountViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider);
  Profile get profile => ref.read(profileProvider).data!.value;
  List<Offer> get _offers => ref.read(masterdataProvider).data!.value.offers;

  double? _amount;
  double? get amount => _amount;
  set amount(double? amount) {
    _amount = amount;
    notifyListeners();
  }

  double get extra {
    final list =
        _offers.where((element) => element.amount <= (amount ?? 0)).toList();
    if (list.isEmpty) {
      return 0;
    }
    list.sort((a, b) => a.amount.compareTo(b.amount));
    return list.last.percentage * (amount ?? 0) / 100;
  }

  String get extraPercentage {
    final list =
        _offers.where((element) => element.amount <= (amount ?? 0)).toList();
    if (list.isEmpty) {
      return "";
    }
    list.sort((a, b) => a.amount.compareTo(b.amount));

    return "(${list.last.percentage.toInt()}\% extra)";
  }

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
        extra: extra,
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
