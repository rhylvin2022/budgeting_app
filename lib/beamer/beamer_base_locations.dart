import 'package:base_code/beamer/navigation_routes.dart';
import 'package:base_code/pages/home/home_page.dart';
import 'package:base_code/pages/login/login_page.dart';
import 'package:base_code/pages/splash/splash_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

class BeamerBaseLocations extends BeamLocation<BeamState> {
  BeamerBaseLocations(RouteInformation routeInformation)
      : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        NavigationRoutes.splash,
        NavigationRoutes.login,
        NavigationRoutes.home,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uriBlueprint.path == pathPatterns[0])
        const BeamPage(
          key: ValueKey('splash'),
          title: 'Splash Screen',
          child: SplashPage(),
        ),
      if (state.uriBlueprint.path == pathPatterns[1])
        const BeamPage(
          key: ValueKey('login'),
          title: 'Login',
          child: LoginPage(),
        ),
      if (state.uriBlueprint.path == pathPatterns[2])
        const BeamPage(
          key: ValueKey('home'),
          title: 'Home',
          child: HomePage(),
        ),
    ];
  }
}
