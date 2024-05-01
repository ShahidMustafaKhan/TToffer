import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Sellings/item_performance.dart';

class ItemDashBoard extends StatefulWidget {
  const ItemDashBoard({super.key});

  @override
  State<ItemDashBoard> createState() => _ItemDashBoardState();
}

class _ItemDashBoardState extends State<ItemDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customListview(
                  img: "assets/images/auction1.png",
                  title: "Modern Light Clothes",
                  subtitle: "\$500"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customContainer(
                        img: "assets/images/eye.png", txt: "View Post"),
                    customContainer(
                        img: "assets/images/edit.png", txt: "Edit Post"),
                    customContainer(
                        img: "assets/images/markSold.png", txt: "Mark as Sold"),
                    customContainer(
                        img: "assets/images/sellFaster.png",
                        txt: "Sell Faster"),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CustomDivider(),
              ),
              customRow(
                  onTap: () {
                    push(context, const ItemPerformanceScreen());
                  },
                  txt: "Item Performance",
                  img: "assets/images/performance.png"),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CustomDivider(),
              ),
              AppText.appText("Message",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.txt1B20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return customListview(
                      img: "assets/images/sp2.png",
                      title: "Anthony (Web3.io)",
                      subtitle: "How are you today?",
                      trailing: "9:54 AM",
                      subTitleColor: const Color(0xff626C7B));
                },
              )
            ],
          ),
        ),
      ),
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
                    child: Image.asset(
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
}
