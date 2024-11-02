import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/player_intro2.dart';

class PlayerIntro1 extends HookConsumerWidget {
  const PlayerIntro1({super.key, required this.uid, required this.room});

  final String uid;
  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleUsersAsyncValue = ref.watch(subscribeBattleUsersProvider(room));
    useEffect(() {
      final timer = Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlayerIntro2(
              uid: uid,
              room: room,
            ),
          ),
        );
      });
      return () => timer.ignore();
    }, []);
    return battleUsersAsyncValue.when(
      data: (users) {
        final currentUser = users.firstWhere((user) => user.uid == uid);
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

                // メインのキャラクター画像
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
