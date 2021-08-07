import 'package:grocery_app/core/models/order.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final ordersProvider = StreamProvider<List<Order>>((ref){
  final repository = ref.read(repositoryProvider);
  return repository.ordersStream;
});

