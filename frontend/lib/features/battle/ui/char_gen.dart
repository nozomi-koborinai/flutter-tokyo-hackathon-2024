import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';

class CharacterGenerationPage extends ConsumerWidget {
  const CharacterGenerationPage({
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

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                      Text('・${currentUser.userName}'),
                      Text('・${otherUser.userName}'),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // メインメッセージ
                const Center(
                  child: Text(
                    '20文字以内で自分が思い描く\n最強のキャラクターを作ろう',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // プロンプト入力フォーム
                TextField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: 'キャラクターの説明を入力',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // キャラクター生成ボタン
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: キャラクター生成処理を実装
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'キャラクターを作る',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const Spacer(),

                // プレイヤー情報ブロック
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlayerInfo(
                        playerName: currentUser.userName,
                        currentHp: currentUser.hitPoint,
                        maxHp: 30,
                      ),
                      PlayerInfo(
                        playerName: otherUser.userName,
                        currentHp: otherUser.hitPoint,
                        maxHp: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(child: Text('エラーが発生しました: $error')),
      ),
      loading: () => const OverlayLoading(),
    );
  }
}