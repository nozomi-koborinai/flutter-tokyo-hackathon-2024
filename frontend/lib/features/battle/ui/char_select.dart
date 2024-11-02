import 'package:flutter/material.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/member_list.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/common/player_info.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/player_intro1.dart';

class CharacterSelectScreen extends StatelessWidget {
  const CharacterSelectScreen({
    super.key,
    required this.members,
  });

  final List<String> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberList(members: members),

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
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('キャラ画像'),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PlayerIntro1(
                          uid: '',
                        ),
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
  }
}
