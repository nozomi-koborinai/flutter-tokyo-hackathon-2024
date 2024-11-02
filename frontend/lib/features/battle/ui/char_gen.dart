import 'package:flutter/material.dart';

class CharacterGenerationScreen extends StatelessWidget {
  const CharacterGenerationScreen({
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
            // メンバーリスト
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
                  ...members.map((member) => Text('・$member')),
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

            const Spacer(), // 空きスペースを作成

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'プレイヤー名',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        'たろう', // TODO: 実際のプレイヤー名に置き換え
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'HP',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        '100 / 100', // TODO: 実際のHP値に置き換え
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
