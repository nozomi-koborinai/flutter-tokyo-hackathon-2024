import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/utils/page_navigator.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/player_intro1.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';

class CharacterSelectScreen extends ConsumerWidget {
  const CharacterSelectScreen({
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
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemberList(
                  uid: uid,
                  room: room,
                ),

                const SizedBox(height: 20),

                // メインタイトル
                const Center(
                  child: Text(
                    'お前が戦うキャラクターは\nこいつです',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // キャラクター画像プレースホルダー
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: currentUser.characterImageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      currentUser.characterImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text('キャラ画像がありません'),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ボタン行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('再度キャラ生成\n※あと○回'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // CharacterSelectScreenへ遷移
                        PageNavigator.push(
                          context,
                          PlayerIntro1(
                            uid: uid,
                            room: room,
                          ),
                        );
                      },
                      child: const Text('このキャラで戦う'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // プレイヤー情報
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayerInfo(
                      playerName: 'Player1',
                      currentHp: 30,
                      maxHp: 30,
                    ),
                    PlayerInfo(
                      playerName: 'Player2',
                      currentHp: 30,
                      maxHp: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const OverlayLoading(),
    );
  }
}
