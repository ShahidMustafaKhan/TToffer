import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeatureProductContainer extends StatefulWidget {
  final data;

  const FeatureProductContainer({super.key, this.data});

  @override
  State<FeatureProductContainer> createState() =>
      _FeatureProductContainerState();
}

class _FeatureProductContainerState extends State<FeatureProductContainer> {
  @override
  Widget build(BuildContext context) {
    // Example API date
    String apiDate = "2024-03-19T20:26:04.000000Z";

    // Convert API date to DateTime
    DateTime dateTime = DateTime.parse("${widget.data["user"]["created_at"]}");

    // Calculate time ago
    String timeAgo = getTimeAgo(dateTime);

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
                        image:
                            NetworkImage("${widget.data["photo"][0]["src"]}"),
                        fit: BoxFit.fill)
                    : null),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.whiteColor),
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
                          )),
              ),
            ),
          ),
          AppText.appText("${widget.data["title"]}",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.textColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("\$${widget.data["fix_price"]}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.textColor),
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
                    child: AppText.appText("${widget.data["location"]}",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        textColor: AppTheme.textColor),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  print('${widget.data["user"]["created_at"]}');
                },
                child: AppText.appText('$timeAgo ago',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.appColor),
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }

  String getTimeAgo(DateTime dateTime) {
    // Calculate time ago using the timeago package
    return timeago.format(dateTime, locale: 'en_short');
  }
}
