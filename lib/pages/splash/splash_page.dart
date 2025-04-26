import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/blocs/settings/settings_bloc.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/app_images.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends BaseView {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends BaseViewState {
  @override
  void initState() {
    initSettings();
    navigateToLoginPage();
    super.initState();
  }

  void initSettings() {
    context.read<SettingsBloc>().add(InitSettingsTheme());
    context.read<SettingsBloc>().add(InitSettingsConversionRate());
  }

  void navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    GlobalFunctions.beamToReplaceNamed(context, NavigationRoutes.login);
  }

  @override
  Widget rootWidget(BuildContext context) => Scaffold(
        backgroundColor: AppColors.colorTheme,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(100),
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 3),
                  opacity: 1.0,
                  child: Image.asset(AppImages.appLogo),
                ),
              ),
            ),
          ],
        ),
      );
}
