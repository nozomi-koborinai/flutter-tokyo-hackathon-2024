import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/model/room.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/usecase_mixin.dart';

/// [EntryRoomUsecase] のインスタンスを作成するためのプロバイダ
///
/// UI 層にユースケースを注入するために使用される
final entryRoomUsecaseProvider = Provider<EntryRoomUsecase>(
  EntryRoomUsecase.new,
);

/// [EntryRoomUsecase] は、ルームを選択してペアUID の DB 登録プロセスをカプセル化する
class EntryRoomUsecase with UsecaseMixin {
  final Ref ref;

  /// 指定された [Ref] を使用して [EntryRoomUsecase] を構築する
  ///
  /// [Ref] は必要なプロバイダーを読み取るために使用される
  EntryRoomUsecase(this.ref);

  /// [Room] を登録するユースケースの実行
  Future<void> invoke(
      {required String uid,
      required String pairUid,
      required String roomId,
      required bool isOpen}) async {
    await run(
      ref,
      action: () async => await ref.read(roomRepositoryProvider).update(
            Room(
              roomId: roomId,
              uid: uid,
              pairUid: pairUid,
              isOpen: isOpen,
            ),
          ),
    );
  }
}
