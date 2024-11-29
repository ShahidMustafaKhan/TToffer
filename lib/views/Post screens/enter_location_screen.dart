import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/stripe_payment_screen.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Homepage/LandingPage/landing_screen.dart';
import 'package:tt_offer/views/Post%20screens/google_map_screen.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/views/Post%20screens/post_product_payment.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';

import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Controller/image_provider.dart';
import '../../providers/selling_purchase_provider.dart';

class PostLocationScreen extends StatefulWidget {
  final productId;

  Selling? selling;

  String title;
  String? selectedCategory;
  int amount;

  PostLocationScreen(
      {super.key,
      this.productId,
      this.selling,
      this.selectedCategory,
      required this.amount,
      required this.title});

  @override
  State<PostLocationScreen> createState() => _PostLocationScreenState();
}

class _PostLocationScreenState extends State<PostLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;
  bool done = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool isSelectedCategoryJob = false;
  bool isSelectedCategoryProperty = false;

  bool isBack = false;

  bool pickupOnly = false;

  bool localDelivery = false;

  bool addShipping = false;



  @override
  void initState() {



    dio = AppDio(context);
    logger.init();

    if (widget.selling != null) {
      _locationController.text = widget.selling!.location!;
    }
    else{
      _locationController.text = Provider.of<ProfileApiProvider>(context, listen: false).profileData?["location"] ?? '';
    }

    if(widget.selectedCategory != null && widget.selectedCategory == 'Jobs'){
      isSelectedCategoryJob = true;
    }

    if(widget.selectedCategory != null && (widget.selectedCategory == 'Property for Sale' || widget.selectedCategory == 'Property for Rent') ){
      isSelectedCategoryProperty = true;
    }

    // print('location--->${widget.selling!.location??''}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        Provider.of<ImageNotifyProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        pushReplacement(context, BottomNavView());
        return false; // Return false to indicate that the route should not be popped
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<PostProductViewModel>(
              builder: (context, provider, child){
                return provider.lastStepLoading == true
                  ? LoadingDialog()
                  : AppButton.appButton(done == true && isBack == false ? "Done" : "Next", onTap: () {
                    if(done == true && isBack == false) {

                      imageProvider.imagePaths.clear();
                      imageProvider.vedioPath = '';

                      pushUntil(context, const BottomNavView(showDialog: true,));
                    }
                    else {
                      if(_locationController.text.isNotEmpty) {
                        addLocation(provider);
                      } else{
                        showSnackBar(context, "Please add your location.");
                      }
                    }
                    },
                      height: 53,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      radius: 32.0,
                      backgroundColor: AppTheme.appColor,
                      textColor: AppTheme.whiteColor);
            }
          ),
        ),
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(
          title: "Finish",
          actionOntap: () {
            pushUntil(context, const BottomNavView());
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: StepsIndicator(
                    conColor1: AppTheme.appColor,
                    circleColor1: AppTheme.appColor,
                    circleColor2: AppTheme.appColor,
                    conColor2: AppTheme.appColor,
                    conColor3: AppTheme.appColor,
                    circleColor3: AppTheme.appColor,
                    circleColor4: AppTheme.appColor,
                    categoryNameJob: isSelectedCategoryJob,

                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomDivider(),
                const SizedBox(
                  height: 20,
                ),
                LableTextField(
                  labelTxt: "Set a Location (Required)",
                  hintTxt: "Set a location",
                  readOnly: true,
                  onTap: (){ Navigator.push(context, CupertinoPageRoute(builder: (_) => GoogleMapView())).then((value){
                    if(value!=null) {
                      _locationController.text = value;
                      setState(() {

                      });
                    }
                  });},
                  controller: _locationController,
                ),



                if(isSelectedCategoryJob == false && isSelectedCategoryProperty == false) ... [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      // customCheckBox(
                      //     propertyAttributes!=null ?  propertyAttributes!.owner=='Owner'
                      //         ? true
                      //         : owner : owner, (val) {
                      //   owner = val!;
                      //   dealer = false;
                      //   selectDealer = 'Owner';
                      //   print(selectDealer);
                      //   setState(() {});
                      // }, 'Owner'),
                      // customCheckBox(
                      //     propertyAttributes!=null ? propertyAttributes!.owner=='Dealer'
                      //         ? true
                      //         : dealer :  dealer, (val) {
                      //   dealer = val!;
                      //   selectDealer = 'Dealer';
                      //   print(selectDealer);
                      //
                      //   owner = false;
                      //   setState(() {});
                      // }, 'Dealer'),
                    ],
                  ),

                Image.asset("assets/images/shipping.png"),

                  SizedBox(height:15.h),

                  AppButton.appButton(
                      "ADD SHIPPING",
                      height: 38.h,
                      fontWeight: FontWeight.w500,
                      padding : EdgeInsets.symmetric( vertical: 2.h),
                      fontSize: 15,
                      radius: 12.0,
                      backgroundColor: addShipping == true ? AppTheme.yellowColor : null,
                      textColor: addShipping == true ? AppTheme.whiteColor : AppTheme.appColor,
                      borderColor:  addShipping == true ? AppTheme.yellowColor : null,
                      onTap:(){
                        addShipping = !addShipping;
                        setState(() {});}
                  ),
                  SizedBox(height:12.h),
                  AppButton.appButton(
                      "LOCAL DELIVERY",
                      height: 38.h,
                      fontWeight: FontWeight.w500,
                      padding : EdgeInsets.symmetric( vertical: 2.h),
                      fontSize: 15,
                      radius: 12.0,
                      backgroundColor: localDelivery == true ? AppTheme.yellowColor : null,
                      textColor: localDelivery == true ? AppTheme.whiteColor : AppTheme.appColor,
                      borderColor:  localDelivery == true ? AppTheme.yellowColor : null,
                      onTap:(){
                        localDelivery = !localDelivery;
                        setState(() {});}
                  ),
                  SizedBox(height:12.h),
                  AppButton.appButton(
                      "PICKUP ONLY",
                      height: 38.h,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      radius: 12.0,
                      borderColor:  pickupOnly == true ? AppTheme.yellowColor : null,
                      backgroundColor: pickupOnly == true ? AppTheme.yellowColor : null,
                      textColor: pickupOnly == true ? AppTheme.whiteColor : AppTheme.appColor,
                      onTap:(){
                        pickupOnly = !pickupOnly;
                        setState(() {});}
                  ),

                // Align(
                //   alignment: Alignment.center,
                //   child: AppText.appText("ADD SHIPPING",
                //       fontSize: 16,
                //       textAlign: TextAlign.center,
                //       fontWeight: FontWeight.w700,
                //       textColor: AppTheme.blackColor),
                // ),


                ],
                if(isSelectedCategoryJob == true && isSelectedCategoryProperty == false)...[
                  Image.asset('assets/images/hand_shake.png'),

                  const SizedBox(
                    height: 0,
                  ),
                  Container(
                    child: AppText.appText(
                        "Give your job ad a boost and reach millions across the country for faster results!.",
                        fontSize: 12,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.blackColor),
                  ),
                ]


              ],
            ),
          ),
        ),
      ),
    );
  }

  void addLocation(PostProductViewModel provider) async {

    Map<String, dynamic> params = {
      "product_id": widget.productId,
      "location": _locationController.text,
      "Local_Delivery": localDelivery==true ? 1 : 0,
      "Pick_Up": pickupOnly==true ? 1 : 0,
      "Shipping": addShipping==true ? 1 : 0,
    };

    provider.addProductLastStep(params, update: widget.selling != null || isBack == true).then((value) async {

      // await getSellingProducts(context);
      //
      // for (var element in Provider.of<SellingPurchaseProvider>(context, listen: false).sellingProductsModel!.data!.selling!) {
      //   if (element.id == widget.selling!.id) {
      //     widget.selling = element;
      //   }
      // }
      //
      // if(widget.selling != null) {
      //   Navigator.push(context, CupertinoPageRoute(builder: (_) =>
      //       SellFaster(
      //         selling: widget.selling!,
      //         fromLocation: true,
      //       ),)).then((value){
      //     setState(() {
      //       isBack = true;
      //     });
      //   });
      // provider.setLastStepLoading(false);
      // }

      pushUntil(context, BottomNavView(showDialog: true,));

    }).onError((error, stackTrace){
      provider.setLastStepLoading(false);
      showSnackBar(context, error.toString());
    });

    // try {
    //   response = await dio.post(
    //       path: widget.selling != null || isBack==true
    //           ? AppUrls.updateProductLocation
    //           : AppUrls.addProductLocation,
    //       data: params);
    //   var responseData = response.data;
    //   if (response.statusCode == responseCode400) {
    //     showSnackBar(context, "${responseData["msg"]}");
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (response.statusCode == responseCode401) {
    //     showSnackBar(context, "${responseData["msg"]}");
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (response.statusCode == responseCode404) {
    //     showSnackBar(context, "${responseData["msg"]}");
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (response.statusCode == responseCode500) {
    //     showSnackBar(context, "${responseData["msg"]}");
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (response.statusCode == responseCode422) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (response.statusCode == responseCode200) {
    //     setState(() {
    //       _isLoading = false;
    //       done=true;
    //     });
    //     // showSnackBar(context, responseData["msg"]);
    //
    //     widget.selling = Selling.fromJson(responseData["data"]);
    //
    //
    //     await getSellingProducts(context);
    //
    //     for (var element in Provider.of<SellingPurchaseProvider>(context, listen: false).sellingProductsModel!.data!.selling!) {
    //       if (element.id == widget.selling!.id) {
    //         widget.selling = element;
    //       }
    //     }
    //
    //     if(widget.selling != null) {
    //       Navigator.push(context, CupertinoPageRoute(builder: (_) =>
    //         SellFaster(
    //           selling: widget.selling!,
    //           fromLocation: true,
    //         ),)).then((value){
    //       setState(() {
    //         isBack = true;
    //       });
    //     });
    //     }



        // pushReplacement(
        //     context,
        //     PostProductPayment(
        //       amount: widget.amount,
        //       productId: widget.selling == null
        //           ? widget.productId
        //           : widget.selling!.id,
        //       title: widget.title,
        //       selling: widget.selling,
        //     ));
    //   }
    // } catch (e) {
    //   print("Something went Wrong ${e}");
    //   // showSnackBar(context, "Something went Wrong.");
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }


   getSellingProducts(context) async {
    log("getSellingProducts fired");

    var response;

    // try {
    response = await dio.get(path: AppUrls.sellingScreen);
    var responseData = response.data;
    if (response.statusCode == 200) {
      // sellingData = responseData["sold"];
      SellingProductsModel model = SellingProductsModel.fromJson(responseData);

      Provider.of<SellingPurchaseProvider>(context, listen: false)
          .updateData(model: model);
      // purchaseData = responseData["purchase"];
      // archieveData = responseData["archive"];
    }
    // } catch (e) {
    //   print("Something went Wrong $e");
    //   showSnackBar(context, "Something went Wrong.");
    // }
  }
}
