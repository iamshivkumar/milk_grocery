import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/models/banner.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';

final bannersProvider = FutureProvider<List<BannerModel>>(
  (ref) => ref.read(repositoryProvider).futureBanners,
);
