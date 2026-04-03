import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../../../main.dart';
import '../../../../models/product_model.dart';
import '../../../../view_model/offer/offer_view_model.dart';

class MakeOfferScreen extends StatefulWidget {
  final Product? product;

  const MakeOfferScreen({super.key, this.product});

  @override
  State<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends State<MakeOfferScreen> {
  final TextEditingController _priceController = TextEditingController();
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  Product? product;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    product = widget.product;
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    setState(() {
      userId = int.parse(pref.getString(PrefKey.userId)!);
    });
  }

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar:  CustomAppBar1(
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
                            image: (product?.photo?.isNotEmpty ?? false)
                                ? DecorationImage(
                                    image: NetworkImage(
                                        product!.photo![0].url!),
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
                          AppText.appText(product?.title ?? '',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.txt1B20),
                          AppText.appText("AED ${formatNumber(product?.fixPrice?.toString() ?? '',textFiled: false)}",
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
                    texthint: "AED",
                    hintStyle: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
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
              Consumer<OfferViewModel>(
                  builder: (context, offerViewModel, child) {
                    return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: offerViewModel.offerLoading
                        ? CircularProgressIndicator(color: AppTheme.appColor)
                        : AppButton.appButton("Send Offer", onTap: () async {
                          if(_priceController.text.isNotEmpty){
                            setState(() {
                              loader = true;
                            });
                            String priceWithoutDollarSign =
                            _priceController.text.replaceAll('\$', '');

                            offerViewModel.makeOffer(
                                product?.id,
                                product?.userId,
                                userId,
                                int.parse(priceWithoutDollarSign))
                                .then((value){
                                  Navigator.of(context).pop();
                              showSnackBar(context, "Offer placed successfully", title: 'Congratulations!');

                            }).onError((error, stackTrace){
                              showSnackBar(context, error.toString());
                            });

                          }
                          else{
                            showSnackBar(context, 'Please add an offer before submitting.');
                          }


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
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
