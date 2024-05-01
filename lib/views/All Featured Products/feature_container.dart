import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

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
              AppText.appText("2 Week ago",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.appColor),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
