import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tokyo_hackathon_2024/core/errors/exceptions.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';

/// Firestore のルームデータを操作するリポジトリ
class RoomRepository {
  RoomRepository({
    required this.roomCollectionRef,
  });

  final CollectionReference<RoomDocument> roomCollectionRef;

  /// ルームのドキュメントを購読する。
  Stream<Room> subscribe(String roomId) {
    try {
      return roomCollectionRef
          .doc(roomId)
          .snapshots()
          .map((snapshot) => snapshot.data()!.toAppRoom());
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ルームのドキュメントを取得する。
  Future<Room> get(String roomId) async {
    try {
      final snapshot = await roomCollectionRef.doc(roomId).get();
      return snapshot.data()!.toAppRoom();
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ユーザー ID からルームを取得する。
  Future<Room> getByUid(String uid) async {
    try {
      final snapshot = await roomCollectionRef
          .where(
            'uid',
            isEqualTo: uid,
          )
          .limit(1)
          .get();

      return snapshot.docs.first.data().toAppRoom();
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// 全てのルームのドキュメントを購読する。
  Stream<List<Room>> subscribeRooms() {
    try {
      return roomCollectionRef.where('isOpen', isEqualTo: true).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc.data().toAppRoom()).toList(),
          );
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ルームのドキュメントを作成する。
  Future<void> add(Room room) async {
    try {
      final roomDoc = RoomDocument(
        roomId: room.roomId,
        uid: room.uid,
        pairUid: room.pairUid,
        isOpen: room.isOpen,
      );

      await roomCollectionRef.add(roomDoc);
    } on FirebaseException catch (e) {
      throw AppException('Firestore の作成処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ルームのドキュメントを更新する。
  Future<void> update(Room room) async {
    try {
      final roomDoc = RoomDocument(
        roomId: room.roomId,
        uid: room.uid,
        pairUid: room.pairUid,
        isOpen: room.isOpen,
      );

      await roomCollectionRef.doc(room.roomId).update(roomDoc.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Firestore の更新処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// ルームのドキュメントを削除する。
  Future<void> delete(String roomId) async {
    try {
      await roomCollectionRef.doc(roomId).delete();
    } on FirebaseException catch (e) {
      throw AppException('Firestore の削除処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }
}

/// Firebase Firestore に保存されるルームのドキュメントモデル
class RoomDocument {
  RoomDocument({
    required this.roomId,
    required this.uid,
    required this.pairUid,
    required this.isOpen,
  });

  final String roomId;
  final String uid;
  final String pairUid;
  final bool isOpen;

  factory RoomDocument.fromJson(String roomId, Map<String, dynamic> json) =>
      RoomDocument(
        roomId: roomId,
        uid: json['uid'] as String,
        pairUid: json['pairUid'] as String,
        isOpen: json['isOpen'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'pairUid': pairUid,
        'isOpen': isOpen,
      };
}

/// [RoomDocument] の拡張
extension on RoomDocument {
  /// RoomDocument -> Room
  Room toAppRoom() => Room(
        roomId: roomId,
        uid: uid,
        pairUid: pairUid,
        isOpen: isOpen,
      );
}
