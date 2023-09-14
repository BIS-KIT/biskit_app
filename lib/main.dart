import 'package:biskit_app/common/component/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'common/const/keys.dart';
import 'common/provider/router_provider.dart';

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [
  const Locale('en', 'US'),
  const Locale('ko', 'KR'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // kakao
  KakaoSdk.init(
    nativeAppKey: kKakaoNativeAppKey,
    javaScriptAppKey: kKakaoJavascriptKey,
  );

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // logger.d(context.locale.toString());
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const CustomLoading(),
      overlayColor: Colors.transparent,
      overlayOpacity: 0.2,
      child: MaterialApp.router(
        title: 'BISKIT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kColorBiskitNavy),
          useMaterial3: true,
        ),
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}
