import 'dart:async';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/custom_requests/report_service.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import '../main.dart';
import '../models/product_model.dart';
import '../view_model/product/product/product_viewmodel.dart';

void showSnackBar(BuildContext context, String text, {String title = "Oops!", bool error = true}) {
  final snackBar = SnackBar(
    backgroundColor :AppTheme.yellowColor,
    content: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                   title == 'Success!' ? 'Congratulations!' : error ? title : 'Success!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xff00008B), // Adjust color as needed
                    ),
                  ),
                ],
              ),
              SizedBox(height : 5.h),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff00008B), // Adjust color as needed
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xff00008B), // Adjust color as needed
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: EdgeInsets.all(10.0), // Adjust margin as needed
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isProductBoosted(String? dateString) {
  if (dateString == null) {
    return false;
  }

  try {
    DateTime parsedDate = DateTime.parse(dateString);
    return parsedDate.isAfter(DateTime.now());
  } catch (e) {
    // Handle invalid date format
    return false;
  }
}

push(context, screen, {Function()? then}) {
  Navigator.push(context, CupertinoPageRoute(builder: (_) => screen)).then((value){
    if(then!=null) {
      then();
    }
  });
}

pushReplacement(context, screen) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (_) => screen));
}

pushUntil(context, screen) {
  Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (_) => screen), (route) => false);
}

String formatNumber(String numberString, {bool textFiled = false}) {

  if(numberString == 'null'){
    return '';
  }

  // Split the string into integer and decimal parts
  String integerPart;
  String? decimalPart;

  if (textFiled == false) {
    List<String> parts = numberString.split('.');
    integerPart = parts[0];
    decimalPart = parts.length > 1 ? parts[1] : '';
  } else {
    numberString = numberString.replaceAll(',', '');
    integerPart = numberString;
  }

  int length = integerPart.length;

  // Check if the integer part length is less than or equal to 3
  if (length <= 3) return numberString;

  // Insert commas every three digits
  integerPart = integerPart.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match match) => '${match[1]},');

  // Construct the result
  String formattedNumber = integerPart;


  return formattedNumber;
}

String capitalizeWords(String? input) {

  if(input == null) return '';

  if (input.isEmpty) return input;

  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

String capitalizeWholeTitle(String input, String title) {
  // Define a helper function to capitalize each word
  String capitalizeEachWord(String str) {
    return str.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word;
      }
    }).join(' ');
  }

  // Check if the input contains the title substring
  if (input.contains(title)) {
    // Capitalize the title substring
    String capitalizedTitle = capitalizeEachWord(title);

    // Replace the title substring with the capitalized version
    return input.replaceAll(title, capitalizedTitle);
  } else {
    // Return the original input if it does not contain the title substring
    return input;
  }
}

String formatMonthYear(String? dateString) {
  // Parse the input string into a DateTime object
  if(dateString == null){
    return '';
  }
  else{
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object to "Month, Year" format
    String formattedDate = DateFormat('MMMM, yyyy').format(date);

    return formattedDate.replaceAll(",", "");
  }

}

String formatYear(String? dateString) {
  // Parse the input string into a DateTime object
  if (dateString == null) {
    return '';
  }
  else {
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object to "Month, Year" format
    String formattedDate = DateFormat('yyyy').format(date);

    return formattedDate.replaceAll(",", "");
  }
}

String getLastTwoWords(String input) {
    // Split the string by spaces
    List<String> words = input.split(' ');

    // Check if the string contains at least two words
    if (words.length < 2) {
      return input; // If not, return the original string
    }

    // Get the last two words
    String lastTwoWords = '${words[words.length - 2]} ${words[words.length - 1]}';

    return lastTwoWords;
  }

String timeAgo(String? dateTimeString) {

  if(dateTimeString == null){
    return '';
  }


  DateTime dateTime = DateTime.parse(dateTimeString);
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 365) {
    int months = difference.inDays ~/ 30;
    return '$months month${months == 1 ? '' : 's'} ago';
  } else {
    int years = difference.inDays ~/ 365;
    return '$years year${years == 1 ? '' : 's'} ago';
  }
}

