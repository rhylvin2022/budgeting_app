import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/pages/create_log/create_log_page.dart';
import 'package:budgeting_app/pages/home/home_page.dart';
import 'package:budgeting_app/pages/login/login_page.dart';
import 'package:budgeting_app/pages/settings/settings_page.dart';
import 'package:budgeting_app/pages/splash/splash_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

class BeamerBaseLocations extends BeamLocation<BeamState> {
  BeamerBaseLocations(RouteInformation super.routeInformation);

  @override
  List<String> get pathPatterns => [
        NavigationRoutes.splash,
        NavigationRoutes.login,
        NavigationRoutes.home,
        NavigationRoutes.createLog,
        NavigationRoutes.settings,
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
        const BeamPage(key: ValueKey('home'), title: 'Home', child: HomePage()),
      if (state.uriBlueprint.path == pathPatterns[3])
        const BeamPage(
          key: ValueKey('Create Log'),
          title: 'Create Log',
          child: CreateLogPage(),
        ),
      if (state.uriBlueprint.path == pathPatterns[4])
        const BeamPage(
          key: ValueKey('Settings'),
          title: 'Settings',
          child: SettingsPage(),
        ),
    ];
  }
}
