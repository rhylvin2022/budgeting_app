import 'package:base_code/beamer/navigation_routes.dart';
import 'package:base_code/global/app_colors.dart';
import 'package:base_code/global/app_images.dart';
import 'package:base_code/global/global_functions.dart';
import 'package:base_code/widgets/base_view.dart';
import 'package:flutter/material.dart';

class SplashPage extends BaseView {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends BaseViewState {
  @override
  void initState() {
    navigateToLoginPage();
    super.initState();
  }

  void navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    GlobalFunctions.beamToReplaceNamed(context, NavigationRoutes.login);
  }

  @override
  Widget rootWidget(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
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
                  )),
            ),
          ],
        ),
      );
}
