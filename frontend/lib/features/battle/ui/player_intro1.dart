import 'package:flutter/material.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';

class PlayerIntro1 extends StatelessWidget {
  const PlayerIntro1({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: MemberList(members: ['Player1', 'Player2']),
            ),
          ),

          // メインのキャラクター画像
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
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
    );
  }
}
