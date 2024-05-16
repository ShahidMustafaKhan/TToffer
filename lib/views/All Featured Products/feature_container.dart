import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

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
    return SizedBox(
      height: 245,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 161,
            width: 161,
            decoration: BoxDecoration(
              color: AppTheme.hintTextColor,
              borderRadius: BorderRadius.circular(14),
              image: widget.data["photo"].isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage("${widget.data["photo"][0]["src"]}"),
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
          AppText.appText(
            "${widget.data["title"]}",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppTheme.textColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText(
                "\$${widget.data["fix_price"]}",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                textColor: AppTheme.textColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppTheme.textColor,
                    size: 20,
                  ),
                  Container(
                    width: 50,
                    child: AppText.appText(
                      "${widget.data["location"]}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      textColor: AppTheme.textColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 100,
                child: AppText.appText(
                  timeDifference,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.appColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
