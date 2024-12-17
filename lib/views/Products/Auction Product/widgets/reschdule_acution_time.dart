import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/custom_requests/payment_status_service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/enter_location_screen.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../Sellings/new_sold_screen.dart';

class RescheduleTimeProduct extends StatefulWidget {
  final productId;


  const RescheduleTimeProduct(
      {super.key, this.productId});

  @override
  State<RescheduleTimeProduct> createState() => _RescheduleTimeProductState();
}

class _RescheduleTimeProductState extends State<RescheduleTimeProduct> {
  String selectedOption = 'Auction';
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bidController =
      TextEditingController();


  DateTime? startDate;
  DateTime? endDate;
  DateTime? sellDate;

  bool isBack = false;

  var startTime;
  var endTime;
  var startDubaiTime;
  var endDubaiTime;
  late ProductViewModel productViewModel;

  bool showLastBid = false;

  @override
  void initState() {

    productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    firstTimeProductId=int.parse(widget.productId);
    getHighestBid();


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<ProductViewModel>(
          builder: (context, productViewModel, child) {
            return  Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AppButton.appButton("Confirm", onTap: () async {
                    DateTime now = DateTime.now();
                    DateFormat formatter = DateFormat.jm();

                    // Format the DateTime object
                    startTime = formatter.format(now);


                    startDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
                    startDubaiTime = convertToUTCTimeDateTime(startDate!, context);

                    if (endDate == null) {
                      showSnackBar(context, "Please enter extended date!");

                    }
                    else if(endTime == null){
                      showSnackBar(context, "Please enter extended time!");
                    }
                    else if (startDate!.difference(endDate!).inDays >= 1) {
                      showSnackBar(context, "Extended date cannot be earlier than the current date!");

                    }
                    // else if(startTime!.difference(endTime!).inSeconds > 1) {
                    //   showSnackBar(context, "Extended time cannot be earlier than the current time.");
                    //
                    // }
                    else{
                      extendProductTime();
                    }

                    },
                      height: 53,
                      loading: productViewModel.extendTimeLoading == true,
                      loadingColor: AppTheme.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      radius: 32.0,
                      backgroundColor: AppTheme.appColor,
                      textColor: AppTheme.whiteColor),
                );
        }
      ),
      appBar: CustomAppBar1(
        title: "Extend Auction Time",
        action: false,
        img: "assets/images/cross.png",
        actionOntap: () {
          // pushUntil(context, const BottomNavView());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

            auctionColumn(),
            ],
          ),
        ),
      ),
    );
  }



  Widget auctionColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AppText.appText("Extended Time",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateContainer(
                  onTap: () {
                    _selectTimeTwo(context);
                  },
                  nullText: "Extended Time",
                  dateCheck: endTime,
                  date: false)
            ],
          ),
          SizedBox(height: 15.h,),
          AppText.appText("Extended Date",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              dateContainer(
                  onTap: () {
                    _selectDate1(context);
                  },
                  nullText: "Extended Date",
                  dateCheck: endDate,
                  date: true)
            ],
          ),

          SizedBox(height: 30.h,),
          if(showLastBid == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText.appText("LAST OFFER",
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.text09),

                SizedBox(height: 12.h,),

                customTextField(),

                SizedBox(height: 15.h,),

              Consumer<ProductViewModel>(
                  builder: (context, productViewModel, child) {
                    return  productViewModel.loading ? const CircularProgressIndicator() :
                    AppButton.appButton(
                      "Accept",
                      onTap: (){
                        getAuctionProductDetail(productId: widget.productId, context: context);
                      },
                      height: 40.h,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      radius: 40.0,
                      backgroundColor: AppTheme.appColor ,
                      textColor: AppTheme.whiteColor,
                      borderColor: AppTheme.appColor ,

                    );
                  }),




                SizedBox(height: 7.h,),

                AppText.appText("When you accept the last bid, it means you’re committing to sell this item for the current highest bid",
                    fontSize: 12,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.hintTextColor),


              ],
            ),
          )
        ],
      ),
    );
  }


  void getHighestBid() async {

      final bidViewModel = Provider.of<BidsViewModel>(context, listen: false);

      bidViewModel.getHighestBids(int.parse(widget.productId.toString())).then((value){
        _bidController.text = "AED ${value["data"]["price"]}";
        showLastBid = true;
        setState(() {});
      }).onError((err, stackTrace){
        debugPrint("highest bid api ${err.toString()}");
      });

    }






  Widget customTextField({String? txt,
    String? hintText,

    TextInputType? textInputType}){
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.none,
          controller: _bidController,
          textAlign: TextAlign.center,  // This will horizontally center the text
          style: GoogleFonts.poppins(
              fontSize: 21,

              fontWeight: FontWeight.w600,
              color: AppTheme.yellowColor
          ),
          decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor
              ),
              hintText: hintText,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(bottom: 8.h)
          ),
          onChanged: (_){
            setState(() {

            });
          },
        ),
      ],
    );
  }

  void getAuctionProductDetail({productId, limit, context, bool markAsSold = false}) async {

    productViewModel.getProductDetails(int.parse(productId.toString())).then((value) {
      push(
          context,
          NewSoldScreen(
            title: value?.title,
            productId: value?.id.toString(),
            fixPrice: value?.fixPrice.toString(),
            auctionPrice: value?.auctionInitialPrice.toString(),
            image: value?.photo?.isNotEmpty ?? false ? value!.photo![0].url! : null,
            auction: value?.productType == "auction" ? true : false,
          ));

    }).onError((error, stackTrace){
      showSnackBar(context, error.toString());
    });
  }


  Widget dateContainer({
    onTap,
    headText,
    nullText,
    dateCheck,
    date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width * 0.60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderColor, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      date == true
                          ? AppText.appText(
                              dateCheck == null
                                  ? "$nullText"
                                  : DateFormat('MM-dd-yyyy').format(dateCheck!),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              textColor: dateCheck == null
                                  ? AppTheme.hintTextColor
                                  : AppTheme.hintTextColor)
                          : AppText.appText(
                          convertToTimeString(dateCheck,nullText) ?? "$nullText",
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              textColor: dateCheck == null
                                  ? AppTheme.hintTextColor
                                  : AppTheme.hintTextColor),
                      Image.asset(
                        date == true
                            ? "assets/images/calender.png"
                            : "assets/images/clock.png",
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  String convertToTimeString(dynamic value, nullText) {
    // Check if the value is a DateTime object
    if(value == null){
      return "$nullText";
    }


    if (value is DateTime) {
      // Convert only the time part to a string (HH:mm:ss format)
      return value.toIso8601String().split('T')[1].split('.')[0];
    }
    // Return the value as a string if it's not a DateTime object
    return value.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                  primary: AppTheme.appColor), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                  primary: AppTheme.appColor), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                  primary: AppTheme.appColor), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        startTime = picked.format(context);
      });
    }
  }

  Future<void> _selectTimeTwo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                  primary: AppTheme.appColor), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        endTime = picked.format(context);
        endDubaiTime = convertToUTC(picked, context);

      });
    }
  }

  Future<void> _selectSellDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: sellDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                  primary: AppTheme.appColor), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != sellDate) {
      setState(() {
        sellDate = picked;
      });
    }
  }


  extendProductTime() async {
    Map<String, dynamic> data = {
      "product_id": widget.productId,
      "starting_date": formatDate(startDate!),
      "starting_time": startDubaiTime,
      "ending_date": formatDate(endDate!),
      "ending_time": endDubaiTime,
    };

    productViewModel.rescheduleAuctionTime(data)
        .then((value) {
      showSnackBar(context, "Auction Time Reschedule Successfully",
          title: 'Congratulations!');
      Navigator.of(context).pop();
    })
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString());
    });
  }
}
