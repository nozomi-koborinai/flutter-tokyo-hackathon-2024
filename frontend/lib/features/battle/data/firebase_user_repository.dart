import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tokyo_hackathon_2024/core/errors/exceptions.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/model/app_user.dart';

/// Firestore のユーザーデータを操作するリポジトリ
class UserRepository {
  UserRepository({
    required this.userCollectionRef,
  });

  final CollectionReference<UserDocument> userCollectionRef;

  /// ユーザーのドキュメントを取得する。
  Future<AppUser?> get(String uid) async {
    try {
      final doc = await userCollectionRef.doc(uid).get();
      return doc.data()?.toAppUser();
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ユーザーのドキュメントを作成する。
  Future<void> add(AppUser user) async {
    try {
      final userDoc = UserDocument(
        uid: user.uid,
        userName: user.userName,
        hitPoint: user.hitPoint,
        createImageCount: user.createImageCount,
      );

      await userCollectionRef.doc(userDoc.uid).set(userDoc);
    } on FirebaseException catch (e) {
      throw AppException('Firestore の作成処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ユーザーのドキュメントを削除する。
  Future<void> delete(String uid) async {
    try {
      await userCollectionRef.doc(uid).delete();
    } on FirebaseException catch (e) {
      throw AppException('Firestore の削除処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// 指定したユーザー ID のユーザーが Firestore に登録されるまで待つ
  Future<void> waitUntilUserCreated(String uid) async {
    try {
      final snapshots = userCollectionRef.doc(uid).snapshots();
      const timeout = Duration(minutes: 3);
      // Cloud Functions インスタンスの初回起動を考慮して 3 分待つ
      await for (final snapshot in snapshots.timeout(timeout)) {
        if (snapshot.exists && snapshot.data() != null) {
          final userData = snapshot.data()!;
          if (userData.uid == uid) return;
        }
      }
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } on TimeoutException {
      throw const AppException('Firestore ユーザーの登録に時間がかかりすぎました');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }
}

/// Firebase Firestore に保存されるユーザーのドキュメントモデル
/// アプリ上でこのデータを操作する場合は、[UserDocument] を操作することはなく、
/// [AppUser] を操作することになる。
/// 理由: UserDocument は Firestore のデータモデルであり、アプリデータのモデルとは異なるため、
/// また、不要なデータをアプリに持ち込むことを避けるため。
class UserDocument {
  UserDocument({
    required this.uid,
    required this.userName,
    required this.hitPoint,
    required this.createImageCount,
  });

  final String uid;
  final String userName;
  final int hitPoint;
  final int createImageCount;

  factory UserDocument.fromJson(String uid, Map<String, dynamic> json) =>
      UserDocument(
          uid: uid,
          userName: json['userName'] as String,
          hitPoint: json['hitPoint'] as int,
          createImageCount: json['createImageCount'] as int);

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'hitPoint': hitPoint,
        'createImageCount': createImageCount,
      };
}

/// [UserDocument] の拡張
extension on UserDocument {
  /// UserDocument -> AppUser
  AppUser toAppUser() => AppUser(
        uid: uid,
        userName: userName,
        hitPoint: hitPoint,
        createImageCount: createImageCount,
      );
}
