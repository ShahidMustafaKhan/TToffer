import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class MakeOfferScreen extends StatefulWidget {
  final data;
  const MakeOfferScreen({super.key, this.data});

  @override
  State<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends State<MakeOfferScreen> {
  final TextEditingController _priceController = TextEditingController();
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    _priceController.text = "\$ 60";
    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatApiProvider = Provider.of<ChatApiProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Make Your Offer",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 70,
                  width: screenSize.width,
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: widget.data["photo"].isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                        "${widget.data["photo"][0]["src"]}"),
                                    fit: BoxFit.fill)
                                : null),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.appText("${widget.data["title"]}",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.txt1B20),
                          AppText.appText("\$${widget.data["fix_price"]}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              textColor: AppTheme.textColor),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  AppText.appText("Enter Your Offer",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.textColor),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomAppFormField(
                    texthint: "",
                    controller: _priceController,
                    width: 161,
                    textAlign: TextAlign.center,
                    fontsize: 24,
                    fontweight: FontWeight.w600,
                    cPadding: 2.0,
                    type: TextInputType.number,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: AppButton.appButton("Send Offer", onTap: () {
                  String priceWithoutDollarSign =
                      _priceController.text.replaceAll('\$', '');
                  chatApiProvider.makeOffer(
                      dio: dio,
                      context: context,
                      productId: widget.data["id"],
                      sellerId: widget.data["user"]["id"],
                      buyerId: int.parse(userId),
                      offerPrice: int.parse(priceWithoutDollarSign));
                  // push(
                  //     context,
                  //     OfferChatScreen(
                  //       offerPrice: priceWithoutDollarSign,
                  //       isOffer: true,
                  //     ));
                },
                    height: 53,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    radius: 32.0,
                    backgroundColor: AppTheme.appColor,
                    textColor: AppTheme.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
