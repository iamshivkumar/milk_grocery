import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_product.dart';

class Order {
  final String id;
  
  final String orderId;
  final String customerId;
  final String customerName;
  final String customerMobile;
  final String? discount;
  final double price;
  final double walletAmount;
  final double total;
  final String status;
  final bool packed;

  final List<OrderProduct> products;
  final int items;
  final String? milkManId;
  final String paymentMethod;
  final bool paid;
  final String? paymentId;
  final DateTime createdOn;
  final String? refundReason;

  DateTime get deliveryDate => createdOn.add(Duration(days: 1));

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.price,
    required this.walletAmount,
    required this.total,
    required this.status,
    required this.products,
    required this.items,
    this.milkManId,
    required this.paymentMethod,
    required this.paid,
    this.paymentId,
    required this.createdOn,
    this.refundReason,
    required this.orderId,
    this.discount,
    required this.packed,
  });

  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerMobile,
    double? price,
    double? walletAmount,
    String? status,
    List<OrderProduct>? products,
    int? items,
    String? milkManId,
    String? paymentMethod,
    bool? paid,
    String? paymentId,
    DateTime? createdOn,
    double? total,
    String? orderId,
    String? discount,
    bool? packed,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      price: price ?? this.price,
      walletAmount: walletAmount ?? this.walletAmount,
      status: status ?? this.status,
      products: products ?? this.products,
      items: items ?? this.items,
      milkManId: milkManId ?? this.milkManId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paid: paid ?? this.paid,
      paymentId: paymentId ?? this.paymentId,
      createdOn: createdOn ?? this.createdOn,
      total: total ?? this.total,
      orderId: orderId??this.orderId,
      discount: discount??this.discount,
      packed: packed??this.packed,
    );
  }

  Map<String, dynamic> toMap({required Map<String,dynamic> map}) {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerMobile': customerMobile,
      'price': price,
      'walletAmount': walletAmount,
      'status': status,
      'products': products.map((x) => x.toMap()).toList(),
      'items': items,
      'milkManId': milkManId,
      'paymentMethod': paymentMethod,
      'paid': paid,
      'paymentId': paymentId,
      'createdOn': Timestamp.fromDate(createdOn),
      'total': total,
      'address':map,
      'orderId':orderId,
      'discount':discount,
      'packed':packed,
    };
  }

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerMobile: map['customerMobile'],
      price: map['price'],
      walletAmount: map['walletAmount'],
      status: map['status'],
      products: List<OrderProduct>.from(
        map['products'].map(
          (x) => OrderProduct.fromMap(x),
        ),
      ),
      items: map['items'],
      milkManId: map['milkManId'],
      paymentMethod: map['paymentMethod'],
      paid: map['paid'],
      paymentId: map['paymentId'],
      createdOn: map['createdOn'].toDate(),
      total: map['total'],
      refundReason: map['refundReason'],
      orderId: map['orderId'],
      discount: map['discount'],
      packed: map['packed'],
    );
  }
}