String removeLastTwoZeros(String amount) {
  if (amount.endsWith('.00')) {
    return amount.substring(0, amount.length - 3);
  }  else if (amount.endsWith('.0')) {
    return amount.substring(0, amount.length - 2);
  }
  return amount;
}

Widget phoneField({required TextEditingController controller, required BuildContext context}) {
  String initialCountry = "ae";
  return Container(
    decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        border: Border.all(color: const Color(0xffE5E9EB)),
        borderRadius: BorderRadius.circular(14)),
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: [
        CountryListPick(
          onChanged: (CountryCode? countryCode) {
            controller.text = countryCode?.dialCode ?? '';
          },
          theme: CountryTheme(
              isShowFlag: true,
              showEnglishName: true,
              isShowTitle: false,
              isShowCode: false,
              isDownIcon: false),
          initialSelection: initialCountry,
          useUiOverlay: false,
          useSafeArea: false,
        ),
        Expanded(
          child: TextFormField(
            cursorColor: AppTheme.textColor,
            cursorHeight: 25,
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                fillColor: Colors.black38,
                focusedBorder: InputBorder.none,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 4)),
          ),
        ),
      ],
    ),
  );
}

String starCount(double? percentage) {
  // Ensure the percentage is within valid range
  if (percentage == null || percentage == 0.0 || percentage < 0 || percentage > 100) {
    return "not rated yet";
  }

  // Calculate the value out of 5

  return "(${percentage.toStringAsFixed(1).replaceAll('.0', '')})";
}

int percentageOfFive(dynamic rating) {
  if (rating == null) {
    return 0;
  }

  // Calculate the percentage
  int percentage = ((rating / 5) * 100).toInt();

  return percentage;
}

String getRating(String? rating){
  if(rating == null){
    return "0";
  }
  else{
    if(int.parse(rating) > 5){
      return "5";
    }
    else if(int.parse(rating) < 0){
      return '0';
    }
    return rating;
  }
}

Widget appLoading() {
  return Center(
    child: SizedBox(
      width: 30,
      height: 15,
      child:
      showLoadingAnimation(), //SvgPicture.asset('assets/svg/ic_icon.svg', width: 50, height: 50,),
    ),
  );
}

