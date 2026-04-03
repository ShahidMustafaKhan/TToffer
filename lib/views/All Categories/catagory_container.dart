import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class CategoryContainer extends StatefulWidget {
  final img;
  final color;
  final txt;

  final bool isList;

  const CategoryContainer(
      {super.key, this.img, this.color, this.txt, required this.isList});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.isList == true
        ? Column(
            children: [
              Container(
                height: 53.w,
                width: 53.w,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: widget.color),
                child: Image.asset(
                  widget.img,
                ),
              ),
              const SizedBox(height: 4),
              AppText.appText(
                  widget.txt == 'Property for Sale'
                      ? ' Property\n for Sale'
                      : widget.txt == 'Property for Rent'
                          ? ' Property\n for Rent'
                          : widget.txt == 'Furniture & home decor'
                              ? 'Furniture &\nhome decor'
                              : widget.txt == 'Fashion & beauty'
                                  ? 'Fashion\n & beauty'
                                  : widget.txt == 'Electronics & Appliance'
                                      ? 'Electronics\n & Appliance'
                                      : widget.txt,
                  fontSize: 11.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.textColor),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              trailing: Image.asset(
                'assets/images/arrowFor.png',
                height: 20,
                width: 20,
              ),
              title: AppText.appText(widget.txt,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor),
              leading: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: widget.color),
                child: Image.asset(
                  widget.img,
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          );
  }
}
