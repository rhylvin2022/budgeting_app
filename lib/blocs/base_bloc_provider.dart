import 'package:budgeting_app/blocs/authentication/authentication_bloc.dart';
import 'package:budgeting_app/blocs/localization/localization_bloc.dart';
import 'package:budgeting_app/blocs/sample_bloc/sample_bloc_bloc.dart';
import 'package:budgeting_app/repositories/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBlocProvider extends StatelessWidget {
  final Widget child;
  const BaseBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => AuthenticationBloc(),
      ),
      BlocProvider<LocalizationBloc>(
        create: (_) => LocalizationBloc()..add(LanguageLoadStarted()),
      ),

      ///sample
      BlocProvider<SampleBlocBloc>(
        create:
            (BuildContext context) =>
                SampleBlocBloc(sampleRepository: SampleRepository()),
      ),
    ],
    child: child,
  );
}
