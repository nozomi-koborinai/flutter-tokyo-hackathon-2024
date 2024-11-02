import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';

class MemberList extends ConsumerWidget {
  const MemberList({
    super.key,
    required this.uid,
    required this.room,
  });

  final String uid;
  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleUsersAsyncValue = ref.watch(subscribeBattleUsersProvider(room));
    return battleUsersAsyncValue.when(
      data: (users) {
        final currentUser = users.firstWhere((user) => user.uid == uid);
        final otherUser = users.firstWhere((user) => user.uid != uid);
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'メンバー',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...[currentUser.userName, otherUser.userName]
                  .map((member) => Text('・$member')),
            ],
          ),
        );
      },
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const OverlayLoading(),
    );
  }
}
