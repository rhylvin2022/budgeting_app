import 'package:base_code/beamer/base_routes_delegate.dart';
import 'package:base_code/blocs/authentication/authentication_bloc.dart';
import 'package:base_code/blocs/localization/localization_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/localization/app_localization.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<LocalizationBloc, LocalizationState>(
            listener: (context, state) {
              setState(() {});
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              BaseRoutesDelegate.baseRouteDelegate.update();
              setState(() {});
            },
          ),
        ],
        child: BlocBuilder<LocalizationBloc, LocalizationState>(
          builder: (context, state) {
            return MaterialApp.router(
              locale: state.locale,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('si', 'LK'),
                Locale('ta', 'IN'),
              ],
              builder: EasyLoading.init(builder: (context, child) {
                // Set text scale factor to 1.0 to ignore system-wide font size preferences
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                    boldText: false,
                  ),
                  child: child!,
                );
              }),
              routeInformationParser: BeamerParser(),
              routerDelegate: BaseRoutesDelegate.baseRouteDelegate,
              backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: BaseRoutesDelegate.baseRouteDelegate,
              ),
            );
          },
        ),
      );
}
