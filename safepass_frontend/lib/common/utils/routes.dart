import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/const/kglobal_keys.dart';
import 'package:safepass_frontend/common/const/kroutes.dart';
import 'package:safepass_frontend/src/auth/views/login_screen.dart';
import 'package:safepass_frontend/src/entrypoint/views/entrypoint.dart';
import 'package:safepass_frontend/src/splashscreen/views/splashscreen.dart';

final GoRouter _router = GoRouter(
  navigatorKey: AppGlobalKeys.navigator,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Splashscreen()
    ),
    GoRoute(
      path: AppRoutes.kAuth,
      builder: (context, state) => const LoginScreen()
    ),
    GoRoute(
      path: AppRoutes.kEntrypoint,
      builder: (context, state) => const Entrypoint()
    )
  ]
);

GoRouter get router => _router;