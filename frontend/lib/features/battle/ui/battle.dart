import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/char_gen.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/draw.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/lose.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/winner.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/subscribe_batlle_users_provider.dart';

class BattleScreen extends ConsumerWidget {
  const BattleScreen({
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

        // バトル終了時に4秒後に画面遷移
        if (currentUser.hitPoint <= 0 || otherUser.hitPoint <= 0) {
          Future.delayed(const Duration(seconds: 4), () {
            if (currentUser.hitPoint <= 0 && otherUser.hitPoint <= 0) {
              // Draw
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Draw(
                    uid: uid,
                    room: room,
                  ),
                ),
              );
            } else if (currentUser.hitPoint <= 0) {
              // Lose
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Lose(room: room, uid: uid),
                ),
              );
            } else {
              // Win
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Winner(room: room, uid: uid),
                ),
              );
            }
          });
        } else {
          // 両者のHPが0より大きい場合は4秒後にキャラクター生成画面へ
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
        }

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
                        // 現在のユーザーのキャラクター
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
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
                                          'キャラ画像がありません',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                              if (currentUser.hitPoint <= 0 ||
                                  otherUser.hitPoint <= 0)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getBattleResult(
                                        currentUserHp: currentUser.hitPoint,
                                        otherUserHp: otherUser.hitPoint,
                                        isCurrentUser: true,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 相手のキャラクター
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
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
                                          'キャラ画像がありません',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                              if (currentUser.hitPoint <= 0 ||
                                  otherUser.hitPoint <= 0)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getBattleResult(
                                        currentUserHp: currentUser.hitPoint,
                                        otherUserHp: otherUser.hitPoint,
                                        isCurrentUser: false,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // プレイヤー情報
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
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const OverlayLoading(),
    );
  }

  /// バトル結果のテキストを取得
  String _getBattleResult({
    required int currentUserHp,
    required int otherUserHp,
    required bool isCurrentUser,
  }) {
    if (currentUserHp <= 0 && otherUserHp <= 0) {
      return 'DRAW';
    }

    if (isCurrentUser) {
      return currentUserHp <= 0 ? 'LOSE' : 'WIN';
    } else {
      return otherUserHp <= 0 ? 'LOSE' : 'WIN';
    }
  }
}
