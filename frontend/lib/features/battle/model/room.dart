class Room {
  const Room({
    required this.roomId,
    required this.uid,
    required this.pairUid,
    required this.isOpen,
  });

  final String roomId;
  final String uid;
  final String pairUid;
  final bool isOpen;
}
