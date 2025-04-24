import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:budgeting_app/widgets/mobile_scaffold.dart';
import 'package:budgeting_app/widgets/positioned_circular_button.dart';
import 'package:budgeting_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';

class LoginPage extends BaseView {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends BaseViewState {
  @override
  Widget rootWidget(BuildContext context) => Stack(
        children: [
          MobileScaffold(
            child: Column(
              children: [],
            ),
          ),

          ///add button
          PositionedCircularButton(
            bottom: 40,
            left: 0,
            right: 0,
            top: null,
            onTap: () {
              GlobalFunctions.beamToNamed(context, NavigationRoutes.createLog);
            },
            icon: Icon(Icons.add),
          ),

          ///settings button
          PositionedCircularButton(
            bottom: null,
            left: null,
            right: 20,
            top: 70,
            onTap: () {
              GlobalFunctions.beamToNamed(context, NavigationRoutes.settings);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      );
}
