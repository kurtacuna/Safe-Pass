import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/const/kglobal_keys.dart';
import 'package:safepass_frontend/common/const/kroutes.dart';
import 'package:safepass_frontend/src/auth/views/login_screen.dart';
import 'package:safepass_frontend/src/entrypoint/views/entrypoint.dart';
import 'package:safepass_frontend/src/splashscreen/views/splashscreen.dart';
import 'package:safepass_frontend/src/dashboard/views/dashboard_screen.dart'; 
import 'package:safepass_frontend/src/registration/views/registration_screen.dart'; 
import 'package:safepass_frontend/src/check_in/views/check_in_screen.dart'; 
import 'package:safepass_frontend/src/check_out/views/check_out_screen.dart'; 

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
      builder: (context, state) => const Entrypoint(),
      routes: [ 
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'register', 
              builder: (context, state) => const RegistrationScreen(),
            ),
            GoRoute(
              path: 'checkin', 
              builder: (context, state) => const CheckInScreen(),
            ),
            GoRoute(
              path: 'checkout', 
              builder: (context, state) => const CheckOutScreen(),
            ),
          ],
        ),
      ],
    ),
  ]
);

GoRouter get router => _router;