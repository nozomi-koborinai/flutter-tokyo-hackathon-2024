import 'package:flutter/material.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/player_wait.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/char_gen.dart';

class BattleRoom extends StatelessWidget {
  const BattleRoom({super.key, required String uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦ルーム'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerWaitScreen(),
                  ),
                );
              },
              child: const Text(
                'ルーム作成',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            _buildPlayerCard('player1'),
            const SizedBox(height: 20),
            _buildPlayerCard('player2'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CharacterGenerationScreen(
                      members: ['プレイヤー1', 'プレイヤー2'], // 仮のメンバーリスト
                    ),
                  ),
                );
              },
              child: const Text(
                'キャラクターを生成する',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(String playerName) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          playerName,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // TODO: 対戦ボタンのロジックを実装
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text(
            '対戦',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
