import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/model/app_user.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/usecase/usecase_mixin.dart';

/// [InputNameUsecase] のインスタンスを作成するためのプロバイダ
///
/// UI 層にユースケースを注入するために使用され、躁鬱状態を登録する
final inputNameUsecaseProvider = Provider<InputNameUsecase>(
  InputNameUsecase.new,
);

/// [InputNameUsecase] は、名前を入力して DB 登録するプロセスをカプセル化する
class InputNameUsecase with UsecaseMixin {
  final Ref ref;

  /// 指定された [Ref] を使用して [InputNameUsecase] を構築する
  ///
  /// [Ref] は必要なプロバイダーを読み取るために使用される
  InputNameUsecase(this.ref);

  /// [AppUser] を登録するユースケースの実行
  Future<void> invoke({
    required String uid,
    required String userName,
  }) async {
    await run(
      ref,
      action: () async => await ref.read(userRepositoryProvider).add(
            AppUser(
              uid: uid,
              userName: userName,
              hitPoint: 30,
              createImageCount: 2,
              characterImageUrl: '',
            ),
          ),
    );
  }
}
