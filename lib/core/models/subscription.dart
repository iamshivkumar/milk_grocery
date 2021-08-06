import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/core/models/option.dart';

class Subscrption {
  final String id;
  final String customerId;
  final String productId;
  final String productName;
  final Option option;
  final DateTime startDate;
  final DateTime endDate;
  final String deliveryDay;

  Subscrption({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.option,
    required this.startDate,
    required this.endDate,
    required this.deliveryDay,
  });

  Subscrption copyWith({
    String? customerId,
    String? productId,
    String? productName,
    Option? option,
    DateTime? startDate,
    DateTime? endDate,
    String? deliveryDay,
  }) {
    return Subscrption(
      id: this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      option: option ?? this.option,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deliveryDay: deliveryDay ?? this.deliveryDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'productId': productId,
      'productName': productName,
      'option': option.toMap(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'deliveryDay': deliveryDay,
    };
  }

  factory Subscrption.fromMap(DocumentSnapshot doc) {
   final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Subscrption(
      id: doc.id,
      customerId: map['customerId'],
      productId: map['productId'],
      productName: map['productName'],
      option: Option.fromMap(map['option']),
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      deliveryDay: map['deliveryDay'],
    );
  }
}

class DeliveryDay {
  static const String everyday = "Everyday";
  static const String alternateDay = "Alternate Day";
  static const String every3Day = "Every 3 Day";
  static const String every7Day = "Every 7 Day";

  static const List<String> values = [
    everyday,
    alternateDay,
    every3Day,
    every7Day
  ];
}
