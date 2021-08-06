import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/models/category.dart';
import 'package:grocery_app/core/repository/repository_provider.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>(
  (ref) => ref.read(repositoryProvider).futureCategories,
);
