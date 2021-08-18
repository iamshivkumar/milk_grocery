import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/core/models/order_product.dart';
import 'package:grocery_app/enums/order_status.dart';
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
    final batch = _firestore.batch();
    final ref = _firestore.collection('orders').doc();
    batch.set(ref, order.toMap(map: map));
    batch.update(_firestore.collection('users').doc(order.customerId), {
      'cartProducts': [],
      'walletAmount': FieldValue.increment(-order.walletAmount),
    });
    for (var item in order.products) {
      batch.update(_firestore.collection('products').doc(item.id), {
        'quantity': FieldValue.increment(-item.qt),
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

  void addWalletAmount({required double amount}) {
    _firestore.collection('users').doc(user.uid).update({
      'walletAmount': FieldValue.increment(amount),
    });
  }

  void cancelOrder(
      {required double price,
      required String orderId,
      required List<OrderProduct> products}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(orderId), {
      'status': OrderStatus.cancelled,
    });
    batch.update(_firestore.collection('users').doc(user.uid), {
      'walletAmount': FieldValue.increment(price),
    });
    for (var item in products) {
      batch.update(_firestore.collection('products').doc(item.id), {
        'quantity': FieldValue.increment(item.qt),
      });
    }
    batch.commit();
  }
}