Widget showLoadingAnimation({Color leftDotColor = const Color(0xFFFFC107), Color rightDotColor = const Color(0xFFB71C1C), double size = 35}){
return Center(child: LoadingAnimationWidget.twistingDots(leftDotColor: leftDotColor, rightDotColor: rightDotColor, size: size));
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatDateTime(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}


String convertToUTC(TimeOfDay picked) {
  DateTime now = DateTime.now();
  DateTime selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

  // Convert to UTC
  DateTime utcTime = selectedTime.toUtc();

  // Format UTC time in 24-hour format
  String formattedTime = DateFormat("HH:mm").format(utcTime);

  return formattedTime;
}


String convertToUTCTimeDateTime(DateTime picked) {
  // Convert the selected time to UTC
  DateTime utcTime = picked.toUtc();

  // Format the UTC time in 24-hour format
  String formattedTime = DateFormat("HH:mm").format(utcTime);

  return formattedTime;
}

String convertTo24HourFormat(String time12Hour) {
  // Split the time into parts
  List<String> parts = time12Hour.split(' ');
  String time = parts[0]; // e.g., "01:01"
  String period = parts[1]; // e.g., "PM"

  // Split the time into hours and minutes
  List<String> timeParts = time.split(':');
  int hour = int.parse(timeParts[0]);
  String minutes = timeParts[1];

  // Convert hour based on AM/PM
  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  // Format hour to always be two digits
  String hourStr = hour.toString().padLeft(2, '0');

  return '$hourStr:$minutes';
}

String productPrice(Product? product){
  if(product == null){
    return '';
  }

  if(product.productType == 'featured'){
    return "AED ${abbreviateNumber(product.fixPrice?.toString() ?? '')}";
  }
  else if(product.productType == 'auction'){
    return "AED ${abbreviateNumber(product.auctionInitialPrice?.toString() ?? '')}";
  }
  else if(product.productType == 'looking' || product.productType == 'hiring'){
    return "AED ${abbreviateNumber(product.minSalary?.toString() ?? '')} - AED ${abbreviateNumber(product.maxSalary?.toString() ?? '')}";
  }
  else{
    return '';
  }
}

String productPriceForImage(Product? product){
  if(product == null){
    return '';
  }

  if(product.productType == 'featured'){
    return "AED ${abbreviateNumber(product.fixPrice?.toString() ?? '')}";
  }
  else if(product.productType == 'auction'){
    return "Auction";
  }
  else if(product.productType == 'looking' || product.productType == 'hiring'){
    return "AED ${abbreviateNumber(product.maxSalary?.toString() ?? '')}";
  }
  else{
    return '';
  }
}

String productPriceInFull(Product? product, {bool auctionFullPrice = false, bool jobFullPrice = false}){
  if(product == null){
    return '';
  }

  if(product.productType == 'featured'){
    return "AED ${formatNumber(product.fixPrice?.toString() ?? '')}";
  }
  else if(product.productType == 'auction'){
    return auctionFullPrice ? "AED ${formatNumber(product.auctionInitialPrice?.toString() ?? '')}" : "Auction";
  }
  else if(product.productType == 'looking' || product.productType == 'hiring'){
    return jobFullPrice == false ? "AED ${abbreviateAndFormatNumber(product.maxSalary?.toString() ?? '')}" :
    "AED ${abbreviateNumber(product.minSalary?.toString() ?? '')}"
        "${jobFullPrice == true ? ' - AED ${abbreviateNumber(product.maxSalary?.toString() ?? '')}' : ''}";
  }
  else{
    return '';
  }
}



String convertTo12HourFormat(String time24Hour) {
  // Split the time into hours and minutes
  List<String> timeParts = time24Hour.split(':');
  int hour = int.parse(timeParts[0]);
  String minutes = timeParts[1];

  // Determine if it's AM or PM
  String period = hour >= 12 ? 'PM' : 'AM';

  // Convert the hour to 12-hour format
  if (hour > 12) {
    hour -= 12;
  } else if (hour == 0) {
    hour = 12; // Midnight case
  }

  // Format the hour to be without leading zero in 12-hour format
  String hourStr = hour.toString().padLeft(2, '0');

  return '$hourStr:$minutes $period';
}

bool isEndDateTimeValid(
    DateTime startDate, String startTime, DateTime endDate, String endTime) {

  startTime = startTime.trim().replaceAll(RegExp(r'\s+'), ' ');
  endTime = endTime.trim().replaceAll(RegExp(r'\s+'), ' ');


  DateTime parsedStartTime;
  DateTime parsedEndTime;
  if (is24HourFormat(startTime)) {
    parsedStartTime = DateFormat('HH:mm').parse(startTime); // 24-hour format
  } else {
    DateFormat timeFormat = DateFormat('h:mm a');
    print(startTime);// 12-hour format
    parsedStartTime = timeFormat.parse(startTime);
  }

  if (is24HourFormat(endTime)) {
    parsedEndTime = DateFormat('HH:mm').parse(endTime); // 24-hour format
  } else {
    DateFormat timeFormat = DateFormat('h:mm a'); // 12-hour format
    parsedEndTime = timeFormat.parse(endTime);
  }

  // Combine dates with times
  DateTime combinedStartDateTime = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
    parsedStartTime.hour,
    parsedStartTime.minute,
  );

  DateTime combinedEndDateTime = DateTime(
    endDate.year,
    endDate.month,
    endDate.day,
    parsedEndTime.hour,
    parsedEndTime.minute,
  );

  // Check if the end date and time is greater than the start date and time
  return combinedEndDateTime.difference(combinedStartDateTime).inMinutes >= 60;
}


