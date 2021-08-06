import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/profile.dart';
import '../../../core/repository/repository_provider.dart';

final profileProvider = StreamProvider<Profile>(
  (ref) {
    final repository = ref.read(repositoryProvider);
    return repository.profileStream;
  },
);
