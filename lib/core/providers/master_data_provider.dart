
import 'package:grocery_app/core/models/master_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository_provider.dart';

final masterdataProvider = StreamProvider<Masterdata>((ref)=>ref.read(repositoryProvider).masterdataStream);