bool isEndDateTimeWithinOneWeek(
    DateTime startDate, String startTime, DateTime endDate, String endTime) {

  startTime = startTime.trim().replaceAll(RegExp(r'\s+'), ' ');
  endTime = startTime.trim().replaceAll(RegExp(r'\s+'), ' ');

  DateTime parsedStartTime;
  DateTime parsedEndTime;
  if (is24HourFormat(startTime)) {
    parsedStartTime = DateFormat('HH:mm').parse(startTime); // 24-hour format
    parsedEndTime = DateFormat('HH:mm').parse(endTime); // 24-hour format
  } else {
    DateFormat timeFormat = DateFormat('h:mm a'); // 12-hour format
    parsedStartTime = timeFormat.parse(startTime);
    parsedEndTime = timeFormat.parse(endTime);
  }

  // Combine dates with times
  DateTime combinedStartDateTime = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
    parsedStartTime.hour,
    parsedStartTime.minute,
  );

  DateTime combinedEndDateTime = DateTime(
    endDate.year,
    endDate.month,
    endDate.day,
    parsedEndTime.hour,
    parsedEndTime.minute,
  );

  // Calculate the duration between the start and end date times
  Duration difference = combinedEndDateTime.difference(combinedStartDateTime);

  // Check if the end date and time is within 1 week (7 days) from the start date and time
  return difference.inDays <= 7;
}


bool is24HourFormat(String time) {
  // 24-hour format does not have "AM" or "PM"
  return !time.contains(RegExp(r'\b(AM|PM)\b', caseSensitive: false));
}

DateTime combineDateAndTime(String time, DateTime date) {
  DateTime parsedTime;

  if (is24HourFormat(time)) {
    // Time is in 24-hour format
    if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(time)) {
      throw const FormatException('Invalid 24-hour time format. Expected HH:mm.');
    }

    // Split the time into hours and minutes
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Validate time values
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
      throw const FormatException('Time values out of range. Hours: 0-23, Minutes: 0-59.');
    }

    // Combine date and time
    parsedTime = DateTime(date.year, date.month, date.day, hours, minutes);
  } else {
    // Time is in 12-hour format
    DateFormat timeFormat = DateFormat('h:mm a');
    DateTime parsed12HourTime = timeFormat.parse(time);

    // Combine date and time
    parsedTime = DateTime(
      date.year,
      date.month,
      date.day,
      parsed12HourTime.hour,
      parsed12HourTime.minute,
    );
  }

  return parsedTime;
}



String abbreviateNumber(String numberStr) {
  if(numberStr.isEmpty){
    return '';
  }

  int? number = int.tryParse(numberStr);

  if(number==null){
    return '';
  }

  if (number >= 1000000) {
    return "${(number / 1000000).toStringAsFixed(0)}M";
  } else if (number >= 1000) {
    return "${(number / 1000).toStringAsFixed(0)}K";
  } else {
    return numberStr;
  }
}

String formatTimestamp(String timestamp, {bool full=false}) {

  if(timestamp.isEmpty){
    return '';
  }

  DateTime now = DateTime.now();
  DateTime time = DateTime.parse(timestamp);

  Duration difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return "just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}${full ? " minutes" : "m"} ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}${full ? " hour" : "h"} ago";
  } else if (difference.inDays == 1) {
    return "yesterday";
  } else {
    return "${time.day}/${time.month}/${time.year}";
  }
}

Widget buildStatItem(String count, String label, {bool disabled = false}) {
  return Column(
    children: [
      AppText.appText(
        count,
        fontSize: 16,
        textColor: disabled ? Colors.grey : Colors.green,

      ),
      AppText.appText(
        label,
        fontSize: 13.5,
        fontWeight: FontWeight.w600,

        textColor: disabled ? Colors.grey : Colors.black,
      ),
    ],
  );
}

