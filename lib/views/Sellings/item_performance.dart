import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/models/products_count_model.dart';
import 'package:tt_offer/views/Boost%20Plus%20Screens/boost_plus_screen.dart';

import '../../models/product_model.dart';
import '../../view_model/product/product/product_viewmodel.dart';

class ItemPerformanceScreen extends StatefulWidget {
  final Product? product;

  const ItemPerformanceScreen({super.key, required this.product});
  @override
  State<ItemPerformanceScreen> createState() => _ItemPerformanceScreenState();
}

class _ItemPerformanceScreenState extends State<ItemPerformanceScreen> {
  List<ItemData> data = [];

  late ProductViewModel productViewModel;
  Product? product;

  int totalViews = 0;

  List<int> views = [];

  @override
  void initState() {
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    product = widget.product;
    updateViews();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getItemPerformance();
    });
    super.initState();
  }

  bool loading = false;

  void updateViews({bool state = false}) {
    // Initialize the views list with zeros for all 12 months
    views = List.filled(10, 0);
    totalViews = 0;

    if (product != null && product!.viewSummary != null) {
      // Map months to their respective indices
      final monthToIndex = {
        "December": 0,
        "January": 1,
        "February": 2,
        "March": 3,
        "April": 4,
        "May": 5,
        "June": 6,
        "July": 7,
        "August": 8,
        "September": 9,
      };

      product!.viewSummary!
          .where((element) => element.views != null)
          .forEach((element) {
        final monthIndex = monthToIndex[element.month];
        if (monthIndex != null) {
          // Replace the views for the corresponding month
          views[monthIndex] = element.views!;
        }
        totalViews += element.views!;
      });
    }

    // Trigger a state update if required
    if (state == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
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
                        if (widget.product?.photo?.isNotEmpty ?? false)
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.product!.photo![0].url!,
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
                            SizedBox(
                              width: 300,
                              child: AppText.appText(
                                  widget.product?.title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppTheme.txt1B20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            AppText.appText(
                                getItemStatus(widget.product?.status),
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
                  AppText.appText("$totalViews",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      textColor: AppTheme.textColor),
                ],
              ),
            ),
            Consumer<ProductViewModel>(
                builder: (context, productViewModel, child) {
              if (!loading) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: SizedBox(
                      height: 256,
                      child: ProductPerformanceChart(
                        viewsData: views,
                      ),
                    ));
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.appColor,
                  ),
                );
              }
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: AppButton.appButton("Boost Plus", onTap: () {
                push(
                    context,
                    BoostPlusScreen(
                      product: widget.product,
                    ));
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

  Future<void> getItemPerformance() async {
    productViewModel.getProductDetails(product?.id).then((value) {
      product = value;
      updateViews(state: true);
    }).onError((error, stackTrace) {});
  }
}

class ProductPerformanceChart extends StatelessWidget {
  final List<num> viewsData;

  const ProductPerformanceChart({Key? key, required this.viewsData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            dotData: const FlDotData(show: false),
            spots: List.generate(10, (index) {
              // Fill missing months with default values (e.g., 0)
              double value =
                  index < viewsData.length ? viewsData[index].toDouble() : 0.0;
              return FlSpot(index.toDouble(), value);
            }),
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
        titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval: 10, // Show labels at intervals of 10
                getTitlesWidget: leftTitleWidgets,
              ),
            )),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    String month = '';

    // Mapping month numbers to month names
    switch (value.toInt()) {
      case 0:
        month = 'Dec';
        break;
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
        // case 9:
        //   month = 'Oct';
        //   break;
        // case 10:
        //   month = 'Nov';
        break;
      default:
        month = ''; // For any other value
    }

    text = AppText.appText(month,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: const Color(0xff615E83));

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

    // Convert the `value` to a string to display as a label
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
