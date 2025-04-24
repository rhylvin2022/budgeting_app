import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class BaseView extends StatefulWidget {
  const BaseView({super.key});
}

abstract class BaseViewState extends State<BaseView>
    with WidgetsBindingObserver {
  ///init state
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
    });

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // Unregister the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Check if the app is resumed from the background
  }

  @override
  Widget build(BuildContext context) => rootWidget(context);

  Widget rootWidget(BuildContext context);

  ///This is for show the loading
  showLoadingDialog(BuildContext context) async {
    _loadCustomLoader(context);
  }

  _loadCustomLoader(BuildContext context) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  ///This is for hide the loading
  hideLoadingDialog(BuildContext context) async {
    _hideCustomLoader(context);
  }

  _hideCustomLoader(BuildContext context) async {
    await EasyLoading.dismiss();
  }
}
