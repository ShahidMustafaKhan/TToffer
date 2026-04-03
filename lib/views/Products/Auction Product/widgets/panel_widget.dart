import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/bids_model.dart';

import '../../../../Utils/utils.dart';
import '../../../../models/product_model.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Product? product;
  final List<BidsData> bidsData;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
    required this.product,
    required this.bidsData,
  }) : super(key: key);

  @override
  _PanelWidgetState createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  DateTime? auctionEndTime;
  Product? product;
  int? highestBidUser;
  ValueNotifier<int> remainingTimeNotifier = ValueNotifier(0);
  DateTime? endDateTime;
  Timer? _auctionTimer;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    getAuctionTime();
  }

  @override
  void dispose(){
    if(_auctionTimer!= null){
      _auctionTimer!.cancel();
    }
    super.dispose();
  }

  getAuctionTime(){
    DateTime? now = DateTime.now();

    if(product?.auctionEndingDateTime != null) {
      endDateTime = convertEndTimeToUserTimeZone(product!.auctionEndingDateTime!);
      remainingTimeNotifier.value = endDateTime!.difference(now).inSeconds;
      startAuctionTimer(_auctionTimer, remainingTimeNotifier, context, callAuctionApi: false);
    }
    else{
      remainingTimeNotifier.value = 0;
    }
  }

  DateTime _parseEndingDateTime() {
    String? endingTimeString = product?.auctionEndingTime;
    String? endingDateString = product?.auctionEndingDate;
    DateTime endingDate =
        DateFormat("yyyy-MM-dd").parse("$endingDateString");
    DateTime endingTime;

    if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse(endingTimeString);
    } else {
      endingTime = DateFormat("HH:mm").parse(endingTimeString);
    }
    return DateTime(
      endingDate.year,
      endingDate.month,
      endingDate.day,
      endingTime.hour,
      endingTime.minute,
    );
  }

  String getTimeLeftString() {
    DateTime? endTime = _parseEndingDateTime();

    Duration timeLeft = endTime.difference(DateTime.now());

    if (timeLeft.isNegative) {
      return 'Time Ends';
    }

    if (timeLeft.inHours < 24) {
      int hours = timeLeft.inHours;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$hours Hours $minutes Minutes';
    } else {
      int days = timeLeft.inDays;
      int hours = timeLeft.inHours % 24;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$days Days $hours Hours $minutes Minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    int highestPrice = 0;
    // Map<String, dynamic>? highestBidUser;

    // Find the highest bid price and the user associated with it
    for (var bid in widget.bidsData) {
      int price = bid.price!;
      if (price > highestPrice) {
        highestPrice = price;
        highestBidUser = price;
      }
    }
    final open = Provider.of<NotifyProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 110),
        child: SingleChildScrollView(
          controller: open.scrollController,
          physics: open.sheet == true
              ? const ScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 104,
                decoration: BoxDecoration(
                    color: const Color(0xffF3F4F5),
                    borderRadius: BorderRadius.circular(16)),
                child: containerData(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 17,
                        width: 17,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AppText.appText("Live Auction",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: AppTheme.textColor00),
                    ],
                  ),
                  AppText.appText("${widget.bidsData.length} Bid made",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor00),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.bidsData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: widget.bidsData[index].user ==
                                                      null ||
                                                  widget.bidsData[index].user!
                                                          .img ==
                                                      '' ||
                                                  widget.bidsData[index].user!
                                                          .img ==
                                                      null
                                              ? const AssetImage(
                                                  'assets/images/profile.png')
                                              : NetworkImage(widget
                                                      .bidsData[index].user!.img
                                                      .toString())
                                                  as ImageProvider)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText.appText(
                                          widget.bidsData[index].user == null ||
                                                  widget.bidsData[index].user!
                                                          .name ==
                                                      null ||
                                                  widget.bidsData[index].user!
                                                          .name ==
                                                      ''
                                              ? '${pref.getString(PrefKey.userName)}'
                                              : widget
                                                  .bidsData[index].user!.name
                                                  .toString(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          textColor: AppTheme.textColor00),

                                    ])
                              ],
                            ),
                            AppText.appText(
                                "AED ${widget.bidsData[index].price.toString()}",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.textColor00),
                          ],
                        )),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget containerData() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText("Starting Price",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.textColor00),
              AppText.appText("AED ${formatNumber((removeLastTwoZeros(product?.auctionInitialPrice?.toString() ?? '')))}",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor00),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      widget.bidsData.length >= 3 ? 3 : widget.bidsData.length,
                      (index) => SizedBox(
                        height: 20,
                        width: 20,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            widget.bidsData[index].user?.img ?? '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.textColor00),
                      color: AppTheme.whiteColor,
                    ),
                    child: Center(
                      child: AppText.appText(
                        widget.bidsData.length.toString(),
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.textColor00,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AppText.appText(
                    "are live",
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.textColor00,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText("Current Bid Price",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.textColor00),
              highestBidUser == null
                  ? AppText.appText("0",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor00)
                  : AppText.appText("AED ${formatNumber(highestBidUser.toString())}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor00),
              const SizedBox(
                height: 10,
              ),
                if(endDateTime != null)
                  ValueListenableBuilder<int>(
                      valueListenable: remainingTimeNotifier,
                      builder: (context, remainingTime, child) {
                        return auctionTimerCounter(endDateTime);
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