void reportProduct(BuildContext context, int productId, int userId){
  List<String> dataRequest = [
    'Inappropriate product image',
    'Misleading product description',
    'Faulty or damaged product',
    'Spam or repetitive listing',
    'Fraudulent listing',
    'Other'
  ];

  String? selectData;
  TextEditingController commentController = TextEditingController();
  bool loader = false;


  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          StatefulBuilder(builder: (context, setstates) {


            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding:
                          EdgeInsets.only(left: 25.0),
                          child: Text('Report Product',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 27)),
                        ),
                        const SizedBox(height: 15),
                        for (int i = 0;
                        i < dataRequest.length;
                        i++)
                          Row(
                            children: [
                              Checkbox(
                                shape:
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        20)),
                                value: selectData ==
                                    dataRequest[i],
                                onChanged: (val) {
                                  selectData =
                                  dataRequest[i];

                                  setstates(() {});
                                },
                                activeColor:
                                AppTheme.appColor,
                                side: const BorderSide(
                                    width: .5),
                              ),
                              const SizedBox(width: 10),
                              AppText.appText(
                                  dataRequest[i],
                                  fontSize: 16)
                            ],
                          ),
                        const SizedBox(height: 8),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 18.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                    Colors.black54),
                                borderRadius:
                                BorderRadius.circular(
                                    8)),
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                  hintText: 'Comment',
                                  border:
                                  InputBorder.none,
                                  contentPadding:
                                  EdgeInsets
                                      .symmetric(
                                      horizontal:
                                      10,
                                      vertical:
                                      7)),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color:
                                    AppTheme.appColor,
                                    decoration:
                                    TextDecoration
                                        .underline),
                              ),
                            ),
                            Consumer<ProductViewModel>(
                                builder: (context, productViewModel, child) {
                                  return
                                    productViewModel.loading == true
                                    ? CupertinoActivityIndicator(
                                  color:
                                  AppTheme.appColor,
                                  animating: true,
                                  radius: 12,
                                )
                                    : TextButton(
                                    onPressed: () {
                                      if(selectData!= null){
                                      ReportService.reportProductService(context: context,
                                      productId: productId,
                                      userId: userId,
                                      note: commentController.text,
                                      subject: selectData);
                                      }
                                    },
                                    child: Text(
                                      'Send',
                                      style: TextStyle(
                                          color: AppTheme
                                              .appColor,
                                          decoration:
                                          TextDecoration
                                              .underline),
                                    ));
                              }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
}

  Widget loadingIndicator({double rightPadding = 0}){
    return Padding(
      padding: EdgeInsets.only(right: rightPadding.w),
      child: CupertinoActivityIndicator(color: AppTheme.appColor, animating: true, radius: 12,),
    );

    }

    Future<void> clearCacheAndSignOut() async {
      // Sign out from Google
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      pref.clear();

    }


String getCardType(String? input) {
  if(input == null){
    return '';
  }


  input = input.toLowerCase().trim();

  if (input == 'master' || input == 'master card' || input == 'mastercard') {
    return 'Master';
  } else if (input == 'visa') {
    return 'Visa';
  } else if (input == 'google pay' || input == 'gpay' || input == 'googlepay') {
    return 'Google Pay';
  } else {
    return 'Default';
  }
}


bool makeOfferButton(Product? product){
  if(product == null){
    return true;
  }

  if(product.category?.name == 'Jobs' || product.category?.name == 'Services'){
    return false;
  }
  else{
    return true;
  }

}

String featureChatButtonTitle(Product? product){
  if(product==null){
    return 'Ask Seller';
  }

  if(product.category?.name == 'Jobs'){
     if(product.productType == 'looking'){
       return 'Ask for CV';
     }
     else if(product.productType == 'hiring'){
       return 'Send my CV';
     }
     else{
       return 'Ask Seller';
     }
  }
  else if(product.category?.name == 'Services'){
    return 'Make an Appointment';
  }
  else{
    return 'Ask Seller';
  }

}


bool shippingMethodAllowed(String? category){
  if(category == null){
    return true;
  }

  if(category == 'Jobs'){
    return false;
  }
  else if(category == 'Services'){
    return false;
  }
  else if((category == 'Property for Sale' || category == 'Property for Rent')){
    return false;
  }
  else{
    return true;
  }

}



