import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';

/// ユースケース実行のためのメソッドを備えた Mixin
mixin UsecaseMixin {
  Future<T> run<T>(
    Ref ref, {
    required Future<T> Function() action,
  }) async {
    ref.read(overlayLoadingProvider.notifier).update((_) => true);
    try {
      return await action();
    } catch (e) {
      rethrow;
    } finally {
      ref.read(overlayLoadingProvider.notifier).update((_) => false);
    }
  }
}
