import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/category.dart';
import '../../../../core/providers/repository_provider.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>(
  (ref) => ref.read(repositoryProvider).futureCategories,
);
