import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  const MemberList({
    super.key,
    required this.members,
  });

  final List<String> members;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
