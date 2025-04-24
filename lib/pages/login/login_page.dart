import 'package:base_code/blocs/localization/app_localization.dart';
import 'package:base_code/global/app_colors.dart';
import 'package:base_code/widgets/base_view.dart';
import 'package:base_code/widgets/primary_button.dart';
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
  Widget rootWidget(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: PrimaryButton(
                buttonText:
                    '${AppLocalizations.of(context)!.translate("login")}',
                onPressed: () {
                  ///change authentication status to authenticated
                  context
                      .read<AuthenticationBloc>()
                      .add(const ChangeAuthentication());
                },
              ),
            ),
          ],
        ),
      );
}
