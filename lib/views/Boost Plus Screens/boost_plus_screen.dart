import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/views/Boost%20Plus%20Screens/boost_work.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';

import '../../models/product_model.dart';

class BoostPlusScreen extends StatefulWidget {
  const BoostPlusScreen({super.key, required this.product});

  final Product? product;

  @override
  State<BoostPlusScreen> createState() => _BoostPlusScreenState();
}

class _BoostPlusScreenState extends State<BoostPlusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        child: AppButton.appButton("Next", height: 53, onTap: () {
          push(context, const BoostWorkScreen());
        },
            fontSize: 14,
            fontWeight: FontWeight.w500,
            backgroundColor: AppTheme.appColor,
            textColor: AppTheme.white,
            radius: 32.0),
      ),
      appBar: CustomAppBar1(
        title: "Boost My Listing",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset("assets/images/boost.png"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AppText.appText("Sell faster with Boost Plus",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.txt1B20),
              ),
              customRow(txt: "Get an average of 20x more views each day"),
              customRow(txt: "Promote for multiple days"),
              customRow(txt: "Switch promotion to any item."),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AppButton.appButtonWithLeadingImage("Boost Plus",
                    border: true, onTap: () {
                  push(
                      context,
                      SellFaster(
                        product: widget.product,
                      ));
                  // showSnackBar(context, "SellFaster page");
                },
                    imagePath: "assets/images/boostPlus.png",
                    imgHeight: 20,
                    height: 53,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderColor: AppTheme.appColor,
                    textColor: AppTheme.appColor,
                    containerWidth: 120,
                    radius: 32.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AppText.appText("Ready a subscriber?",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.txt1B20),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AppText.appText(
                    "To change your subscription visit your App store. If you cancel, your subscription will run to the end of this billing period",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow({txt}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/shield-tick.png",
            height: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.79,
            child: AppText.appText("$txt",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.txt1B20),
          ),
        ],
      ),
    );
  }
}
