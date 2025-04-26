import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/global/alert_dialog_popper.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/app_images.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/primary_button.dart';
import 'package:budgeting_app/widgets/secondary_button.dart';
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

  ///redeveloped by: Rhylvin
  ///This is a pop up to show a Error message
  ///params [substituteText] String , [error] String, [additionalFunctions] Function
  openErrorAlertBox({
    String? substituteText,
    Object? error,
    Function? additionalFunctions,
    bool popDialog = true,
  }) {
    setState(() {
      AlertDialogPopper.disableDeviceBackButton = true;
    });
    String errorMessage = "";
    bool isNoInternet = false;
    if (substituteText != null) {
      errorMessage = substituteText;
    } else {
      try {
        if (error.toString().contains('503')) {
          errorMessage = '503 Service Temporarily Unavailable';
        } else if (error.toString().contains('CONNECTION_TIMED_OUT')) {
          errorMessage =
              'Connection Timed Out.\nRequest took too long to respond.\nPlease try again';
        } else if (error.toString().contains('Failed host lookup') ||
            error.toString().contains('XMLHttpRequest') ||
            error.toString().contains('ER038') ||
            error.toString().contains('Connection reset by peer') ||
            error.toString().contains('Connection closed') ||
            error.toString().contains('Network is unreachable')) {
          errorMessage = AppLocalizations.of(context)!
                  .translate("not_connected_internet") ??
              "";
          isNoInternet = true;
        } else if (error
            .toString()
            .contains('Session timed out or no longer valid')) {
          errorMessage =
              AppLocalizations.of(context)!.translate("session_expired") ?? "";
        } else if (error.toString().contains('413 Request Entity Too Large')) {
          errorMessage =
              AppLocalizations.of(context)!.translate("photo_upload_exceeds") ??
                  "";
        }
      } catch (e) {
        errorMessage = "We're Having some issues...";
      }
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: AppColors.colorTheme,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: SizedBox(
                width: null,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///error logo
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(AppImages.appLogo)),
                        ),
                      ),
                    ),

                    ///error message
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            fontFamily: 'Satoshi-Bold',
                            fontSize: 15,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                PrimaryButton(
                  buttonWidthRatio: 1.0,
                  buttonText: 'OK',
                  onPressed: () async {
                    setState(() {
                      AlertDialogPopper.disableDeviceBackButton = false;
                    });
                    if (popDialog) {
                      Navigator.pop(context);
                    }
                    if (additionalFunctions != null) {
                      additionalFunctions();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  ///developed by: Rhylvin June 2023
  ///This is a pop up to show a Error message and return it to either home or login page
  ///params [text] String
  openErrorReturnAlertBox(String text) {
    setState(() {
      AlertDialogPopper.disableDeviceBackButton = true;
    });
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: AppColors.colorTheme,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: SizedBox(
                width: null,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(AppImages.appLogo)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.91,
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                              right: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontFamily: 'Satoshi-Bold',
                                fontSize: 18,
                                color: AppColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                PrimaryButton(
                  buttonWidthRatio: 1.0,
                  buttonText: 'OK',
                  onPressed: () async {
                    setState(() {
                      AlertDialogPopper.disableDeviceBackButton = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  ///redeveloped by: Rhylvin
  ///This is a pop up to show a successful message
  ///params [body] String , [route] String, [additionalFunctions] Function
  openSuccessAlertBox(
      {String? body,
      String? route,
      bool? removeUntilEnabled,
      bool? popUntil,
      Function? additionalFunctions}) {
    setState(() {
      AlertDialogPopper.disableDeviceBackButton = true;
    });

    double height;
    if ((body?.length ?? 0) > 50) {
      height = 300;
    } else {
      height = 250;
    }
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: AppColors.colorTheme,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: SizedBox(
                width: null,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(AppImages.appLogo)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.91,
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                              right: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Text(
                              body!,
                              style: const TextStyle(
                                fontFamily: 'Satoshi-Bold',
                                fontSize: 18,
                                color: AppColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                PrimaryButton(
                  buttonWidthRatio: 1.0,
                  buttonText: 'OK',
                  onPressed: () async {
                    setState(() {
                      AlertDialogPopper.disableDeviceBackButton = false;
                    });
                    if (additionalFunctions != null) {
                      additionalFunctions();
                    }
                    if (route == "" || route == null) {
                      Navigator.pop(context);
                    } else if (route.isNotEmpty && removeUntilEnabled!) {
                      Navigator.pop(context);
                      GlobalFunctions.beamToNamedRootFalse(context, route);
                    } else if (route.isNotEmpty && popUntil!) {
                      Navigator.pop(context);
                      GlobalFunctions.beamToNamed(context, route);
                    } else {
                      Navigator.pop(context);
                      GlobalFunctions.beamToNamed(context, route);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  ///developed by: Rhylvin May 2023
  ///This is a pop up to show a confirmation message
  ///params [body], [onConfirm]
  openConfirmationAlertBox({
    String? title,
    String? body,
    Function? onConfirm,
    String? denyText,
    String? confirmText,
    Function? onDeny,
    double? bodyFont = 18,
  }) {
    bodyFont ??= 18;

    setState(() {
      AlertDialogPopper.disableDeviceBackButton = true;
    });

    double height;
    if ((body?.length ?? 0) > 150) {
      height = 400;
    } else if ((body?.length ?? 0) >= 100) {
      height = 350;
    } else if ((body?.length ?? 0) > 50) {
      height = 300;
    } else {
      height = 250;
    }
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: AppColors.colorTheme,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: SizedBox(
                width: null,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(AppImages.appLogo),
                          ),
                        ),
                      ),
                    ),

                    ///title
                    title == null
                        ? Container()
                        : SingleChildScrollView(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  right: 0,
                                ),
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontFamily: 'Satoshi-Bold',
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                    ///body
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 0,
                              right: 0,
                            ),
                            child: Text(
                              body!,
                              style: TextStyle(
                                fontFamily: 'Satoshi-Bold',
                                fontSize: bodyFont,
                                color: AppColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: PrimaryButton(
                              buttonWidthRatio: 0.35,
                              buttonHeightRatio: 0.06,
                              buttonText: confirmText ?? 'Yes',
                              removeArrowWidget: true,
                              onPressed: () async {
                                setState(() {
                                  AlertDialogPopper.disableDeviceBackButton =
                                      false;
                                });
                                Navigator.pop(context);
                                onConfirm?.call();
                              }),
                        ),
                        const SizedBox(width: 16), //
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: SecondaryButton(
                            buttonWidthRatio: 0.35,
                            buttonText: denyText ?? 'No',
                            onPressed: () async {
                              setState(() {
                                AlertDialogPopper.disableDeviceBackButton =
                                    false;
                              });
                              Navigator.pop(context);
                              onDeny?.call();
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ), //
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
