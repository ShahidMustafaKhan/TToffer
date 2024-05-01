import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final data;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
    this.data,
  }) : super(key: key);

  @override
  _PanelWidgetState createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  DateTime? auctionEndTime;

  @override
  void initState() {
    super.initState();
  }

  DateTime _parseEndingDateTime() {
    String? endingTimeString = widget.data["ending_time"];
    String? endingDateString = widget.data["ending_date"];
    DateTime endingDate =
        DateFormat("yyyy-MM-dd").parse("${widget.data["ending_date"]}");
    DateTime endingTime;

    if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse("${widget.data["ending_time"]}");
      print(" vkrvlrvm$endingTime");
    } else {
      endingTime = DateFormat("HH:mm").parse("${widget.data["ending_time"]}");
      print(" jf3o3jfpfp3fpk$endingTime");
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

    if (endTime == null) {
      return 'Invalid date/time';
    }

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
                  AppText.appText("14 Bid made",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor00),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 12,
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
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/sp2.png"))),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText("Ronald Richards",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          textColor: AppTheme.textColor00),
                                      AppText.appText("20s",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor: AppTheme.textColor00),
                                    ])
                              ],
                            ),
                            AppText.appText("\$24.5k",
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
              AppText.appText("\$${widget.data["auction_price"]}",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor00),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 20,
                    width: 55,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage('assets/images/sp1.png'),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage('assets/images/sp2.png'),
                          ),
                        ),
                        Positioned(
                          right: 24,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage('assets/images/sp3.png'),
                          ),
                        ),
                        Positioned(
                          right: 36,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage('assets/images/sp4.png'),
                          ),
                        ),
                      ],
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
                        color: AppTheme.whiteColor),
                    child: Center(
                      child: AppText.appText("24+",
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          textColor: AppTheme.textColor00),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AppText.appText("are live",
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor00),
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
              AppText.appText("\$25,000",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor00),
              const SizedBox(
                height: 10,
              ),
              AppText.appText(getTimeLeftString(),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor00),
            ],
          ),
        ],
      ),
    );
  }
}
