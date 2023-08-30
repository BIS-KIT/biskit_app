import 'package:biskit_app/common/view/root_tab.dart';
import 'package:biskit_app/common/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  final provider = ref.read(routeProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
  );
});

final routeProvider = ChangeNotifierProvider<RouteProvider>((ref) {
  return RouteProvider(ref: ref);
});

class RouteProvider extends ChangeNotifier {
  final Ref ref;
  RouteProvider({
    required this.ref,
  });

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => const RootTab(),
        ),
      ];
}
