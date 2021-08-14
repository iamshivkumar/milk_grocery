import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/banner.dart';
import '../../../../core/providers/repository_provider.dart';

final bannersProvider = FutureProvider<List<BannerModel>>(
  (ref) => ref.read(repositoryProvider).futureBanners,
);
