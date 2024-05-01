import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/View/Post%20screens/enter_location_screen.dart';
import 'package:tt_offer/View/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class SetPostPriceScreen extends StatefulWidget {
  final productId;
  const SetPostPriceScreen({super.key, this.productId});

  @override
  State<SetPostPriceScreen> createState() => _SetPostPriceScreenState();
}

class _SetPostPriceScreenState extends State<SetPostPriceScreen> {
  String selectedOption = 'Fixed Price';
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _startingPriceController =
      TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? sellDate;

  var startTime;
  var endTime;
  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  int _toggleValue = 0;
  @override
  void initState() {
    _priceController.text = "60";
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading == true
            ? LoadingDialog()
            : AppButton.appButton("Next", onTap: () {
                addProducrPrice();
              },
                height: 53,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                radius: 32.0,
                backgroundColor: AppTheme.appColor,
                textColor: AppTheme.whiteColor),
      ),
      appBar: CustomAppBar1(
        title: "Price",
        action: true,
        img: "assets/images/cross.png",
        actionOntap: () {
          pushUntil(context, const BottomNavView());
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
              StepsIndicator(
                conColor1: AppTheme.appColor,
                circleColor1: AppTheme.appColor,
                circleColor2: AppTheme.appColor,
                conColor2: AppTheme.appColor,
                conColor3: AppTheme.appColor,
                circleColor3: AppTheme.appColor,
              ),
              const SizedBox(
                height: 20,
              ),
              selectOption(),
              if (selectedOption == "Fixed Price") fixedColumn(),
              if (selectedOption == "Auction") auctionColumn(),
              if (selectedOption == "Sell to Ux") uXColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.3) {
            setState(() {
              selectedOption = 'Fixed Price';
            });
          } else if (tapPosition < screenWidth * 0.6) {
            setState(() {
              selectedOption = 'Auction';
            });
          } else {
            setState(() {
              selectedOption = 'Sell to Ux';
            });
          }
        },
        child: Container(
          height: 38,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Fixed Price'
                        ? AppTheme.appColor
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Fixed Price',
                    style: TextStyle(
                      color: selectedOption == 'Fixed Price'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    color: selectedOption == 'Auction'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Auction',
                    style: TextStyle(
                      color: selectedOption == 'Auction'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'Sell to Ux'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Sell to Ux',
                    style: TextStyle(
                      color: selectedOption == 'Sell to Ux'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fixedColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          AppText.appText("Enter Your Price",
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
          const SizedBox(
            height: 40,
          ),
          const CustomDivider(),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("Firm on price",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.txt1B20),
              Switch(
                activeColor: AppTheme.appColor,
                value: _toggleValue == 1,
                onChanged: (bool value) {
                  setState(() {
                    _toggleValue = value ? 1 : 0;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const CustomDivider()
        ],
      ),
    );
  }

  Widget auctionColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LableTextField(
            labelTxt: "Starting Price",
            hintTxt: "Starting Price",
            controller: _startingPriceController,
            width: MediaQuery.of(context).size.width,
          ),
          AppText.appText("Time",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateContainer(
                  onTap: () {
                    _selectTime(context);
                  },
                  headText: "Starting Time",
                  nullText: "Start TIme",
                  dateCheck: startTime,
                  date: false),
              dateContainer(
                  onTap: () {
                    _selectTimeTwo(context);
                  },
                  headText: "Ending Time",
                  nullText: "End Time",
                  dateCheck: endTime,
                  date: false)
            ],
          ),
          AppText.appText("Date",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateContainer(
                  onTap: () {
                    _selectDate(context);
                  },
                  headText: "Starting Date",
                  nullText: "Start Date",
                  dateCheck: startDate,
                  date: true),
              dateContainer(
                  onTap: () {
                    _selectDate1(context);
                  },
                  headText: "Ending Date",
                  nullText: "End Date",
                  dateCheck: endDate,
                  date: true)
            ],
          )
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText("$headText",
              fontSize: 10,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width * 0.4,
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
                              dateCheck == null ? "$nullText" : dateCheck,
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

  Widget uXColumn() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: AppText.appText(
                  "Kindly schedule a convenient date for a meeting with our specialist to assess your items.",
                  textColor: AppTheme.hintTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              onTap: () {
                _selectSellDate(context);
              },
              child: Image.asset(
                "assets/images/calender.png",
                height: 18,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("Selected Date:",
                  textColor: AppTheme.hintTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
              AppText.appText(
                  sellDate == null
                      ? ""
                      : DateFormat('MM-dd-yyyy').format(sellDate!),
                  textColor: AppTheme.txt1B20,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ],
          ),
        ),
      ],
    );
  }

  void addProducrPrice() async {
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
      "fix_price": _priceController.text,
      "firm_on_price": _toggleValue,
      "auction_price": _startingPriceController.text,
      "starting_date": startDate,
      "starting_time": startTime,
      "ending_date": endDate,
      "ending_time": endTime,
      "sell_to_us": sellDate,
    };
    if (selectedOption == "Fixed Price") {
      params.remove("auction_price");
      params.remove("starting_date");
      params.remove("starting_time");
      params.remove("ending_date");
      params.remove("ending_time");
      params.remove("sell_to_us");
    } else if (selectedOption == "Auction") {
      params.remove("fix_price");
      params.remove("firm_on_price");
      params.remove("sell_to_us");
    } else if (selectedOption == "Sell to Ux") {
      params.remove("fix_price");
      params.remove("firm_on_price");
      params.remove("auction_price");
      params.remove("starting_date");
      params.remove("starting_time");
      params.remove("ending_date");
      params.remove("ending_time");
    }

    try {
      response = await dio.post(path: AppUrls.addProductPrice, data: params);
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
          pushReplacement(
              context,
              PostLocationScreen(
                productId: widget.productId,
              ));
          _isLoading = false;
        });
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
