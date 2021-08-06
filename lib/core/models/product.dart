import 'package:cloud_firestore/cloud_firestore.dart';

import 'option.dart';

class Product {
  final String id;
  final String name;
  final List<Option> options;
  final List<String> images;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'description': description,
      'options': options,
    };
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final Iterable list = map['options'];
    final List<Option> optionlist = list.map((e) => Option.fromMap(e)).toList();
    optionlist.sort((a,b)=>a.price.compareTo(b.price));
    return Product(
      id: doc.id,
      name: map['name'],
      images: List<String>.from(map['images']),
      description: map['description'],
      options: optionlist,
    );
  }
}
