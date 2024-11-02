import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/data/firebase_user_repository.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/data/room_repository.dart';

/// Firebase Auth のインスタンスを保持する [Provider]
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

/// Firestore のインスタンスを保持する [Provider]
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

/// [Dio] のインスタンスを保持する [Provider]
final dioProvider = Provider<Dio>(
  (_) => Dio(),
);

/// [FirebaseAuth] の [User] を返す [StreamProvider].
/// ユーザーの認証状態が変更される（ログイン、ログアウトする）たびに更新される。
final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).userChanges(),
);

/// 現在のユーザー ID を提供する [Provider].
final userIdProvider = Provider<String?>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(firebaseAuthProvider).currentUser?.uid;
});

/// ユーザーがログインしているかどうかを示す bool 値を提供する Provider.
/// [userIdProvider] の変更を watch しているので、ユーザーの認証状態が変更される
/// たびに、この [Provider] も更新される。
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(userIdProvider) != null,
);

/// [UserRepository] のインスタンスを提供する [Provider]
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    userCollectionRef: ref.watch(userCollectionRefProvider),
  ),
);

/// ユーザーコレクションの参照結果を提供する [Provider].
final userCollectionRefProvider = Provider(
  (ref) => ref
      .watch(firebaseFirestoreProvider)
      .collection('users')
      .withConverter<UserDocument>(
        fromFirestore: (snapshot, _) => UserDocument.fromJson(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (userDoc, options) => userDoc.toJson(),
      ),
);

/// [RoomRepository] のインスタンスを提供する [Provider]
final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => RoomRepository(
    roomCollectionRef: ref.watch(roomCollectionRefProvider),
  ),
);

/// ルームコレクションの参照結果を提供する [Provider].
final roomCollectionRefProvider = Provider(
  (ref) => ref
      .watch(firebaseFirestoreProvider)
      .collection('rooms')
      .withConverter<RoomDocument>(
        fromFirestore: (snapshot, _) => RoomDocument.fromJson(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (roomDoc, options) => roomDoc.toJson(),
      ),
);