bool enableCartButton(Product? product) {

  if(product == null){
    return true;
  }

  // List of categories that should return false
  List<String> invalidCategories = [
    'Property for Rent',
    'Property for Sale',
    'Vehicles',
    'Services',
    'Jobs',
  ];

  // Check if the category is in the list of invalid categories
  return invalidCategories.contains(product.category?.name) == false;
}


String? shippingMethodIcon(String? deliveryType){

  if(deliveryType == 'Pick Up'){
    return 'assets/images/handshake.png';
  }
  else if(deliveryType == 'Local Delivery'){
    return 'assets/images/shipping_truck.png';
  }
  else if(deliveryType == 'Shipping'){
    return 'assets/images/plane.png';
  }
  return null;

}

String? shippingMethodTitle(String? deliveryType){

  if(deliveryType == 'Pick Up'){
    return 'Pick Up';
  }
  else if(deliveryType == 'Local Delivery'){
    return 'Local Delivery';
  }
  else if(deliveryType == 'Shipping'){
    return 'International Shipping';
  }
  return null;

}


Widget shippingMethodIconWidget(Product? product){
  return Row(
    children: List.generate(
      product?.deliveryType?.length ?? 0, // Number of widgets in the row
          (index) {
        final deliveryType = product?.deliveryType?[index]; // Access the product at this index
        return Row(
          children: [
            Image.asset(
              shippingMethodIcon(deliveryType)!,
              height: deliveryType == 'Shipping' ? 14.h : 15.h,
            ),
            SizedBox(width: 5.w),
          ],
        );
      },
    ),
  );
}

String abbreviateAndFormatNumber(String numberStr) {
  if (numberStr.isEmpty) {
    return '';
  }

  int? number = int.tryParse(numberStr);

  if (number == null) {
    return '';
  }

  if (number >= 1000000) {
    return "${(number / 1000000).toStringAsFixed(0)}M";
  } else if (number >= 100000) {
    return "${(number / 1000).toStringAsFixed(0)}K";
  } else {
    return formatNumber(number.toString());
  }
}



Widget priceTag(Product? product) {
  final price = productPrice(product);
  final priceLength = price.length;

  // Check if the price ends with a letter
  final endsWithLetter = price.isNotEmpty && RegExp(r'[a-zA-Z]$').hasMatch(price);

  // Calculate width dynamically
  final width = priceLength > 7
      ? 80.w + (priceLength - 7) * 5.w + (endsWithLetter ? 5.w : 0.w)
      : 80.w + (endsWithLetter ? 5.w : 0.w);

  final height = 25.h;

  if(price.isEmpty) {
    return SizedBox();
  }

  return SizedBox(
    height: height,
    width: width,
    child: Stack(
      children: [
        Image.asset(
          "assets/images/price_tag_${product?.isBoosted == true ? "green" : "green"}.png",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: 20.w,
          top: 3.h,
          child: RichText(
            text: TextSpan(
              children: [
            TextSpan(
              text: price,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp, // Larger font size for the price
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    ),
  )
  )]));
}

Widget fullPriceTag(Product? product, {bool detailPage = false}) {
  final price = productPriceInFull(product, auctionFullPrice: true, jobFullPrice: true);
  final priceLength = price.length;

  // Check if the price ends with a letter

  // Calculate width dynamically
  final width = priceLength > 9
      ?  145.w + (priceLength - 7) * 5.w + (0.w)
      : 140.w + (0.w);

  final height = 43.h;

  if(price.isEmpty) {
    return const SizedBox();
  }

  return SizedBox(
    height: height,
    width: width,
    child: Stack(
      children: [
        Image.asset(
          "assets/images/price_tag_green_large.png",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: priceLength > 7 ? 32.w : 29.w,
          top: 7.h,
          child: AppText.appText(
            price,
            textColor: Colors.white,
            fontSize: 19.sp,
          ),
        ),
      ],
    ),
  );
}

Widget specialOffer(Product? product){
  return product?.isBoosted == true ?
    Container(
      margin: EdgeInsets.only(top: 6.h, left: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Soft black shadow with 15% opacity
            offset: const Offset(0, 4),                  // Shadow positioned slightly below the container
            blurRadius: 4,                         // Moderate blur for a soft shadow effect
            spreadRadius: 0,                       // Slight spread to enhance the visibility
          ),
        ],
      ),
      child: AppText.appText('Special Offer', fontSize: 10.sp, fontWeight: FontWeight.bold, textColor: AppTheme.white ),
    ) : const SizedBox();
}

