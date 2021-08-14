import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product.dart';
import '../../../../core/providers/repository_provider.dart';

final popularProductsProvider = FutureProvider<List<Product>>(
  (ref) => ref.read(repositoryProvider).popularProductsFuture(),
);
