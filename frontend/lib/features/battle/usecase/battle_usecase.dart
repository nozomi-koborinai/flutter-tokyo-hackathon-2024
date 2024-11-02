import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/usecase_mixin.dart';

/// [BattleUsecase] のインスタンスを作成するためのプロバイダ
///
/// UI 層にユースケースを注入するために使用される
final battleUsecaseProvider = Provider<BattleUsecase>(
  BattleUsecase.new,
);

/// [BattleUsecase] は、 バトルボタン押下時の DB 登録プロセスをカプセル化する
class BattleUsecase with UsecaseMixin {
  final Ref ref;

  /// 指定された [Ref] を使用して [BattleUsecase] を構築する
  ///
  /// [Ref] は必要なプロバイダーを読み取るために使用される
  BattleUsecase(this.ref);

  /// バトルフローを実行するユースケース
  Future<void> invoke({
    required String roomId,
    required String uid,
    required String pairUid,
    required String userImageUrl,
    required String pairUserImageUrl,
  }) async {
    return await run(ref, action: () async {
      final auth = ref.read(firebaseAuthProvider);
      final idToken = await auth.currentUser!.getIdToken();
      final battleResult =
          await ref.read(battleRepositoryProvider).executeBattle(
                roomId: roomId,
                uid: uid,
                pairUid: pairUid,
                userImageUrl: userImageUrl,
                pairUserImageUrl: pairUserImageUrl,
                idToken: idToken!,
              );

      return battleResult;
    });
  }
}
