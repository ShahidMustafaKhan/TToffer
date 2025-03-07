import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/highest_bid_popup.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../Profile Screen/profile_screen.dart';
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
  var startUtcTime;
  var endUtcTime;
  late ProductViewModel productViewModel;

  bool showLastBid = false;
  BidsData? highestBidData;

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
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal : 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal : 50.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText.appText("Extend date and time",
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.text09),

                SizedBox(height: 12.h,),
                dateContainer(
                    onTap: () {
                      _selectTimeTwo(context);
                    },
                    nullText: "Extended Time",
                    dateCheck: endTime,
                    date: false),
                SizedBox(height: 18.h,),
                dateContainer(
                    onTap: () {
                      _selectDate1(context);
                    },
                    nullText: "Extended Date",
                    dateCheck: endDate,
                    date: true),
                SizedBox(height: 25.h,),


                Consumer<ProductViewModel>(
                    builder: (context, productViewModel, child) {
                      return  AppButton.appButton("Confirm", onTap: () async {
                        DateTime now = DateTime.now();
                        DateFormat formatter = DateFormat.jm();

                        // Format the DateTime object
                        startTime = formatter.format(now);


                        startDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
                        startUtcTime = convertToUTCTimeDateTime(startDate!);

                        if (endDate == null) {
                          showSnackBar(context, "Please enter extended date!");
                        }
                        else if(endTime == null){
                          showSnackBar(context, "Please enter extended time!");
                        }
                        else if(selectedOption == "Auction" && isEndDateTimeValid(startDate!, startTime, endDate!, endTime) == false){
                          showSnackBar(context, "The auction's ending date and time must be at least 1 hour after its starting date and time.");
                        }
                        else if(selectedOption == "Auction" && isEndDateTimeWithinOneWeek(startDate!, startTime, endDate!, endTime) == false){
                          showSnackBar(context, "The auction's end date and time must not exceed one week from its start date and time.");
                        }
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
                          backgroundColor: startTime == null && endTime == null ? Colors.grey.shade400 : AppTheme.appColor,
                          borderColor: startTime == null && endTime == null ? Colors.grey.shade400 : AppTheme.appColor,
                          textColor: AppTheme.whiteColor);
                    }
                ),
              ],
            ),
          ),



          SizedBox(height: 18.h,),

          if(showLastBid == true)
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 1.5, // Adjust thickness
                    color: Colors.grey, // Adjust color
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Space around the text
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 21.sp, // Adjust font size as per your scaling
                      fontWeight: FontWeight.bold, // Optional styling
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),


          SizedBox(height: 18.h,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                if(showLastBid == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.appText("Current Highest Bid",
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            textColor: AppTheme.text09),

                        SizedBox(height: 12.h,),

                        _upperContainer(),

                        customTextField(),

                        SizedBox(height: 25.h,),

                        AppButton.appButton(
                          "Accept",
                          onTap: (){
                            if(startTime == null && endTime == null) {
                              highestPlaceBidDialog(context, highestBidData?.productId);
                            }
                          },
                          height: 53,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          radius: 40.0,
                          backgroundColor: startTime != null || endTime != null ? Colors.grey.shade400 : AppTheme.appColor,
                          borderColor: startTime != null || endTime != null ? Colors.grey.shade400 : AppTheme.appColor,
                          textColor: AppTheme.whiteColor,

                        ),



                      ],
                    ),
                  )
              ],
            ),
          )

        ],
      ),
    );
  }


  Widget _upperContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: highestBidData?.user?.img ==
                          null
                          ? const AssetImage(
                          'assets/images/default_image.png')
                          : NetworkImage(highestBidData!.user!.img!) as ImageProvider<Object>,
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(16)),
            ),
            SizedBox(height: 15.h,),
            Column(
              children: [
                AppText.appText(capitalizeWords(highestBidData?.user?.name ?? ''),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.txt1B20),

                SizedBox(height: 6.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: highestBidData?.user?.reviewPercentage == null || highestBidData?.user?.reviewPercentage == 0 ? 40.w : 12.w,),
                    StarRating(
                      percentage: percentageOfFive(highestBidData?.user?.reviewPercentage?.round() ?? 0),
                      color: Colors.yellow,
                      size: 25,
                    ),
                    SizedBox(width: 3.w,),
                    if(highestBidData?.user?.reviewPercentage != null)
                      AppText.appText(
                          starCount(highestBidData?.user?.reviewPercentage),
                          fontSize: highestBidData?.user?.reviewPercentage == null || highestBidData?.user?.reviewPercentage == 0.0 ? 11.sp : 12.sp,
                          fontWeight: FontWeight.normal,
                          textColor: AppTheme.txt1B20),
                  ],
                ),
                //   Row(

                SizedBox(height: 8.h,),


              ],
            ),

          ],
        ),
      ],
    );
  }


  void getHighestBid() async {

      final bidViewModel = Provider.of<BidsViewModel>(context, listen: false);

      bidViewModel.getHighestBids(int.parse(widget.productId.toString())).then((value){
        _bidController.text = "AED ${value.price}";
        showLastBid = true;
        highestBidData = value;
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
          enabled: false,
          controller: _bidController,
          textAlign: TextAlign.center, // This will horizontally center the text
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
              disabledBorder: OutlineInputBorder(),
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




  Widget dateContainer({
    onTap,
    headText,
    nullText,
    dateCheck,
    date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
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
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              textColor: dateCheck == null
                                  ? AppTheme.hintTextColor
                                  : AppTheme.hintTextColor)
                          : AppText.appText(
                          convertToTimeString(dateCheck,nullText) ?? "$nullText",
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              textColor: dateCheck == null
                                  ? AppTheme.hintTextColor
                                  : AppTheme.hintTextColor),
                      dateCheck != null ?
                          GestureDetector(
                              onTap: (){
                                if(date == true){
                                  endDate = null;
                                }
                                else{
                                  endTime = null;
                                  endUtcTime = null;
                                }
                                setState(() {

                                });
                              },
                              child: const Icon(Icons.remove_circle, size : 17, color: Colors.red,)) :
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
        endUtcTime = convertToUTC(picked);

      });
    }
  }



  extendProductTime() async {
    Map<String, dynamic> data = {
      "product_id": widget.productId,
      "starting_date": formatDate(startDate!),
      "starting_time": startUtcTime,
      "ending_date": formatDate(endDate!),
      "ending_time": endUtcTime,
      "auction_end_date_time": formatDateTime(combineDateAndTime(endUtcTime, endDate!)),
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

