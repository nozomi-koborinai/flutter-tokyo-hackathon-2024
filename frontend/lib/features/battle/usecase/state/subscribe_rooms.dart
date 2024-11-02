import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';

/// [Room] を購読する [StreamProvider]
final subscribeRoomsProvider = StreamProvider<List<Room>>(
  (ref) => ref.watch(roomRepositoryProvider).subscribeRooms(),
);
