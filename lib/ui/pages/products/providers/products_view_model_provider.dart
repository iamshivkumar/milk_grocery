import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsViewModelProvider =
    ChangeNotifierProvider.family<ProductsViewModel, String>(
  (ref, category) {
    final model = ProductsViewModel(category);
    model.getProducts();
    return model;
  },
);

class ProductsViewModel extends ChangeNotifier {
  final String category;
  ProductsViewModel(this.category);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _snapshots = [];
  List<Product> get products =>
      _snapshots.map((e) => Product.fromFirestore(e)).toList();

  Future<void> getProducts() async {
    _snapshots = await _firestore
        .collection("products")
        .where("active", isEqualTo: true)
        .where("category", isEqualTo: category)
        .orderBy("name")
        .limit(6)
        .get()
        .then((value) => value.docs);
    notifyListeners();
  }

  bool loading = true;
  bool busy = false;
  Future<void> getProductsMore() async {
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _firestore
              .collection("products")
              .where("active", isEqualTo: true)
              .where("category", isEqualTo: category)
              .orderBy("name")
              .startAfterDocument(_snapshots.last)
              .limit(4)
              .get()
              .then((value) {
            return value.docs;
          });
      if (_snapshots.length == previous.length) {
        loading = false;
      } else {
        loading = true;
      }
    } catch (e) {
      print(e.toString());
    }
    busy = false;
    notifyListeners();
  }
}
