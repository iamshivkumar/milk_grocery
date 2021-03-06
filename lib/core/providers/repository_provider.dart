import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/core/models/charge.dart';
import 'package:grocery_app/core/models/master_data.dart';
import 'package:grocery_app/core/models/order_product.dart';
import 'package:grocery_app/core/models/tranzaction.dart';
import 'package:grocery_app/enums/order_status.dart';
import 'package:grocery_app/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/dates.dart';
import '../models/banner.dart';
import '../models/cart_product.dart';
import '../models/category.dart';
import '../models/delivery.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/profile.dart';
import '../models/subscription.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

class Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  Stream<Profile> get profileStream =>
      _firestore.collection("users").doc(user.uid).snapshots().map(
            (event) => Profile.fromFirestore(event),
          );

  void updateName(String name) {
    _firestore.collection("users").doc(user.uid).update(
      {
        "name": name,
      },
    );
  }

  void createUser(String name) {
    _firestore.collection("users").doc(user.uid).set(
          Profile(
            id: '',
            cartProducts: [],
            mobile: user.phoneNumber!,
            name: name,
            walletAmount: 0,
          ).toMap(),
        );
  }

  void addDeliveryAddress(Profile profile) {
    _firestore
        .collection('users')
        .doc(profile.id)
        .update(profile.toAddressMap());
  }

  Future<List<ProductCategory>> get futureCategories {
    return _firestore
        .collection('categories')
        .doc('categories')
        .get()
        .then((value) {
      final Iterable list = value.data()!['categories'];
      return list.map((e) => ProductCategory.fromMap(e)).toList();
    });
  }

  Future<List<Product>> popularProductsFuture() async {
    return _firestore
        .collection("products")
        .where("active", isEqualTo: true)
        .where("popular", isEqualTo: true)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Product.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<List<Product>> categoryProductsFuture(String category) async {
    return _firestore
        .collection("products")
        .where("active", isEqualTo: true)
        .where("category", isEqualTo: category)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Product.fromFirestore(e),
              )
              .toList(),
        );
  }

  void saveCart(List<CartProduct> products) {
    _firestore.collection("users").doc(user.uid).update(
      {
        "cartProducts": products.map((e) => e.toMap()).toList(),
      },
    );
  }

  Future<Product> readProduct(String id) async {
    return _firestore.collection('products').doc(id).get().then(
          (value) => Product.fromFirestore(value),
        );
  }

  Future<void> order(
      {required Map<String, dynamic> map, required Order order}) async {
    late int number;
    try {
      number = await _firestore
          .collection('dates')
          .doc(Dates.today.toString())
          .get()
          .then((value) => value.data()!['value']);
    } catch (e) {
      number = 1;
    }
    _firestore
        .collection('dates')
        .doc(Dates.today.toString())
        .set({"value": number + 1});
    final batch = _firestore.batch();
    final ref = _firestore.collection('orders').doc();
    batch.set(
        ref,
        order
            .copyWith(orderId: Utils.dateId() + number.toString())
            .toMap(map: map));
    batch.update(_firestore.collection('users').doc(order.customerId), {
      'cartProducts': [],
      'walletAmount': FieldValue.increment(-order.walletAmount),
    });
    if (order.total > 0) {
      batch.set(
        _firestore.collection('tranzactions').doc(),
        Tranzaction(
          amount: order.total,
          name: order.customerName,
          uid: order.customerId,
          createdAt: Dates.now,
          id: '',
          paymentId: order.paymentId,
          type: TranzactionType.whileOrdering,
        ).toMap(),
      );
    }
    if (order.walletAmount > 0) {
      batch.set(
        _firestore.collection('charges').doc(),
        Charge(
          amount: order.walletAmount,
          from: user.uid,
          to: null,
          ids: [user.uid],
          type: ChargesType.whileOrder,
          createdAt: DateTime.now(),
        ).toMap(),
      );
    }
    for (var item in order.products.where((element) => !element.isMilky)) {
      _firestore.collection('products').doc(item.id).get().then((value) {
        final product = Product.fromFirestore(value);
        product.options
            .where((element) => element.amountLabel == item.amountLabel)
            .first
            .increment(-item.qt);
        final option = product.options
            .where((element) => element.amountLabel == item.amountLabel)
            .first;
        if (option.quantity < 2) {
          _firestore.collection("stockNotice").doc('stockNotice').update({
            "values": FieldValue.arrayUnion(
                ["${product.name} - ${option.amountLabel}"])
          });
        }
        _firestore.collection('products').doc(item.id).update({
          'options': product.options.map((e) => e.toMap()).toList(),
        });
      });
    }
    batch.commit();
  }

  Stream<List<Order>> get ordersStream => _firestore
      .collection('orders')
      .where('customerId', isEqualTo: user.uid)
      .where(
        'createdOn',
        isGreaterThanOrEqualTo: Dates.today.subtract(
          Duration(days: 7),
        ),
      )
      .orderBy('createdOn', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Order.fromFirestore(e),
            )
            .toList(),
      );

  Future<List<BannerModel>> get futureBanners {
    return _firestore.collection('banners').doc('banners').get().then((value) {
      final Iterable list = value.data()!['banners'];
      return list.map((e) => BannerModel.fromMap(e)).toList();
    });
  }

  Future<void> subscribe(
      {required Subscription subscription,
      required Map<String, dynamic> map}) async {
    await _firestore
        .collection('subscription')
        .add(subscription.toMap(map: map));
  }

  Stream<List<Subscription>> get subscriptionsStream => _firestore
      .collection('subscription')
      .where('customerId', isEqualTo: user.uid)
      .where(
        'startDate',
        isGreaterThanOrEqualTo: Dates.today.subtract(
          Duration(days: 30),
        ),
      )
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Subscription.fromFirestore(e),
            )
            .toList(),
      );

  void updateSubScriptionStatus({required String status, required String id}) {
    _firestore.collection('subscription').doc(id).update({
      'status': status,
    });
  }

  Future<List<String>> getAreas(String mobile) async {
    final data = await _firestore
        .collection('milkMans')
        .where('mobile', isEqualTo: mobile)
        .get();
    if (data.docs.isEmpty) {
      return Future.error("Milk man not exists.");
    } else {
      return data.docs.first.data()['areas'].cast<String>();
    }
  }

  void addAddress(Profile profile) {
    _firestore
        .collection('users')
        .doc(profile.id)
        .update(profile.toAddressMap());
  }

  void saveDeliveries(
      {required String id, required List<Delivery> deliveries}) {
    _firestore.collection('subscription').doc(id).update({
      'deliveries': deliveries.map((e) => e.toMap()).toList(),
    });
  }

  void addWalletAmount(
      {required double amount,
      required double extra,
      required String name,
      required String uid,
      required String? paymentId}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('users').doc(user.uid), {
      'walletAmount': FieldValue.increment(amount + extra),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount + extra,
        from: null,
        to: user.uid,
        ids: [user.uid],
        type: TranzactionType.whileWalletRecharge,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.set(
      _firestore.collection('tranzactions').doc(),
      Tranzaction(
        amount: amount,
        name: name,
        uid: uid,
        createdAt: Dates.now,
        id: '',
        paymentId: paymentId,
        type: TranzactionType.whileWalletRecharge,
      ).toMap(),
    );
    batch.commit();
  }

  void cancelOrder(
      {required double price,
      required String orderId,
      required List<OrderProduct> orderProducts}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(orderId), {
      'status': OrderStatus.cancelled,
    });
    batch.update(_firestore.collection('users').doc(user.uid), {
      'walletAmount': FieldValue.increment(price),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: price,
        from: null,
        to: user.uid,
        ids: [user.uid],
        type: ChargesType.whileCancelOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    for (var item in orderProducts.where((element) => !element.isMilky)) {
      _firestore.collection('products').doc(item.id).get().then((value) {
        final product = Product.fromFirestore(value);
        product.options
            .where((element) => element.amountLabel == item.amountLabel)
            .first
            .increment(item.qt);
        _firestore.collection('products').doc(item.id).update({
          'options': product.options.map((e) => e.toMap()).toList(),
        });
      });
    }
    batch.commit();
  }

  Future<List<QueryDocumentSnapshot>> getTranzactions(
      {int limit = 10, DocumentSnapshot? last}) async {
    Query ref = _firestore
        .collection('tranzactions')
        .where("uid", isEqualTo: user.uid)
        .limit(limit);
    if (last != null) {
      ref = ref.startAfterDocument(last);
    }
    return await ref.get().then((value) => value.docs);
  }

  Future<List<QueryDocumentSnapshot>> getCharges(
      {int limit = 10, DocumentSnapshot? last}) async {
    Query ref = _firestore
        .collection('charges')
        .where("ids", arrayContains: user.uid)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      ref = ref.startAfterDocument(last);
    }
    return await ref.get().then((value) => value.docs);
  }

  void requestForRefundOrder({required String id, required String reason}) {
    _firestore.collection('orders').doc(id).update({
      'status': OrderStatus.requestedForRefund,
      'refundReason': reason,
    });
  }

  Stream<Masterdata> get masterdataStream =>
      _firestore.collection('masterData').doc('masterData_v1').snapshots().map(
            (event) => Masterdata.fromMap(event),
          );

}
