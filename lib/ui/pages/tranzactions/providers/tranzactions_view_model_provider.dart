import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/tranzaction.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final tranzactionsViewModelProvider =
    ChangeNotifierProvider<TranzactionsViewModel>(
  (ref) {
    final model = TranzactionsViewModel(ref);
    model.getProducts();
    return model;
  },
);

class TranzactionsViewModel extends ChangeNotifier {
  final ProviderReference ref;
  TranzactionsViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider); 

  List<QueryDocumentSnapshot> _snapshots = [];

  List<Tranzaction> get tranzactions =>
      _snapshots.map((e) => Tranzaction.fromFirestore(e)).toList();

  Future<void> getProducts() async {
    try {
      _snapshots = await _repository.getTranzactions();
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
          await _repository.getTranzactions(limit: 6,last: _snapshots.last);
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
