
import 'package:flutter/foundation.dart';
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
  }) {
    final double total = price  - walletAmount;

    if (total > 0) {
      final options = {
        'key': 'rzp_test_KmPzyFK6pErbkC',
        'amount': (total * 100).toInt(),
        'name': 'Grcoery',
        'description': 'Pay For Checkout',
        'prefill': {'contact': repository.user.phoneNumber}
      };

      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse res) {
        print("Payment Success");
        print(res.orderId);
        _order(
          products: products,
          price: price,
          total: total,
          items: items,
          paid: true,
          onOrder: onOrder,
          paymentId: res.paymentId,
        );
        _razorpay.clear();
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (res) {
        _razorpay.clear();
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse res) {
        print(res.walletName);
        _razorpay.clear();
      });
    } else if (total == 0) {
      _order(
        products: products,
        total: total,
        price: price,
        items: items,
        paid: true,
        onOrder: onOrder,
      );
    } else {
      _order(
        products: products,
        total: total,
        price: price,
        items: items,
        paid: false,
        onOrder: onOrder,
      );
    }
  }

  void _order({
    required List<OrderProduct> products,
    required double price,
    required double total,
    required int items,
    required bool paid,
    required VoidCallback onOrder,
    String? paymentId,
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
      milkManId: profile.milkManId,
      paymentMethod: "Razorpay"
    );
    try {
      await repository.order(order: order,map: profile.toDeliveryAddressMap());
      onOrder();
    } catch (e) {
      print(e);
    }
  }
}
