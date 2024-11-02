import 'package:flutter/material.dart';
import 'package:flutter_tokyo_hackathon_2024/core/utils/page_navigator.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/battle_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.uid});
  final String uid;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startBattle(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Firebaseにユーザー情報を保存
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);
      await userDoc.set({
        'name': _nameController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // バトルルームへ遷移
      if (!mounted) return;
      PageNavigator.push(
        context,
        BattleRoom(uid: widget.uid),
      );
    } catch (e) {
      // エラーハンドリング
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('エラーが発生しました。もう一度お試しください。')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'App名',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              // 名前入力フィールドを追加
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 400),
                child: TextFormField(
                  controller: _nameController,
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
                onPressed: () => _startBattle(context),
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
