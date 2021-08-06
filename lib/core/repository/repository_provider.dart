import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository.dart';

final repositoryProvider = Provider<Repository>((ref)=>Repository());