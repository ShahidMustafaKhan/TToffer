import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/Profile%20Screen/profile_screen.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: const CustomAppBar1(
          title: "Profile",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upperContainer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    verifiedContainer(
                        txt: "Email Verified", img: "assets/images/sms.png"),
                    verifiedContainer(
                        txt: "Image Verified",
                        img: "assets/images/gallery.png"),
                    verifiedContainer(
                        txt: "Phone Verified", img: "assets/images/call.png"),
                    verifiedContainer(
                        txt: "Join TruYou", img: "assets/images/verify1.png"),
                  ],
                ),
                AppText.appText("Products",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: AppTheme.txt1B20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ListViewContainer();
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget verifiedContainer({img, txt, color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 80,
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color ?? AppTheme.appColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "$img",
                  height: 20,
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              child: AppText.appText("$txt",
                  textAlign: TextAlign.center,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.txt1B20),
            ),
          ],
        ),
      ),
    );
  }

  Widget upperContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 92,
                  width: 80,
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppTheme.text09,
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              color: AppTheme.whiteColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("assets/images/camera.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AppText.appText("Darlene Robertson",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.txt1B20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const StarRating(
                      percentage: 20,
                      color: Colors.yellow,
                      size: 14,
                    ),
                    AppText.appText("5.0",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.txt1B20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
