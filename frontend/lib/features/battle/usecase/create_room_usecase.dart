import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/usecase_mixin.dart';

/// [CreateRoomUsecase] のインスタンスを作成するためのプロバイダ
///
/// UI 層にユースケースを注入するために使用され、躁鬱状態を登録する
final createRoomUsecaseProvider = Provider<CreateRoomUsecase>(
  CreateRoomUsecase.new,
);

/// [CreateRoomUsecase] は、ルーム作成ボタン押下時の DB 登録プロセスをカプセル化する
class CreateRoomUsecase with UsecaseMixin {
  final Ref ref;

  /// 指定された [Ref] を使用して [CreateRoomUsecase] を構築する
  ///
  /// [Ref] は必要なプロバイダーを読み取るために使用される
  CreateRoomUsecase(this.ref);

  /// [Room] を登録するユースケースの実行
  Future<void> invoke({
    required String uid,
  }) async {
    await run(
      ref,
      action: () async => await ref.read(roomRepositoryProvider).add(
            Room(
              roomId: '',
              uid: uid,
              pairUid: '',
              isOpen: true,
            ),
          ),
    );
  }
}
