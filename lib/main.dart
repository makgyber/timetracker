import 'package:go_router/go_router.dart';
import 'package:timetracker/features/authentication/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetracker/features/job_orders/ui/home_screen.dart';
import 'package:timetracker/features/authentication/ui/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: TimeTracker()));
}

class TimeTracker extends ConsumerWidget {
  TimeTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) => UserAuthScope(
    notifier: _auth,
    child: MaterialApp.router(
      routerConfig: _router,
    )
  );

  final UserAuth _auth = UserAuth();


  late final _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          name: 'login',
          builder: (context, state) => const LoginScreen(),
          path: '/login',
        ),
        GoRoute(
          name: 'home',
          builder: (context, state) => const HomeScreen(),
          path: '/',
        ),

      ],
      redirect: _guard,
      refreshListenable: _auth,
      debugLogDiagnostics: true,
    );


  String? _guard(BuildContext context, GoRouterState state) {
    final bool signedIn =  _auth.signedIn;
    final bool signingIn = state.matchedLocation == '/login';

    debugPrint("signingIn $signingIn");
    debugPrint("signedIn $signedIn");
    if (!signedIn && !signingIn) {
      return '/login';
    }

    else if (signedIn && signingIn) {
      return '/';
    }

    return null;
  }


}

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
      required LocalKey super.key,
      required super.child,
    }) : super(
    transitionsBuilder: (BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) =>
        FadeTransition(
        opacity: animation.drive(_curveTween),
        child: child,
    ));

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}