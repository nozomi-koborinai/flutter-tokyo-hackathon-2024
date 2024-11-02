import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/char_gen.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';

class BattleScreen extends ConsumerWidget {
  const BattleScreen({super.key, required this.uid, required this.room});

  final String uid;
  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleUsersAsyncValue = ref.watch(subscribeBattleUsersProvider(room));
    // 4秒後にCharacterGenerationPageに遷移
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CharacterGenerationPage(
            uid: uid,
            room: room,
          ),
        ),
      );
    });

    return battleUsersAsyncValue.when(
      data: (users) {
        final currentUser = users.firstWhere((user) => user.uid == uid);
        final otherUser = users.firstWhere((user) => user.uid != uid);
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MemberList(
                      uid: uid,
                      room: room,
                    ),
                  ),
                ),

                // メインのキャラクター画像（2分割）
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: currentUser.characterImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      currentUser.characterImageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'キャラ画像',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: otherUser.characterImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      otherUser.characterImageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'キャラ画像',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
