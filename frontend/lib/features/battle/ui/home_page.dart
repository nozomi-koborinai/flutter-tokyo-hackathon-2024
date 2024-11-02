import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/utils/page_navigator.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/battle_room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/input_name_usecase.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Generate Wars',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 400),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'プレイヤー名',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'プレイヤー名を入力してください';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 50),
              OutlinedButton(
                onPressed: () async {
                  // 名前入力のユースケースを実行
                  await ref.read(inputNameUsecaseProvider).invoke(
                        uid: uid,
                        userName: nameController.text,
                      );
                  PageNavigator.push(
                    context,
                    BattleRoom(uid: uid),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 180,
                    vertical: 50,
                  ),
                  side: const BorderSide(width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '対戦開始',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
