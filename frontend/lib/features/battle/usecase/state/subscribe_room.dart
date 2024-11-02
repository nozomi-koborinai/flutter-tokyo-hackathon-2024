import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';

/// 特定の [Room] を購読する [StreamProvider]
final subscribeRoomProvider = StreamProvider.family<Room, String>(
  (ref, roomId) => ref.watch(roomRepositoryProvider).subscribe(roomId),
);
