// ユーザー情報
class AppUser {
  final String uid;
  final String userName;
  final int hitPoint;
  final int createImageCount;

  AppUser({
    required this.uid,
    required this.userName,
    required this.hitPoint,
    required this.createImageCount,
  });
}
