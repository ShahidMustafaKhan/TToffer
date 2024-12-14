import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/enter_location_screen.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../models/product_model.dart';

class SetPostPriceScreen extends StatefulWidget {
  final productId;
  String title;
  Product? product;
  String? categoryName;
  String? productType;

  SetPostPriceScreen(
      {super.key, this.productId, required this.title, this.product, this.categoryName, this.productType});

  @override
  State<SetPostPriceScreen> createState() => _SetPostPriceScreenState();
}

class _SetPostPriceScreenState extends State<SetPostPriceScreen> {
  String selectedOption = 'Fixed Price';
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _startingPriceController =
      TextEditingController();
  final TextEditingController _finalPriceController =
  TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? sellDate;

  bool isBack = false;

  var startTime;
  var endTime;
  var startTimeDubai;
  var endTimeDubai;

  bool hideSelectedOptions = false;
  bool showSellToUsOption = false;
  bool isSelectedCategoryJob = false;
  
  Product? product;

  @override
  void initState() {
    
    product = widget.product;


    if(widget.categoryName == "Jobs" ) {
      isSelectedCategoryJob = true;
    }

    if(widget.categoryName == "Animals" ||
    widget.categoryName == "Jobs" ||
    widget.categoryName == "Services"){
      hideSelectedOptions = true;
    }

    if(widget.categoryName == "Property for Sale" ||
        widget.categoryName == "Property for rent" ||
        widget.categoryName == "Vehicles"){
      showSellToUsOption = true;
    }

    firstTimeProductId=widget.productId;
    firstTimeProductId=widget.productId;
    _priceController.text = "";



    // Define a DateFormat with the expected date format
    DateFormat dateFormat = DateFormat('MM-dd-yyyy');

    if (product != null) {
      _priceController.text = formatNumber(product!.fixPrice.toString().replaceAll(".00", ""), textFiled:true);
      _startingPriceController.text = formatNumber(product!.auctionInitialPrice.toString().replaceAll(".00", ""), textFiled:false);
      _startingPriceController.text = formatNumber(product!.auctionInitialPrice.toString().replaceAll(".00", ""), textFiled:false);

      try {
        // Parse startingDate and endingDate strings
        startDate = dateFormat.parse(product!.auctionStartingDate!);
        endDate = dateFormat.parse(product!.auctionEndingDate!);

        // Assuming startingTime and endingTime are in "HH:mm" format
        startTime = DateFormat('HH:mm').parse(convertTo12HourFormat(product!.auctionStartingTime!));
        endTime = DateFormat('HH:mm').parse(convertTo12HourFormat(product!.auctionEndingTime!));
      } catch (e) {
        print('Error parsing dates: $e');
        // Handle parsing errors here
      }
    }

    super.initState();
  }

