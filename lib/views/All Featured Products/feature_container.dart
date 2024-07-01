import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/views/All%20Aucton%20Products/auction_container.dart';

class FeatureProductContainer extends StatefulWidget {
  final data;

  const FeatureProductContainer({this.data});

  @override
  State<FeatureProductContainer> createState() =>
      _FeatureProductContainerState();
}

class _FeatureProductContainerState extends State<FeatureProductContainer> {
  String timeDifference = ''; // Store the calculated time difference

  @override
  void initState() {
    super.initState();
    // Convert API date to DateTime
    DateTime dateTime = DateTime.parse("${widget.data["created_at"]}");
    // Calculate time difference
    timeDifference = calculateTimeDifference(dateTime);
  }

  String calculateTimeDifference(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(dateTime);
    int days = difference.inDays;
    int hours =
        difference.inHours.remainder(24); // Get hours within the current day
    int minutes = difference.inMinutes
        .remainder(60); // Get minutes within the current hour

    if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'} $hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
  }

  @override
  Widget build(BuildContext context) {

    VehicleAttributes vehicleAttributes =
    VehicleAttributes.fromJson(widget.data['attributes']);
    PropertyAttributes propertyAttributes =
    PropertyAttributes.fromJson(widget.data['attributes']);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.appColor)),
      height: 245,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 161,
              decoration: BoxDecoration(
                color: AppTheme.hintTextColor,
                borderRadius: BorderRadius.circular(14),
                image: widget.data["photo"].isNotEmpty
                    ? DecorationImage(
                        image:
                            NetworkImage("${widget.data["photo"][0]["src"]}"),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.whiteColor,
                    ),
                    child: widget.data["wishlist"].isEmpty
                        ? Icon(
                            Icons.favorite_border,
                            size: 13,
                            color: AppTheme.textColor,
                          )
                        : Icon(
                            size: 13,
                            Icons.favorite_sharp,
                            color: AppTheme.appColor,
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            AppText.appText("\$${widget.data["fix_price"]}",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppTheme.textColor),
            const SizedBox(height: 5),

            SizedBox(
              // height: 40,
              width: MediaQuery.sizeOf(context).width * .4,
              child: AppText.appText("${widget.data["title"]}",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ),

            const SizedBox(height: 3),
            Expanded(
              child: vehicleAttributes.catName == 'Vehicles'
                  ? Row(
                children: [
                  ImageText(
                      txt: vehicleAttributes.year, image: 'calender.png'),
                  ImageText(
                      txt: vehicleAttributes.mileAge, image: 'road.png'),
                  ImageText(
                      txt: vehicleAttributes.FuelType, image: 'petrol.png'),
                ],
              )
                  : propertyAttributes.catName == 'Property for Sale' ||
                  propertyAttributes.catName == 'Property for Rent'
                  ? Row(
                children: [
                  ImageText(
                      txt: propertyAttributes.bedroom,
                      image: 'bath.png'),
                  ImageText(
                      txt: propertyAttributes.bedroom,
                      image: 'bed.png'),
                  ImageText(
                      txt: propertyAttributes.area,
                      image: 'family.png'),
                ],
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 3),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //
            //     AppText.appText("${widget.data["auction"].length} Bid Now",
            //         fontSize: 12,
            //         fontWeight: FontWeight.w200,
            //         textColor: AppTheme.textColor),
            //   ],
            // ),

            const SizedBox(height: 4),

            Row(
              children: [
                Image.asset(
                  'assets/images/location.png',
                  height: 14,
                  width: 14,
                ),
                const SizedBox(width: 5),
                AppText.appText("${widget.data["location"]}",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.black45),
              ],
            ),

            // AppText.appText(
            //   "${widget.data["title"]}",
            //   fontSize: 14,
            //   fontWeight: FontWeight.w500,
            //   textColor: AppTheme.textColor,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     AppText.appText(
            //       "\$${widget.data["fix_price"]}",
            //       fontSize: 14,
            //       fontWeight: FontWeight.w700,
            //       textColor: AppTheme.textColor,
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Icon(
            //           Icons.location_on_outlined,
            //           color: AppTheme.textColor,
            //           size: 20,
            //         ),
            //         SizedBox(
            //           width: 50,
            //           child: AppText.appText(
            //             "${widget.data["location"]}",
            //             fontSize: 12,
            //             fontWeight: FontWeight.w400,
            //             overflow: TextOverflow.ellipsis,
            //             textColor: AppTheme.textColor,
            //           ),
            //         )
            //       ],
            //     ),
            //     SizedBox(
            //       width: 100,
            //       child: AppText.appText(
            //         overflow: TextOverflow.ellipsis,
            //         timeDifference,
            //         fontSize: 11,
            //         fontWeight: FontWeight.w600,
            //         textColor: AppTheme.appColor,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
