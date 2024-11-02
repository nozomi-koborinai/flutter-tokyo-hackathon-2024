// ユーザー情報
class AppUser {
  final String uid;
  final String userName;
  final int hitPoint;
  final int createImageCount;
  final String characterImageUrl;

  AppUser({
    required this.uid,
    required this.userName,
    required this.hitPoint,
    required this.createImageCount,
    required this.characterImageUrl,
  });
}
