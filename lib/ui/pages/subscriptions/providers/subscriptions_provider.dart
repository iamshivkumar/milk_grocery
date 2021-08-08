import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subscriptionsProvider = StreamProvider(
  (ref) => ref.read(repositoryProvider).subscriptionsStream,
);
