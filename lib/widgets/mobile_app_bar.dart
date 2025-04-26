import 'package:beamer/beamer.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

///developed by: Rhylvin September 2023
class MobileAppBar extends StatefulWidget {
  final BuildContext context;
  final String title;
  final Function? refreshFunction;
  final bool hideBackButton;
  final Widget child;
  final String parentPath;
  final String trailing;
  final double titleFontSize;
  final Function? additionalRouteFunction;
  const MobileAppBar({
    super.key,
    required this.context,
    required this.child,
    required this.title,
    this.refreshFunction,
    this.hideBackButton = false,
    this.parentPath = '',
    this.trailing = '',
    this.titleFontSize = 23,
    this.additionalRouteFunction,
  });

  @override
  State<MobileAppBar> createState() => _MobileAppBarState();
}

class _MobileAppBarState extends State<MobileAppBar> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Add a listener to the ScrollController to detect when the user releases the drag
      _controller.addListener(() {});
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.125),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                ],
                color: AppColors.colorTheme,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.02,
                    child: widget.hideBackButton
                        ? Container()
                        : InkWell(
                            onTap: () {
                              ButtonConflictPrevention.activate(() {
                                if (widget.parentPath != '') {
                                  Beamer.of(context, root: true)
                                      .beamToNamed(widget.parentPath);
                                } else {
                                  context.beamBack();
                                }
                                if (widget.additionalRouteFunction != null) {
                                  widget.additionalRouteFunction!();
                                }
                              });
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                            ),
                          ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.055,
                    left: MediaQuery.of(context).size.height * 0.06,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.colorThemeText,
                        fontFamily: 'Satoshi',
                        fontSize: widget.titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget.trailing != ''
                      ? Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.width * 0.05,
                          child: Text(
                            widget.trailing,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Satoshi-Bold',
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.025),
            child: widget.refreshFunction == null
                ? SingleChildScrollView(
                    controller: _controller,
                    child: Center(child: widget.child),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Center(
                        child: widget.child,
                      ),
                    ),
                  ),
          ),
        ),
      );

  Future _refreshData() async {
    widget.refreshFunction!();
    await Future.delayed(const Duration(seconds: 2)).whenComplete(() {});
  }
}
