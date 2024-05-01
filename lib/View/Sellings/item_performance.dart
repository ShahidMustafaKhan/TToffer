import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tt_offer/View/Boost%20Plus%20Screens/boost_plus_screen.dart';

class ItemPerformanceScreen extends StatefulWidget {
  const ItemPerformanceScreen({super.key});

  @override
  State<ItemPerformanceScreen> createState() => _ItemPerformanceScreenState();
}

class _ItemPerformanceScreenState extends State<ItemPerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Item Performance",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              "assets/images/auction1.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Modern Light Clothes",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textColor: AppTheme.txt1B20),
                            const SizedBox(
                              height: 5,
                            ),
                            AppText.appText("Sold",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.appColor),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  AppText.appText("Total Views:",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor),
                  const SizedBox(
                    width: 20,
                  ),
                  AppText.appText("2344",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      textColor: AppTheme.textColor),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: SizedBox(
                  height: 256,
                  child: ProductPerformanceChart(
                    viewsData: [10, 20, 15, 30, 25, 80],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: AppButton.appButton("Boost Plus",
              onTap: () {
                push(context, const BoostPlusScreen());
              },
                  height: 50,
                  textColor: AppTheme.whiteColor,
                  backgroundColor: AppTheme.appColor,
                  radius: 32.0,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            AppText.appText("Get an average of 20x more views each day",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: const Color(0xff8A8A8A))
          ],
        ),
      ),
    );
  }
}

class ProductPerformanceChart extends StatelessWidget {
  final List<double> viewsData;

  const ProductPerformanceChart({Key? key, required this.viewsData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            dotData: const FlDotData(show: false),
            spots: viewsData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: AppTheme.appColor,
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(colors: [
                  Color(0xff00A87D),
                  Color(0xffCFFFF3),
                  Color(0xffFFFFFF),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
        minY: 0,
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          // bottomTitles: AxisTitles(
          //   sideTitles: SideTitles(
          //     showTitles: true,
          //     reservedSize: 30,
          //     interval: 1,
          //     getTitlesWidget: bottomTitleWidgets,
          //   ),
          // ),
          // leftTitles: AxisTitles(
          //   sideTitles: SideTitles(
          //     showTitles: true,
          //     interval: 1,
          //     getTitlesWidget: leftTitleWidgets,
          //     reservedSize: 42,
          //   ),
          // ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = AppText.appText('Jan',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff615E83));
        break;
      case 5:
        text = AppText.appText('Feb',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff615E83));

        break;
      case 8:
        text = AppText.appText('Mar',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff615E83));

        break;
      default:
        text = AppText.appText('',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff615E83));

        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
