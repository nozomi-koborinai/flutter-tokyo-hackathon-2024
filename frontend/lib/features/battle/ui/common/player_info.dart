import 'package:flutter/material.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({
    super.key,
    required this.playerName,
    required this.currentHp,
    required this.maxHp,
  });

  final String playerName;
  final int currentHp;
  final int maxHp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
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
                ),
              ),
              Text(
                playerName,
                style: const TextStyle(
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
                ),
              ),
              Text(
                '$currentHp / $maxHp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: currentHp < maxHp * 0.3 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
