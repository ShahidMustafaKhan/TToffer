import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/utils/widgets/others/delete_notification_dialog.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';
import 'package:tt_offer/views/Post%20screens/post_screen.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';
import 'package:tt_offer/views/Sellings/item_performance.dart';
import 'package:tt_offer/views/Sellings/selling_purchase.dart';

class ItemDashBoard extends StatefulWidget {
  const ItemDashBoard({super.key, required this.selling});

  final Selling selling;

  @override
  State<ItemDashBoard> createState() => _ItemDashBoardState();
}

class _ItemDashBoardState extends State<ItemDashBoard> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const CustomDivider(),
                const SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "assets/images/cross.png",
                      height: 14,
                    )),
                InkWell(
                  onTap: () {
                    push(context, SellFaster(selling: widget.selling));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Sell faster with promotions",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppTheme.txt1B20),
                            AppText.appText(
                                "Get an average of 20x more views each day",
                                fontSize: 12,
                                textAlign: TextAlign.justify,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.txt1B20),
                          ],
                        ),
                      ),
                      AppButton.appButtonWithLeadingImage(
                        "Sell Faster",
                        imagePath: "assets/images/sellFaster.png",
                        imgHeight: 14,
                        width: 90,
                        height: 26,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        backgroundColor: AppTheme.appColor,
                        textColor: AppTheme.whiteColor,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
        appBar: const CustomAppBar1(
          title: "Item DashBoard",
          action: true,
          img: "assets/images/more.png",
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setStatess) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SizedBox(
                                height: 200,
                                width: getWidth(context) * .8,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {},
                                        child: AppText.appText("Share",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();

                                          push(
                                              context,
                                              PostScreen(
                                                  // selling: widget.selling,
                                                  ));
                                        },
                                        child: AppText.appText("Sell Another",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          markArchived(
                                              widget.selling.id, setStatess);
                                        },
                                        child: AppText.appText("Archive",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: AppText.appText("Cancel",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    if (loading)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.appColor,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: customListview(
                      img: widget.selling.photo![0].src,
                      title: widget.selling.title,
                      subtitle: widget.selling.fixPrice),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            FeatureInfoScreen(
                              detailResponse: widget.selling.toJson(),
                            ));
                      },
                      child: customContainer(
                          img: "assets/images/eye.png", txt: "View Post"),
                    ),
                    InkWell(
                      onTap: () {
                        push(context, PostScreen(selling: widget.selling));
                      },
                      child: customContainer(
                          img: "assets/images/edit.png", txt: "Edit Post"),
                    ),
                    InkWell(
                      onTap: () {
                        markAsSold(widget.selling.id, context);
                      },
                      child: customContainer(
                          img: "assets/images/markSold.png",
                          txt: "Mark as Sold"),
                    ),
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            SellFaster(
                              selling: widget.selling,
                            ));
                      },
                      child: customContainer(
                          img: "assets/images/sellFaster.png",
                          txt: "Sell Faster"),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CustomDivider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: customRow(
                    onTap: () {
                      push(
                          context,
                          ItemPerformanceScreen(
                            selling: widget.selling,
                          ));
                    },
                    txt: "Item Performance",
                    img: "assets/images/performance.png"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CustomDivider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppText.appText("Message",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.txt1B20),
              ),

              const SizedBox(
                  // width: getWidth(context),
                  height: 300,
                  child: ChatScreen(isProductChat: true)),
              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: 3,
              //   itemBuilder: (context, index) {
              //     return customListview(
              //         img: "assets/images/sp2.png",
              //         title: "Anthony (Web3.io)",
              //         subtitle: "How are you today?",
              //         trailing: "9:54 AM",
              //         subTitleColor: const Color(0xff626C7B));
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> markAsSold(int? id, context) async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want mark item as sold ?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Mark as sold",
      context: context,
      loading: isLoading,
      onTap: () async {
        Navigator.of(context).pop();
        showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductSold}/$id");

          showSnackBar(context, responce["message"]);
          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context);
          }
          Navigator.of(context).pop(true);
          //
          // }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }

  Widget customRow({img, txt, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "$img",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer({img, txt}) {
    return Container(
      height: 75,
      width: 71,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19), color: AppTheme.appColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "$img",
              height: 18,
            ),
            AppText.appText(
              "$txt",
              textAlign: TextAlign.center,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.whiteColor,
            )
          ],
        ),
      ),
    );
  }

  Widget customListview({img, title, subtitle, trailing, subTitleColor}) {
    return Padding(
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
                    child: img.contains("https")
                        ? Image.network(
                            "$img",
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "$img",
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
                    AppText.appText("$title",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.txt1B20),
                    const SizedBox(
                      height: 5,
                    ),
                    AppText.appText("$subtitle",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: subTitleColor ?? AppTheme.txt1B20),
                  ],
                ),
              ],
            ),
            trailing == null
                ? const SizedBox.shrink()
                : AppText.appText("$trailing",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.lighttextColor),
          ],
        ),
      ),
    );
  }

  Future<void> markArchived(int id, setStatesss) async {
    setStatesss(() {
      loading = true;
    });

    try {
      var responce = await customGetRequest.httpGetRequest(
          url: "${AppUrls.markProductArchive}/$id");

      setStatesss(() {
        loading = false;
      });

      Navigator.of(context).pop();

      showSnackBar(context, responce["message"]);

      log("responce of markArchived = $responce");

      getSellingProducts(context);
    } catch (e) {
      setStatesss(() {
        loading = false;
      });
      Navigator.of(context).pop();

      showSnackBar(context, "Something went Wrong");
    }
  }
}
