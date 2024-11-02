import 'package:dio/dio.dart';
import 'package:flutter_tokyo_hackathon_2024/core/errors/exceptions.dart';

/// 画像生成APIを呼び出すリポジトリ
class CharacterImageRepository {
  CharacterImageRepository({
    required this.dio,
  });

  final Dio dio;

  /// 画像を生成する
  Future<String> generateCharacterImage({
    required String prompt,
    required String uid,
    required String idToken,
  }) async {
    try {
      final response = await dio.post(
        'https://generateimage-364766414282.us-central1.run.app',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
        data: {
          'data': {
            'prompt': prompt,
            'uid': uid,
          },
        },
      );

      if (response.data['result'] == null) {
        throw const AppException('画像生成に失敗しました');
      }

      final mediaData = response.data['result'];
      return mediaData['url'] as String;
    } on DioException catch (e) {
      throw AppException('API呼び出しでエラーが発生しました: ${e.message}');
    } catch (e) {
      throw AppException('予期しないエラーが発生しました: $e');
    }
  }
}
