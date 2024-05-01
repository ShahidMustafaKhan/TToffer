import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';

class BoostWorkScreen extends StatefulWidget {
  const BoostWorkScreen({super.key});

  @override
  State<BoostWorkScreen> createState() => _BoostWorkScreenState();
}

class _BoostWorkScreenState extends State<BoostWorkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Boost My Listing",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AppText.appText("How boosting works",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textColor: AppTheme.txt1B20),
            customColumn(
                img: "assets/images/status-up.png",
                txt1: "Get more views",
                txt2:
                    "Promoted posts appear among the first spots buyers see and get an average of 14x more views."),
            const CustomDivider(),
            customColumn(
                img: "assets/images/graph.png",
                txt1: "Add a boosted spot",
                txt2:
                    "Your item appears as a new post in search results as well as in the promoted spot."),
            const CustomDivider(),
            customColumn(
                img: "assets/images/hashtag.png",
                txt1: "Boosted spots are shared",
                txt2:
                    "Don't worry if you don't see your item at the top of the feed. Spots are shared between sellers")
          ],
        ),
      ),
    );
  }

  Widget customColumn({img, txt1, txt2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "$img",
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: AppText.appText("$txt1",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: AppTheme.txt1B20),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AppText.appText("$txt2",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.txt1B20),
          )
        ],
      ),
    );
  }
}
