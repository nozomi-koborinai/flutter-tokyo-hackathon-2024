import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_providers.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/data/firebase_auth_repository.dart';
import 'package:flutter_tokyo_hackathon_2024/features/battle/ui/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ルートページの [GlobalKey]
/// この Key によって、アプリ全体でのナビゲーション操作が可能になる
/// 例えば、どの画面からでもルートページに戻ることができる
final rootPageKey = Provider((ref) => GlobalKey<NavigatorState>());

/// ルートページ
/// このページは、ユーザーがサインインしているかどうかによって、
/// 異なるウィジェットを表示する
class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ref.read(firebaseAuthRepositoryProvider).signinAnonymously();
        });
        return;
      },
      [],
    );
    return Scaffold(
      key: ref.watch(rootPageKey),
      body: AuthDependentBuilder(
        onAuthenticated: onAuthencaited,
        onUnAuthenticated: () {
          return const OverlayLoading();
        },
      ),
    );
  }

  /// Firebase に Auth にサインイン済みの場合に表示するウィジェット
  Widget onAuthencaited({required String userId}) {
    return HomePage(
      uid: userId,
    );
  }
}

/// Firebase に Auth にサインイン済みの場合にのみ [onAuthenticated] で渡した
/// ウィジェットを表示する。
/// その際、サインイン済みのユーザーの `userId` が使用できる。
class AuthDependentBuilder extends ConsumerWidget {
  const AuthDependentBuilder({
    super.key,
    required this.onAuthenticated,
    required this.onUnAuthenticated,
  });

  /// Firebase Auth にサインイン済みの場合に表示されるウィジェットを `userId` とともに
  /// 返すビルダー関数。
  final Widget Function({required String userId}) onAuthenticated;

  /// Firebase Auth にサインインしていない場合に表示されるウィジェットを返すビルダー関数（任意）
  final Widget Function() onUnAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return onUnAuthenticated();
    }
    return onAuthenticated(userId: userId);
  }
}
