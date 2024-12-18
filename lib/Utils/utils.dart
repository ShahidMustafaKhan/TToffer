import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/custom_requests/report_service.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';

import '../main.dart';
import '../models/product_model.dart';
import '../models/user_info_model.dart';
import '../view_model/product/product/product_viewmodel.dart';
import '../views/BottomNavigation/navigation_bar.dart';

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

String capitalizeWords(String input) {
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
  String star = ((percentage / 100) * 5).toStringAsFixed(1).replaceAll(".0", "");

  return "($star/5)";
}

int percentageOfFive(int? rating) {
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

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String convertToUTC(TimeOfDay picked, BuildContext context){
  DateTime now = DateTime.now();
  DateTime selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

  // Convert the selected time to Dubai time zone (UTC+4)
  DateTime dubaiTime = selectedTime.toUtc();

  // Format the time to display
  final dubaiFormattedTime = TimeOfDay.fromDateTime(dubaiTime).format(context);

  return convertTo24HourFormat(dubaiFormattedTime);
}

String convertToUTCTimeDateTime(DateTime picked, BuildContext context){

  // Convert the selected time to Dubai time zone (UTC+4)
  DateTime dubaiTime = picked.toUtc();

  // Format the time to display
  final dubaiFormattedTime = TimeOfDay.fromDateTime(dubaiTime).format(context);

  return convertTo24HourFormat(dubaiFormattedTime);
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
    return "AED ${abbreviateNumber(product.minSalary?.toString() ?? '500')} - AED ${abbreviateNumber(product.maxSalary?.toString() ?? '900')}";
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

void _navigateToBottomNavView(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const BottomNavView(),
    ),
        (Route<dynamic> route) => false, // This removes all previous routes
  );
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
    return "${difference.inMinutes} ${full ? "min" : "M"} ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} ${full ? "hour" : "H"} ago";
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

loadingIndicator({double rightPadding = 0}){
  return Padding(
    padding: EdgeInsets.only(right: rightPadding.w),
    child: CupertinoActivityIndicator(color: AppTheme.appColor, animating: true, radius: 12,),
  );
}