  // getPaymentStatus() async {
  //   await PaymentStatusService()
  //       .paymentStatusService(context: context, selling: product);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<PostProductViewModel>(
          builder: (context, provider, child){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: provider.thirdStepLoading == true
                ? const SizedBox(
                  height: 53,
                  child: Center(child: CircularProgressIndicator()))
                : Visibility(
                  visible : selectedOption != "Sell to Us",
                  child: AppButton.appButton("Next", onTap: () async {
                      // await getPaymentStatus();
                      if(selectedOption == "Fixed Price" && isSelectedCategoryJob == false && _priceController.text.isEmpty){
                        showSnackBar(context, "Please enter price");
                      }
                      else if(isSelectedCategoryJob == true && _minSalaryController.text.isEmpty){
                        showSnackBar(context, "Please enter minimum salary");
                      }
                      else if(isSelectedCategoryJob == true && _maxSalaryController.text.isEmpty){
                        showSnackBar(context, "Please enter maximum salary");
                      }
                      else if(selectedOption == "Auction" && _startingPriceController.text.isEmpty){
                        showSnackBar(context, "Please enter starting price");
                      }
                      else if(selectedOption == "Auction" && _finalPriceController.text.isEmpty){
                        showSnackBar(context, "Please enter final price");
                      }
                      else if(selectedOption == "Auction" && (int.parse(_startingPriceController.text.replaceAll(',', '')) >= int.parse(_finalPriceController.text.replaceAll(',', '')))) {
                        showSnackBar(context, "The final price must be greater than the starting price");
                      }
                      else{
                        addProductPrice(provider);
                      }
                    },
                      height: 53,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      radius: 32.0,
                      backgroundColor: AppTheme.appColor,
                      textColor: AppTheme.whiteColor),
                ),
            );
        }
      ),
      appBar: CustomAppBar1(
        title: "Price",
        action: false,
        img: "assets/images/cross.png",
        actionOntap: () {
          // pushUntil(context, const BottomNavView());
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hideSelectedOptions == false && product==null  ? 20.0 : 0),
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
                categoryNameJob: isSelectedCategoryJob,

              ),
              SizedBox(
                height: hideSelectedOptions == false && product==null ? 20 : 0,
              ),
              if(hideSelectedOptions == false && product==null)
              selectOption()
              else
                SizedBox(width: MediaQuery.of(context).size.width,),
              if (selectedOption == "Fixed Price") if(isSelectedCategoryJob == true) jobColumn() else fixedColumn(),
              if (selectedOption == "Auction") auctionColumn(),
              if (selectedOption == "Sell to Us") uXColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: showSellToUsOption == false && product != null ? 0 : 20.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if(product != null){
            if(showSellToUsOption == true){
              if (tapPosition < screenWidth * 0.5) {
                setState(() {
                  selectedOption = 'Fixed Price';
                });
              }
              else {
                setState(() {
                  selectedOption = 'Sell to Us';
                });
              }
            }
            else{
                setState(() {
                  selectedOption = 'Fixed Price';
                });

            }
          }
          else{
            if(showSellToUsOption == true){
              if (tapPosition < screenWidth * 0.3) {
                setState(() {
                  selectedOption = 'Fixed Price';
                });
              }
              else if (tapPosition < screenWidth * 0.6) {
                setState(() {
                  selectedOption = 'Auction';
                });
              } else {
                setState(() {
                  selectedOption = 'Sell to Us';
                });
              }
            }
            else{
              if (tapPosition < screenWidth * 0.5) {
                setState(() {
                  selectedOption = 'Fixed Price';
                });
              }
              else {
                setState(() {
                  selectedOption = 'Auction';
                });
              }
            }
          }


        },
        child: Container(
          height: showSellToUsOption == false && product != null ? 0 : 38,
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
              if(showSellToUsOption == true && product == null)
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
              if(showSellToUsOption == true || product == null)
                Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == (showSellToUsOption== true ? 'Sell to Us' : 'Auction')
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    showSellToUsOption== true ? 'Sell to Us' : 'Auction',
                    style: TextStyle(
                      color: selectedOption == (showSellToUsOption== true ? 'Sell to Us' : 'Auction')
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


  Widget jobColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          AppText.appText("Enter Minimum Salary",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.textColor),
          const SizedBox(
            height: 20,
          ),
          CustomAppFormField(
            texthint: "AED",
            hintStyle: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
            hintTextColor: Colors.black,
            controller: _minSalaryController,
            onChanged: (value){
              _minSalaryController.text= formatNumber(value,textFiled: true);
              setState(() {

              });
            },
            width: 220,
            textAlign: TextAlign.center,
            fontsize: 24,
            fontweight: FontWeight.w600,
            cPadding: 2.0,
            type: TextInputType.number,
          ),
          const SizedBox(
            height: 30,
          ),
          AppText.appText("Enter Maximum Salary",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.textColor),
          const SizedBox(
            height: 20,
          ),
          CustomAppFormField(
            texthint: "AED",
            hintStyle: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
            hintTextColor: Colors.black,
            controller: _maxSalaryController,
            onChanged: (value){
              _maxSalaryController.text= formatNumber(value,textFiled: true);
              setState(() {

              });
            },
            width: 220,
            textAlign: TextAlign.center,
            fontsize: 24,
            fontweight: FontWeight.w600,
            cPadding: 2.0,
            type: TextInputType.number,
          ),
          const SizedBox(
            height: 40,
          ),
          // const CustomDivider(),
          // const SizedBox(
          //   height: 15,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     AppText.appText("Firm on price",
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //         textColor: AppTheme.txt1B20),
          //     Switch(
          //       activeColor: AppTheme.appColor,
          //       value: _toggleValue == 1,
          //       onChanged: (bool value) {
          //         setState(() {
          //           _toggleValue = value ? 1 : 0;
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // const CustomDivider()
        ],
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
            texthint: "AED",
            hintStyle: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
            hintTextColor: Colors.black,
            controller: _priceController,
            onChanged: (value){
              _priceController.text= formatNumber(value,textFiled: true);
              setState(() {

              });
            },
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
          // const CustomDivider(),
          // const SizedBox(
          //   height: 15,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     AppText.appText("Firm on price",
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //         textColor: AppTheme.txt1B20),
          //     Switch(
          //       activeColor: AppTheme.appColor,
          //       value: _toggleValue == 1,
          //       onChanged: (bool value) {
          //         setState(() {
          //           _toggleValue = value ? 1 : 0;
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // const CustomDivider()
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
            hintTxt: "The starting price in AED",
            keyboard: const TextInputType.numberWithOptions(),
            controller: _startingPriceController,
            width: MediaQuery.of(context).size.width,
            onChanged: (value){
              _startingPriceController.text = formatNumber(value, textFiled:true);
              setState(() {
                
              });
            },
          ),
          LableTextField(
            labelTxt: "Final Price",
            hintTxt: "The final price for which you are willing to sell",
            keyboard: const TextInputType.numberWithOptions(),
            controller: _finalPriceController,
            width: MediaQuery.of(context).size.width,
            onChanged: (value){
              _finalPriceController.text = formatNumber(value, textFiled:true);
              setState(() {

              });
            },
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
        startTimeDubai = convertToUTC(picked, context);
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
        endTimeDubai = convertToUTC(picked, context);
      });
    }
  }



  void main() {
    String time12Hour = "01:01 PM";
    String time24Hour = convertTo24HourFormat(time12Hour);
    print(time24Hour); // Output: 13:01
  }


  Future<void> _selectSellDate(BuildContext context) async {
    // Step 1: Show Date Picker
    final DateTime? pickedDate = await showDatePicker(
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
              primary: AppTheme.appColor,
            ), // Change overall color scheme
            buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Step 2: Show Time Picker after Date is picked
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(sellDate ?? DateTime.now()),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.white, // Change the primary color
              colorScheme: ColorScheme.light(
                primary: AppTheme.appColor,
              ), // Change overall color scheme
              buttonTheme: ButtonThemeData(buttonColor: AppTheme.appColor),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Combine date and time into a single DateTime object
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Step 3: Update state with the selected DateTime
        setState(() {
          sellDate = pickedDateTime;
        });
      }
    }
  }



  Widget uXColumn() {
    return Column(
      children: [
        SizedBox(height: 20.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: AppText.appText(
                    "Kindly schedule a convenient date for a meeting with our specialist to assess your items.",
                    textColor: AppTheme.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        SizedBox(height: 25.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppText.appText("Selected Date:",
                textColor: AppTheme.textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
            SizedBox(width: 8.w,),
            AppText.appText(
                sellDate == null
                    ? ""
                    : DateFormat('MM-dd-yyyy hh:mm a').format(sellDate!),
                textColor: AppTheme.textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _selectSellDate(context);
              },
              child: SvgPicture.asset(
                "assets/svg/note.svg",
                color: Colors.black,
                height: 34.w,
                width: 34.w,
              ),
            ),

          ],
        ),
        SizedBox(height: 12.h,),
        SvgPicture.asset("assets/images/sell_to_us.svg", height: 280.h,)
      ],
    );
  }

  addProductPrice(PostProductViewModel provider) async {
       provider.setThirdStepLoading(true);
       int? minSalary;
       int? maxSalary;
       if (isSelectedCategoryJob == true) {
         maxSalary = int.tryParse(_maxSalaryController.text.replaceAll(',', ''));
         minSalary = int.tryParse(_minSalaryController.text.replaceAll(',', ''));
       }

       int? fixPrice = isSelectedCategoryJob == true
           ? int.tryParse(_maxSalaryController.text.replaceAll(',', ''))
           : int.tryParse(_priceController.text.replaceAll(',', '')) ;

       int? auctionPrice = int.tryParse(_startingPriceController.text.replaceAll(',', ''));
       int? finalPrice = int.tryParse(_finalPriceController.text.replaceAll(',', ''));


       Map<String, dynamic> params = {
      "product_id": widget.productId,
      "fix_price": fixPrice,
      "auction_initial_price": auctionPrice,
      "auction_final_price": finalPrice,
      "min_salary": minSalary,
      "max_salary": maxSalary,
      if(startDate != null)
      "auction_starting_date": formatDate(startDate!),
      "auction_starting_time": startTimeDubai,
      // "auction_starting_time": startTime,
      if(endDate != null)
        "auction_ending_date": formatDate(endDate!),
      "auction_ending_time": endTimeDubai,
      "sell_to_us": sellDate,
      if(selectedOption == "Fixed Price")
        "product_type" : widget.productType ?? "featured"
      else
        "product_type" : "auction",
    };
    if (selectedOption == "Fixed Price" && isSelectedCategoryJob == false) {
      params.remove("auction_initial_price");
      params.remove("auction_final_price");
      params.remove("max_salary");
      params.remove("min_salary");
      params.remove("auction_starting_date");
      params.remove("auction_starting_time");
      params.remove("auction_ending_date");
      params.remove("auction_ending_time");
      params.remove("sell_to_us");
    } else if (selectedOption == "Auction") {
      params.remove("fix_price");
      params.remove("firm_on_price");
      params.remove("sell_to_us");
      params.remove("max_salary");
      params.remove("min_salary");
    } else if (selectedOption == "Sell to Us") {
      params.remove("fix_price");
      params.remove("firm_on_price");
      params.remove("auction_initial_price");
      params.remove("auction_final_price");
      params.remove("auction_starting_date");
      params.remove("auction_starting_time");
      params.remove("auction_ending_date");
      params.remove("auction_ending_time");
      params.remove("max_salary");
      params.remove("min_salary");
    } else if(isSelectedCategoryJob == true){
      params.remove("sell_to_us");
      params.remove("firm_on_price");
      params.remove("auction_initial_price");
      params.remove("auction_final_price");
      params.remove("auction_starting_date");
      params.remove("auction_starting_time");
      params.remove("auction_ending_date");
      params.remove("auction_ending_time");
    }


       provider.addProductThirdStep(params, update: product != null || isBack == true).then((value){
         Navigator.push(context, CupertinoPageRoute(builder: (_) =>
             PostLocationScreen(
               product: product,
               selectedCategory: widget.categoryName,
               productId: product == null
                   ? value.data!.productId
                   : product!.id,
               amount: selectedOption == "Fixed Price" ? isSelectedCategoryJob ? maxSalary! : int.parse(_priceController.text.replaceAll(',', '')) : int.parse(_startingPriceController.text.replaceAll(',', '')),
               title: widget.title,

             ))).then((value){
           setState(() {
             isBack = true;
           });
         });
         provider.setThirdStepLoading(false);

       }).onError((error, stackTrace){
         provider.setThirdStepLoading(false);
         showSnackBar(context, error.toString());
       });




  }
}
