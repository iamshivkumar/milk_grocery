import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_product.dart';

class Profile {
  final String id;
  final String name;
  final String mobile;
  final String? area;
  final String? number;
  final String? landMark;
  final String? milkManId;
  final List<CartProduct> cartProducts;
  final double walletAmount;

  Profile({
    required this.id,
    required this.name,
    required this.mobile,
    this.area,
    this.number,
    this.milkManId,
    required this.cartProducts,
    required this.walletAmount,
    this.landMark,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'area': area,
      'number': number,
      'milkManId': milkManId,
      'cartProducts': cartProducts.map((x) => x.toMap()).toList(),
      'walletAmount': walletAmount,
      'landMark': landMark,
    };
  }

  bool get ready => area != null && number != null && milkManId != null;

  Profile copyWith({
    String? name,
    String? mobile,
    GeoPoint? location,
    String? area,
    String? number,
    String? milkManId,
    List<CartProduct>? cartProducts,
    double? walletAmount,
    String? landMark,
  }) {
    return Profile(
      id: this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      milkManId: milkManId ?? this.milkManId,
      area: area ?? this.area,
      number: number ?? this.number,
      cartProducts: cartProducts ?? this.cartProducts,
      walletAmount: walletAmount ?? this.walletAmount,
      landMark: landMark ?? this.landMark,
    );
  }

  Map<String, dynamic> toAddressMap() {
    return {
      'milkManId': milkManId,
      'area': area,
      'number': number,
      'landMark': landMark,
    };
  }

  Map<String, dynamic> toDeliveryAddressMap() {
    return {
      'area': area,
      'number': number,
      'landMark': landMark,
    };
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final Iterable carts = map["cartProducts"];
    return Profile(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      milkManId: map['milkManId'],
      area: map['area'],
      number: map['number'],
      cartProducts: carts.map((e) => CartProduct.fromMap(e)).toList(),
      walletAmount: map['walletAmount'],
      landMark: map['landMark'],
    );
  }

  factory Profile.empty() => Profile(
        id: '',
        name: '',
        mobile: '',
        cartProducts: [],
        walletAmount: 0,
      );

  bool isInCart(String id, int index) => cartProducts
      .where((element) => element.id == id && element.optionIndex == index)
      .isNotEmpty;
  bool isInCartO(String id) =>
      cartProducts.where((element) => element.id == id).isNotEmpty;
  int cartQuanity(String id) => cartProduct(id).qt;
  int cartQuanityM(String id, int index) => cartProducts
      .where((element) => element.id == id && element.optionIndex == index)
      .first
      .qt;

  int cartOptionIndex(String id) => cartProduct(id).optionIndex;

  void addToCart({required String id, int? index}) {
    cartProducts.add(
      CartProduct(id: id, qt: 1, optionIndex: index ?? 0),
    );
  }

  CartProduct cartProduct(String id) =>
      cartProducts.where((element) => element.id == id).first;

  void updateIndex(
      {required String id, required int index, required int quantity}) {
    cartProducts.where((element) => element.id == id).first.optionIndex = index;
    if (cartProducts.where((element) => element.id == id).first.qt > quantity) {
      cartProducts.where((element) => element.id == id).first.qt = quantity;
    }
  }

  void updateCartQuantity(String id, int qt) {
    if (cartQuanity(id) == 1 && qt == -1) {
      cartProducts.removeWhere((element) => element.id == id);
    } else {
      cartProduct(id).qt += qt;
    }
  }

  void updateCartQuantityM(String id, int qt, int index) {
    if (cartProducts.where(
          (element) => element.id == id && element.optionIndex == index).first.qt == 1 && qt == -1) {
      cartProducts.removeWhere(
          (element) => element.id == id && element.optionIndex == index);
    } else {
      cartProducts
          .where((element) => element.id == id && element.optionIndex == index)
          .first
          .qt += qt;
    }
  }

  void removeFromCart(String id) {
    cartProducts.removeWhere((element) => element.id == id);
  }

  void removeFromCartM(String id, int index) {
    cartProducts.removeWhere(
        (element) => element.id == id && element.optionIndex == index);
  }
}
