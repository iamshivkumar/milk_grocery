import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';

final popularProductsProvider = FutureProvider<List<Product>>(
  (ref) => ref.read(repositoryProvider).popularProductsFuture(),
);
