import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/char_gen.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_room.dart';

class PlayerWaitScreen extends ConsumerWidget {
  const PlayerWaitScreen({super.key, required this.uid, required this.roomId});

  final String uid;
  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsyncValue = ref.watch(subscribeRoomProvider(roomId));
    return roomAsyncValue.when(
      data: (room) {
        // pairUidが空でない場合は、CharacterGenerationPage に遷移
        if (room.pairUid.isNotEmpty) {
          // 遷移後に前の画面に戻れないようにするため pushReplacement を使用
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterGenerationPage(
                  uid: uid,
                  room: room,
                ),
              ),
            );
          });
        }

        // pairUidが空の場合は、待機画面を表示
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  'プレイヤーの参加を待っています...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('キャンセル'),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const OverlayLoading(),
    );
  }
}
