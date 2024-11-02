import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/model/app_user.dart';

/// [AppUser] を取得する [FutureProvider]
final getUserProvider = FutureProvider.family<AppUser, String>(
  (ref, uid) => ref.watch(userRepositoryProvider).get(uid),
);
