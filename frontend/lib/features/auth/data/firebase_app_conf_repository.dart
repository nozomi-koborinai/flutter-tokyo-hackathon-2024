import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tokyo_hackathon_2024/core/errors/exceptions.dart';

/// Firestore のアプリケーション設定を操作するリポジトリ
class AppConfRepository {
  AppConfRepository({
    required this.appConfCollectionRef,
  });

  final CollectionReference<AppConfDocument> appConfCollectionRef;

  /// アプリケーション設定のドキュメントを取得する。
  Future<AppConfDocument> get(AppConfDocumentType docType) async {
    try {
      final doc = await appConfCollectionRef.doc(docType.name).get();
      return doc.data() ?? AppConfDocument.empty(docType);
    } on FirebaseException catch (e) {
      throw AppException('Firestore の取得処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }

  /// アプリケーション設定のドキュメントを更新する。
  Future<void> update(
    AppConfDocumentType docType,
    Map<String, dynamic> data,
  ) async {
    try {
      await appConfCollectionRef.doc(docType.name).update(data);
    } on FirebaseException catch (e) {
      throw AppException('Firestore の更新処理でエラーが発生しました: ${e.code}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }
}

/// Firebase Firestore に保存されるアプリケーション設定のドキュメントモデル
class AppConfDocument {
  AppConfDocument({
    required this.id,
    required this.templates,
  });

  final String id;
  final List<String> templates;

  factory AppConfDocument.fromJson(String id, Map<String, dynamic> json) =>
      AppConfDocument(
        id: id,
        templates: (json['templates'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  factory AppConfDocument.empty(AppConfDocumentType docType) => AppConfDocument(
        id: docType.name,
        templates: [],
      );

  Map<String, dynamic> toJson() => {
        'templates': templates,
      };
}

/// アプリケーション設定のドキュメントタイプ
enum AppConfDocumentType {
  punishmentTemplates,
  gameSettings,
}
