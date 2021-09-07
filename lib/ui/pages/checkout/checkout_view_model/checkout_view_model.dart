import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/offer.dart';
import 'package:grocery_app/core/providers/master_data_provider.dart';
import 'package:grocery_app/utils/labels.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/models/order.dart';
import '../../../../core/models/order_product.dart';
import '../../../../core/models/profile.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/repository_provider.dart';
import '../../../../enums/order_status.dart';

class CheckoutViewModel extends ChangeNotifier {
  final ProviderReference ref;

  CheckoutViewModel(this.ref);

  Profile get profile => ref.read(profileProvider).data!.value;
  Repository get repository => ref.read(repositoryProvider);
  List<Offer> get _offers => ref.read(masterdataProvider).data!.value.offers;

  double walletAmount = 0;

  void useWallet(double total) {
    final double amount = profile.walletAmount;
    if (amount <= total) {
      walletAmount = amount;
    } else {
      walletAmount = total;
    }
    notifyListeners();
  }

  void cancelUsingWallet() {
    walletAmount = 0;
    notifyListeners();
  }

  final _razorpay = Razorpay();

  void payOrder({
    required List<OrderProduct> products,
    required double price,
    required int items,
    required VoidCallback onOrder,
  }) async {
    loading = true;
    final double total = price - walletAmount - extra(price - walletAmount);
    final String? discount = extra(price - walletAmount) > 0
        ? "${Labels.rupee}${extra(price - walletAmount)} ${percentage(price - walletAmount)}"
        : null;
    if (total > 1) {
      final options = {
        'key': "rzp_test_KmPzyFK6pErbkC",
        // 'key': 'rzp_test_x3mfqcbSvLL213',
        'amount': (total * 100).toInt(),
        'name': 'Grcoery',
        'description': 'Pay For Checkout',
        'prefill': {'contact': repository.user.phoneNumber}
      };

      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse res) async {
        print("Payment Success");
        await _order(
          products: products,
          price: price,
          total: total,
          items: items,
          paid: true,
          onOrder: onOrder,
          paymentId: res.paymentId,
          discount: discount,
        );
        _razorpay.clear();
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse res) {
        _razorpay.clear();
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse res) {
        _razorpay.clear();
        loading = false;
      });
    } else if (total < 1) {
      await _order(
        products: products,
        total: total,
        price: price,
        items: items,
        paid: true,
        onOrder: onOrder,
        discount: discount,
      );
      loading = false;
    } else {
      await _order(
        products: products,
        total: total,
        price: price,
        items: items,
        paid: false,
        onOrder: onOrder,
        discount: discount,
      );
      loading = false;
    }
  }

  Future<void> _order({
    required List<OrderProduct> products,
    required double price,
    required double total,
    required int items,
    required bool paid,
    required VoidCallback onOrder,
    String? paymentId,
    String? discount,
  }) async {
    final Order order = Order(
      id: '',
      customerName: profile.name,
      customerMobile: profile.mobile,
      price: price,
      products: products,
      status: OrderStatus.pending,
      walletAmount: walletAmount,
      paid: paid,
      createdOn: DateTime.now(),
      customerId: profile.id,
      items: items,
      paymentId: paymentId,
      total: total,
      orderId: '',
      discount: discount,
      milkManId: profile.milkManId,
      paymentMethod: (walletAmount > 1 ? "Wallet" : "") +
          (walletAmount > 1 && total > 1 ? " + " : "") +
          (total > 1 ? "Razorpay" : ''),
      packed: products.where((p) => !p.isMilky).isEmpty,
    );
    try {
      await repository.order(order: order, map: profile.toDeliveryAddressMap());
      onOrder();
    } catch (e) {
      print(e);
    }
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  double extra(double amount) {
    final list =
        _offers.where((element) => element.amount <= (amount)).toList();
    if (list.isEmpty) {
      return 0;
    }
    list.sort((a, b) => a.amount.compareTo(b.amount));
    return list.last.percentage * (amount) / 100;
  }

  String percentage(double amount) {
    final list =
        _offers.where((element) => element.amount <= (amount)).toList();
    if (list.isEmpty) {
      return "";
    }
    list.sort((a, b) => a.amount.compareTo(b.amount));

    return "(${list.last.percentage.toInt()}\%)";
  }
}
