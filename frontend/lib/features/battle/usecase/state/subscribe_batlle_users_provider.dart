import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/model/app_user.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:rxdart/rxdart.dart';

/// バトルに参加する2人のユーザー情報を監視する
final subscribeBattleUsersProvider = StreamProvider.family<List<AppUser>, Room>(
  (ref, room) {
    final userRepository = ref.watch(userRepositoryProvider);

    // 両方のユーザーのStreamを組み合わせる
    return Rx.combineLatest2(
      userRepository.subscribe(room.uid),
      userRepository.subscribe(room.pairUid),
      (AppUser user1, AppUser user2) => [user1, user2],
    );
  },
);
