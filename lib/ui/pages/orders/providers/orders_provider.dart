import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/order.dart';
import '../../../../core/providers/repository_provider.dart';


final ordersProvider = StreamProvider<List<Order>>((ref){
  final repository = ref.read(repositoryProvider);
  return repository.ordersStream;
});

