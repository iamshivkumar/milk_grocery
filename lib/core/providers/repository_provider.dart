import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/core/models/banner.dart';
import 'package:grocery_app/core/models/cart_product.dart';
import 'package:grocery_app/core/models/category.dart';
import 'package:grocery_app/core/models/order.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:grocery_app/core/models/profile.dart';
import 'package:grocery_app/core/models/subscription.dart';
import 'package:grocery_app/utils/dates.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

class Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  Future<void> createProfile() async {
    final profile = Profile.empty().copyWith(
      mobile: user.phoneNumber!,
      name: user.displayName!,
    );
    _firestore.collection("users").doc(user.uid).set(profile.toMap());
  }

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
    _auth.currentUser!.updateDisplayName(name);
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

  Future<void> order(Order order) async {
    final batch = _firestore.batch();
    final ref = _firestore.collection('orders').doc();
    batch.set(ref, order.toMap());
    batch.update(_firestore.collection('users').doc(order.customerId), {
      'cartProducts': [],
    });
    batch.commit();
  }

  Stream<List<Order>> get ordersStream => _firestore
      .collection('orders')
      .where('customerId', isEqualTo: user.uid)
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

  Future<void> subscribe(Subscription subscription) async {
    await _firestore.collection('subscription').add(subscription.toMap());
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
}
