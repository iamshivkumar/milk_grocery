import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/profile.dart';
import 'package:grocery_app/core/repository/repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutViewModel extends ChangeNotifier {
  // final Profile profile;
  // final Repository repository;
  // final double deliveryCharge;

  // CheckoutViewModel({
  //   required this.profile,
  //   required this.repository,
  //   required this.deliveryCharge,
  // });

  // int currentStep = 0;

  // void setStep(int value) {
  //   currentStep = value;
  //   notifyListeners();
  // }

  // void back() {
  //   currentStep--;
  //   notifyListeners();
  // }

  // void next() {
  //   currentStep++;
  //   notifyListeners();
  // }

  // DateTime? _date;
  // DateTime? get date => _date;
  // set date(DateTime? date) {
  //   _date = date;
  //   notifyListeners();
  // }

  // DeliveyBy? _deliveyBy;
  // DeliveyBy? get deliveyBy => _deliveyBy;
  // set deliveyBy(DeliveyBy? deliveyBy) {
  //   _deliveyBy = deliveyBy;
  //   notifyListeners();
  // }

  // GeoPoint? _geoPoint;
  // GeoPoint? get geoPoint => _geoPoint;
  // set geoPoint(GeoPoint? geoPoint) {
  //   _geoPoint = geoPoint;
  //   notifyListeners();
  // }

  // String? _paymentMethod;
  // String? get paymentMethod => _paymentMethod;
  // set paymentMethod(String? paymentMethod) {
  //   _paymentMethod = paymentMethod;
  //   notifyListeners();
  // }

  // bool get ready => date != null && deliveyBy != null && geoPoint != null;

  // double walletAmount = 0;

  // void useWallet(double total) {
  //   final double amount = profile.walletAmount;
  //   if (amount <= total) {
  //     walletAmount = amount;
  //   } else {
  //     walletAmount = total;
  //   }
  //   notifyListeners();
  // }

  // void cancelUsingWallet() {
  //   walletAmount = 0;
  //   notifyListeners();
  // }

  // String _getCode(int length) {
  //   String _chars = '1234567890';
  //   Random _rnd = Random();
  //   return String.fromCharCodes(
  //     Iterable.generate(
  //       length,
  //       (_) => _chars.codeUnitAt(
  //         _rnd.nextInt(_chars.length),
  //       ),
  //     ),
  //   );
  // }

  // final _razorpay = Razorpay();

  // void payOrder({
  //   required List<OrderProduct> products,
  //   required double total,
  //   required int items,
  //   required VoidCallback onOrder,
  // }) {
  //   final double totalPrice = total + deliveryCharge - walletAmount;

  //   if (paymentMethod == 'Razorpay' && totalPrice > 0) {
  //     final options = {
  //       'key': 'rzp_test_KmPzyFK6pErbkC',
  //       'amount': (totalPrice * 100).toInt(),
  //       'name': 'Grcoery',
  //       'description': 'Pay For Checkout',
  //       'prefill': {'contact': repository.user.phoneNumber}
  //     };

  //     _razorpay.open(options);
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
  //         (PaymentSuccessResponse res) {
  //       print("Payment Success");
  //       print(res.orderId);
  //       _order(
  //         products: products,
  //         total: total,
  //         totalPrice: totalPrice,
  //         items: items,
  //         paid: true,
  //         onOrder: onOrder,
  //         paymentId: res.paymentId,
  //       );
  //       _razorpay.clear();
  //     });
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (res) {
  //       _razorpay.clear();
  //     });
  //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
  //         (ExternalWalletResponse res) {
  //       print(res.walletName);
  //       _razorpay.clear();
  //     });
  //   } else if (totalPrice == 0) {
  //     _order(
  //       products: products,
  //       total: total,
  //       totalPrice: totalPrice,
  //       items: items,
  //       paid: true,
  //       onOrder: onOrder,
  //     );
  //   } else {
  //     _order(
  //       products: products,
  //       total: total,
  //       totalPrice: totalPrice,
  //       items: items,
  //       paid: false,
  //       onOrder: onOrder,
  //     );
  //   }
  // }

  // void _order({
  //   required List<OrderProduct> products,
  //   required double total,
  //   required double totalPrice,
  //   required int items,
  //   required bool paid,
  //   required VoidCallback onOrder,
  //   String? paymentId,
  // }) async {
  //   final Order order = Order(
  //     id: '',
  //     customerName: profile.name,
  //     customerMobile: profile.mobile,
  //     deliveryCharge: deliveryCharge,
  //     price: total,
  //     products: products,
  //     code: _getCode(6),
  //     total: totalPrice,
  //     location: geoPoint!,
  //     deliveryDate: date!,
  //     deliveryBy: deliveyBy!,
  //     status: OrderStatus.Ordered,
  //     walletAmount: walletAmount,
  //     paymentMethod: paymentMethod!,
  //     paid: paid,
  //     createdOn: DateTime.now(),
  //     customerId: profile.id,
  //     items: items,
  //     paymentId: paymentId,
  //   );
  //   print("Order");
  //   try {
  //     await repository.order(order);
  //     onOrder();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
