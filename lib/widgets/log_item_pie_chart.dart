import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:swagger/api.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

class LogItemPieChart extends StatefulWidget {
  final List<LogItem> logItems;

  const LogItemPieChart({super.key, required this.logItems});

  @override
  State<LogItemPieChart> createState() => _LogItemPieChartState();
}

class _LogItemPieChartState extends State<LogItemPieChart> {
  final carouselController = cs.CarouselSliderController();
  int carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final expenseTotals = GlobalFunctions.calculateCategoryTotals(
        widget.logItems,
        forExpense: true);
    final incomeTotals = GlobalFunctions.calculateCategoryTotals(
        widget.logItems,
        forExpense: false);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: cs.CarouselSlider(
        carouselController: carouselController,
        items: carouselSlides(context, expenseTotals, incomeTotals),
        options: cs.CarouselOptions(
          initialPage: 0,
          autoPlay: false,
          viewportFraction: 1,
          disableCenter: true,
          pageSnapping: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            setState(() {
              carouselIndex = index;
            });
          },
        ),
      ),
    );
  }

  List<Widget> carouselSlides(
    BuildContext context,
    Map<String, double> expenseTotals,
    Map<String, double> incomeTotals,
  ) =>
      [
        Column(
          children: [
            VerticalSpace(
              spaceMultiplier: 0.03,
            ),
            expenseTotals.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        "Expenses Pie Chart",
                        style: TextStyle(
                          fontSize: 19,
                          color: AppColors.colorThemeText,
                          fontFamily: "Satoshi-Bold",
                        ),
                      ),
                      pie.PieChart(
                        dataMap: expenseTotals,
                        chartType: pie.ChartType.disc,
                      )
                    ],
                  )
                : Container(),
            VerticalSpace(
              spaceMultiplier: 0.03,
            ),
            incomeTotals.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        "Income Pie Chart",
                        style: TextStyle(
                          fontSize: 19,
                          color: AppColors.colorThemeText,
                          fontFamily: "Satoshi-Bold",
                        ),
                      ),
                      pie.PieChart(
                        dataMap: incomeTotals,
                        chartType: pie.ChartType.disc,
                      )
                    ],
                  )
                : Container(),
            VerticalSpace(
              spaceMultiplier: 0.03,
            ),
          ],
        ),
        Column(
          children: [
            expenseTotals.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        "Expenses Bar Graph",
                        style: TextStyle(
                          fontSize: 19,
                          color: AppColors.colorThemeText,
                          fontFamily: "Satoshi-Bold",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: fl.BarChart(
                            GlobalFunctions.generateBarData(expenseTotals),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            VerticalSpace(
              spaceMultiplier: 0.03,
            ),
            incomeTotals.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        "Income Bar Graph",
                        style: TextStyle(
                          fontSize: 19,
                          color: AppColors.colorThemeText,
                          fontFamily: "Satoshi-Bold",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: fl.BarChart(
                            GlobalFunctions.generateBarData(incomeTotals),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        )
      ];
}
