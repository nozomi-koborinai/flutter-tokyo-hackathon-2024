import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/state/get_user_provider.dart';

class PlayerCard extends ConsumerWidget {
  const PlayerCard({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(getUserProvider(room.uid));

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: userAsync.when(
        data: (user) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              user.userName,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // roomのデータを使って対戦ロジックを実装
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        ),
        loading: () => const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (error, stack) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('エラー: $error'),
          ),
        ),
      ),
    );
  }
}
