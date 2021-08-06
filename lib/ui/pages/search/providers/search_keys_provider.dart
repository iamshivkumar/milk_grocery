import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchKeysProvder = FutureProvider<List<String>>((ref) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore
      .collection("search_keys")
      .doc("search_keys")
      .get()
      .then((value) {
    Iterable keys = value.data()!["keys"];
    return keys.cast<String>().toList();
  });
});
