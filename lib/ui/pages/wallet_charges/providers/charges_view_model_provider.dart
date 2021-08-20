import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/charge.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chargesViewModelProvider = ChangeNotifierProvider<ChargesViewModel>(
  (ref) {
    final model = ChargesViewModel(ref);
    model.getProducts();
    return model;
  },
);

class ChargesViewModel extends ChangeNotifier {
  final ProviderReference ref;
  ChargesViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider);

  List<QueryDocumentSnapshot> _snapshots = [];

  List<Charge> get charges =>
      _snapshots.map((e) => Charge.fromFirestore(e)).toList();

  Future<void> getProducts() async {
    try {
      _snapshots = await _repository.getCharges();
      print(_snapshots.length);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool loading = true;
  bool busy = false;
  Future<void> getProductsMore() async {
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _repository.getCharges(limit: 6, last: _snapshots.last);
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