String extractCity(String address) {
  // Split the address by commas and trim whitespace
  final parts = address.split(',').map((part) => part.trim()).toList();

  // Check if the address has at least two parts
  if (parts.length >= 2) {
    final secondLast = parts[parts.length - 2]; // Second last value
    final last = parts.last; // Last value

    // If the second last value is a single character, return the last value
    if (secondLast.length == 1) {
      return last;
    }

    // Otherwise, return the second last value
    return secondLast;
  }

  // Return empty string if no valid value found
  return address;
}


Widget auctionTimerCounter(DateTime? endDateTime){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
    decoration: BoxDecoration(
        color: AppTheme.yellowColor,
        borderRadius: BorderRadius.all(Radius.circular(4.r))
    ),
    child: SizedBox(
      child: AppText.appText(getTimeLeftString(endDateTime),
          fontSize: 9.7.sp,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
          textColor: Colors.black),
    ),
  );
}

String getTimeLeftString(DateTime? endTime) {

  if (endTime == null) {
    return 'Invalid date/time';
  }

  Duration timeLeft = endTime.difference(DateTime.now());

  if (timeLeft == const Duration(days: 0, minutes: 0, seconds: 0, microseconds: 0) || timeLeft.isNegative) {
    return 'Time Ends';
  }

  if (timeLeft.inHours < 24) {
    int hours = timeLeft.inHours;
    int minutes = timeLeft.inMinutes.remainder(60);
    int seconds = timeLeft.inSeconds.remainder(60);
    return '0d ${hours}h ${minutes}m ${seconds}s';
  }
  else {
    int days = timeLeft.inDays;
    int hours = timeLeft.inHours % 24;
    int minutes = timeLeft.inMinutes.remainder(60);
    int seconds = timeLeft.inSeconds.remainder(60);
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }
}

DateTime _parseEndingDateTime(Product? product) {
  String? endingTimeString = product?.auctionEndingTime;
  String? endingDateString = product?.auctionEndingDate;
  DateTime endingDate =
  DateFormat("yyyy-MM-dd").parse(endingDateString!);
  DateTime endingTime;

  if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
    endingTime = DateFormat("h:mm a").parse(endingTimeString);
    if (kDebugMode) {
      print(" vkrvlrvm$endingTime");
    }
  } else {
    endingTime = DateFormat("HH:mm").parse(endingTimeString);
    if (kDebugMode) {
      print(" jf3o3jfpfp3fpk$endingTime");
    }
  }
  return DateTime(
    endingDate.year,
    endingDate.month,
    endingDate.day,
    endingTime.hour,
    endingTime.minute,
  );
}

DateTime convertEndTimeToUserTimeZone(String time) {
  DateTime endTime = DateTime.parse(time);
  // Get the user's local time zone offset (e.g., UTC+5)
  Duration userTimeZoneOffset = DateTime.now().timeZoneOffset;

  // Define the time zone offset for UTC+4 (Dubai time)
  const dubaiTimeZoneOffset = Duration(hours: 0);

  // Calculate the difference between user time zone and Dubai time zone
  Duration timeDifference = userTimeZoneOffset - dubaiTimeZoneOffset;

  // Add or subtract the time difference to the endTime
  return endTime.add(timeDifference);
}

startAuctionTimer(Timer? timer, ValueNotifier<int> remainingTimeNotifier, BuildContext context, {bool callAuctionApi = true}){
  timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (remainingTimeNotifier.value > 0) {
      remainingTimeNotifier.value -= 1;
    } else {
      if(callAuctionApi){
        Provider.of<ProductViewModel>(context, listen: false).getAuctionProducts();
      }
      timer?.cancel(); // Stop timer when countdown ends
    }
  });
}



