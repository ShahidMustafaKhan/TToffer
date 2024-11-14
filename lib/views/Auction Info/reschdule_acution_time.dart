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
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/enter_location_screen.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../Controller/APIs Manager/product_api.dart';
import '../Sellings/new_sold_screen.dart';

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
  bool _isLoading = false;
  bool _isLoadingAcceptBtn = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  int _toggleValue = 0;
  bool showLastBid = false;

  @override
  void initState() {

    firstTimeProductId=int.parse(widget.productId);
    dio = AppDio(context);
    logger.init();
    getHighestBid();



    // Define a DateFormat with the expected date format
    DateFormat dateFormat = DateFormat('MM-dd-yyyy');




    super.initState();
  }

  // getPaymentStatus() async {
  //   await PaymentStatusService()
  //       .paymentStatusService(context: context, selling: widget.selling);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading == true
            ? LoadingDialog()
            : AppButton.appButton("Confirm", onTap: () async {
              DateTime now = DateTime.now();
              DateFormat formatter = DateFormat.jm();

              // Format the DateTime object
              startTime = formatter.format(now);


              startDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
              startDubaiTime = convertToDubaiTimeDateTime(startDate!, context);

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
                fontWeight: FontWeight.w500,
                fontSize: 14,
                radius: 32.0,
                backgroundColor: AppTheme.appColor,
                textColor: AppTheme.whiteColor),
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

                _isLoadingAcceptBtn ? const CircularProgressIndicator() :
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

                ),

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
      var response;
      int responseCode200 = 200; // For successful request.
      int responseCode400 = 400; // For Bad Request.
      int responseCode401 = 401; // For Unauthorized access.
      int responseCode404 = 404; // For For data not found
      int responseCode422 = 422; // For For data not found
      int responseCode500 = 500; // Internal server error.
      Map<String, dynamic> params = {
        "product_id": "${widget.productId}",
      };

      try {
        response = await dio.post(
            path: AppUrls.highestBid,
            data: params);

        var responseData = response.data;
        if (response.statusCode == responseCode400) {
          showSnackBar(context, "${responseData["msg"]}");
          setState(() {
            _isLoading = false;
          });
        } else if (response.statusCode == responseCode401) {
          showSnackBar(context, "${responseData["msg"]}");
          setState(() {
            _isLoading = false;
          });
        } else if (response.statusCode == responseCode404) {
          showSnackBar(context, "${responseData["msg"]}");
          setState(() {
            _isLoading = false;
          });
        } else if (response.statusCode == responseCode500) {
          showSnackBar(context, "${responseData["msg"]}");
          setState(() {
            _isLoading = false;
          });
        } else if (response.statusCode == responseCode422) {
          setState(() {
            _isLoading = false;
          });
        } else if (response.statusCode == responseCode200) {


           if(responseData == null || responseData["data"]==null){
             showLastBid = false;
           }
           else {
             _bidController.text = "AED ${responseData["data"]["price"]}";
             showLastBid = true;
           }
           setState(() {
             _isLoading = false;
           });

        }
      } catch (e) {
        print("Something went Wrong $e");
        showSnackBar(context, "Something went Wrong.");
        setState(() {
          _isLoading = false;
        });
      }
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
    setState(() {
      _isLoadingAcceptBtn = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;

      if (response.statusCode == responseCode400) {
        setState(() {
          _isLoadingAcceptBtn = false;
        });
      } else if (response.statusCode == responseCode401) {
        setState(() {
          _isLoadingAcceptBtn = false;
        });
      } else if (response.statusCode == responseCode404) {
        setState(() {
          _isLoadingAcceptBtn = false;
        });

      } else if (response.statusCode == responseCode500) {

        setState(() {
          _isLoadingAcceptBtn = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoadingAcceptBtn = false;
        });
      } else if (response.statusCode == responseCode200) {
        var detailResponse = responseData["data"];
        setState(() {
          _isLoadingAcceptBtn = false;
        });

        if(detailResponse.isEmpty){
        }
        else {
            push(
                context,
                NewSoldScreen(
                  title: detailResponse[0]['title'],
                  productId: detailResponse[0]['id'].toString(),
                  fixPrice: detailResponse[0]['fix_price'],
                  auctionPrice: detailResponse[0]['auction_price'],
                  image: detailResponse[0]['photo']!=null && detailResponse[0]['photo'].isNotEmpty ? detailResponse[0]['photo'][0]['src'] : null,
                  auction: detailResponse[0]['fix_price'] != null ? false : true,
                ));

        }


      }
    } catch (e) {
      setState(() {
        _isLoadingAcceptBtn = false;
      });
      print("Something went Wrong ${e}");

    }
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
        endDubaiTime = convertToDubaiTime(picked, context);

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
    setState(() {
      _isLoading = true;
    });


    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500;
    Map<String, dynamic> params = {
      "product_id": widget.productId,
      "starting_date": formatDate(startDate!),
      "starting_time": startDubaiTime,
      "ending_date": formatDate(endDate!),
      "ending_time": endDubaiTime,
    };


    try {
      response = await dio.post(
          path:  AppUrls.rescheduleAuctionTime,
          data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          _isLoading = false;
        });

        Provider.of<ProductsApiProvider>(context, listen: false).getAuctionProducts(
          dio: dio,
          context: context,
        );

        showSnackBar(context, "${responseData["msg"]}", title: 'Congratulations!');
        Navigator.of(context).pop();


      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
