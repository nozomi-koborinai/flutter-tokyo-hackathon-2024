import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/usecase_mixin.dart';

/// [CreateCharacterUsecase] のインスタンスを作成するためのプロバイダ
///
/// UI 層にユースケースを注入するために使用される
final createCharacterUsecaseProvider = Provider<CreateCharacterUsecase>(
  CreateCharacterUsecase.new,
);

/// [CreateCharacterUsecase] は、 キャラクター作成ボタン押下時の DB 登録プロセスをカプセル化する
class CreateCharacterUsecase with UsecaseMixin {
  final Ref ref;

  /// 指定された [Ref] を使用して [CreateCharacterUsecase] を構築する
  ///
  /// [Ref] は必要なプロバイダーを読み取るために使用される
  CreateCharacterUsecase(this.ref);

  /// キャラクターを登録するユースケースの実行
  Future<Room> invoke({
    required String prompt,
    required String uid,
  }) async {
    return await run(ref, action: () async {
      final auth = ref.read(firebaseAuthProvider);
      final idToken = await auth.currentUser!.getIdToken();

      await ref.read(characterImageRepositoryProvider).generateCharacterImage(
            prompt: prompt,
            uid: uid,
            idToken: idToken!,
          );
      return await ref.read(roomRepositoryProvider).getByUid(uid);
    });
  }
}
