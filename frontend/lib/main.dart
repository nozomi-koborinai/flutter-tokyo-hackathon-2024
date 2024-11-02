import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tokyo_hackathon_2024/core/constants/firebase_options.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/dialog.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/loading.dart';
import 'package:flutter_tokyo_hackathon_2024/core/widgets/snackbar.dart';
import 'package:flutter_tokyo_hackathon_2024/features/auth/ui/root_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'battle!!',
//      darkTheme: ThemeData(
//        brightness: Brightness.dark,
//        colorScheme: const ColorScheme.dark(
//          primary: Colors.white,
//          secondary: Colors.grey,
//        ),
//      ),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
          activeTrackColor: Colors.white,
          activeTickMarkColor: Colors.white,
          thumbColor: Colors.white,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          valueIndicatorColor: Colors.white,
          inactiveTrackColor: Colors.white,
          inactiveTickMarkColor: Colors.white,
        ),
        fontFamily: 'Noto Sans JP',
        fontFamilyFallback: const ['Noto Sans JP'],
      ),
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      builder: (context, child) {
        return Navigator(
          key: ref.watch(navigatorKeyProvider),
          // ignore: deprecated_member_use
          onPopPage: (route, dynamic _) => false,
          pages: [
            MaterialPage<Widget>(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: ScaffoldMessenger(
                      key: ref.watch(scaffoldMessengerKeyProvider),
                      child: child!,
                    ),
                  ),
                  if (ref.watch(overlayLoadingProvider)) const OverlayLoading(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
