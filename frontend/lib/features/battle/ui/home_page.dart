import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // [uid] - ユーザーID（ログインしているユーザーの ID が入ってくる）
  const HomePage({super.key, required this.uid});

  // ユーザーID
  final String uid;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ここに対決ボタン'),
      ),
    );
  }
}
