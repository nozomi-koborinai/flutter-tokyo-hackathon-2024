import 'package:dio/dio.dart';
import 'package:flutter_tokyo_hackathon_2024/core/errors/exceptions.dart';

/// バトルAPIを呼び出すリポジトリ
class BattleRepository {
  BattleRepository({
    required this.dio,
  });

  final Dio dio;

  /// バトルを実行する
  Future<void> executeBattle({
    required String roomId,
    required String uid,
    required String pairUid,
    required String userImageUrl,
    required String pairUserImageUrl,
    required String idToken,
  }) async {
    try {
      await dio.post(
        'https://battleflow-364766414282.us-central1.run.app',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
        data: {
          'data': {
            'roomId': roomId,
            'uid': uid,
            'pairUid': pairUid,
            'userImageUrl': userImageUrl,
            'pairUserImageUrl': pairUserImageUrl,
          },
        },
      );
    } on DioException catch (e) {
      throw AppException('API呼び出しでエラーが発生しました: ${e.message}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }
}
