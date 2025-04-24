import 'package:base_code/beamer/beamer_base_locations.dart';
import 'package:base_code/beamer/navigation_routes.dart';
import 'package:base_code/blocs/authentication/authentication_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseRoutesDelegate {
  static final baseRouteDelegate = BeamerDelegate(
    guards: [
      /// Guard /login by beaming to /dashboard if the user is authenticated:
      BeamGuard(
        pathPatterns: ['/dashboard'],
        check: (context, state) =>
            context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => NavigationRoutes.login,
      ),

      BeamGuard(
        pathPatterns: ['/dashboard/*'],
        check: (context, state) =>
            context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => NavigationRoutes.login,
      ),

      /// Guard /dashboard by beaming to /login if the user is unauthenticated:
      BeamGuard(
        pathPatterns: [NavigationRoutes.login],
        check: (context, state) =>
            !context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => NavigationRoutes.home,
      ),
    ],
    initialPath: '/splash',
    locationBuilder: (routeInformation, _) =>
        BeamerBaseLocations(routeInformation),
  );
}
