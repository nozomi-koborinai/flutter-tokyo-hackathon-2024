import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/utils/page_navigator.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_card.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/player_wait.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/create_room_usecase.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_rooms.dart';

class BattleRoom extends ConsumerWidget {
  const BattleRoom({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribeRooms = ref.watch(subscribeRoomsProvider);

    return Scaffold(
      body: SafeArea(
        child: subscribeRooms.when(
          data: (rooms) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final createdRoom = await ref
                        .read(createRoomUsecaseProvider)
                        .invoke(uid: uid);
                    PageNavigator.push(
                      context,
                      PlayerWaitScreen(
                        uid: uid,
                        roomId: createdRoom.roomId,
                      ),
                    );
                  },
                  child: const Text(
                    'ルーム作成',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: rooms.isEmpty
                    ? const Center(child: Text('ルームがありません'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          return PlayerCard(uid: uid, room: room);
                        },
                      ),
              ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const OverlayLoading(),
        ),
      ),
    );
  }
}
