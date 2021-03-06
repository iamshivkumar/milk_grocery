import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/delivery.dart';
import '../../../../core/models/option.dart';
import '../../../../core/models/product.dart';
import '../../../../core/models/profile.dart';
import '../../../../core/models/subscription.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/repository_provider.dart';
import '../../../../enums/order_status.dart';
import '../../../../enums/subscription_status.dart';

final subscribeViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => SubscribeViewModel(ref),
);

class SubscribeViewModel extends ChangeNotifier {
  final ProviderReference ref;
  SubscribeViewModel(this.ref);

  Profile get _profile => ref.read(profileProvider).data!.value;
  Repository get _repository => ref.read(repositoryProvider);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Option? _option;

  Option? get option => _option;
  set option(Option? option) {
    _option = option;
    notifyListeners();
  }

  int _quantity = 1;

  int get quantity => _quantity;

  set quantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  String? _deliveryDay;
  String? get deliveryDay => _deliveryDay;
  set deliveryDay(String? deliveryDay) {
    _deliveryDay = deliveryDay;
    notifyListeners();
  }

  DateTime get _endDate => startDate!.add(Duration(days: 30));

  bool get ready =>
      _option != null && _startDate != null && _deliveryDay != null;

  void subscribe(
      {required Product product, required VoidCallback onSubscribe}) async {
    loading = true;
    final subscription = Subscription(
      id: '',
      customerId: _profile.id,
      customerName: _profile.name,
      customerMobile: _profile.mobile,
      productId: product.id,
      productName: product.name,
      option: option!,
      startDate: startDate!,
      endDate: _endDate,
      deliveryDay: deliveryDay!,
      deliveries: _generateDeliveries(),
      milkManId: _profile.milkManId!,
      image: product.images.first,
      status: SubscriptionStatus.active,
    );

    try {
      await _repository.subscribe(
        subscription: subscription,
        map: _profile.toDeliveryAddressMap(),
      );
      onSubscribe();
    } catch (e) {}

    loading = false;
  }

  List<DateTime> get dates {
    if (startDate == null || deliveryDay == null) {
      return [];
    } else {
      final List<DateTime> dates = [];
      var start = startDate!;
      while (start.isBefore(_endDate)) {
        dates.add(start);
        start = start.add(
          Duration(
            days: DeliveryDay.interval(deliveryDay!),
          ),
        );
      }
      return dates;
    }
  }

  List<Delivery> _generateDeliveries() {
    final List<Delivery> deliveries = [];
    var start = startDate!;
    while (start.isBefore(_endDate)) {
      deliveries.add(
        Delivery(
          date: start,
          quantity: quantity,
          status: OrderStatus.pending,
        ),
      );
      start = start.add(
        Duration(
          days: DeliveryDay.interval(deliveryDay!),
        ),
      );
    }
    return deliveries;
  }
}
