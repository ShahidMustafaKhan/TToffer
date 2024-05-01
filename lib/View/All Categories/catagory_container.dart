import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class CatagoryContainer extends StatefulWidget {
  final img;
  final color;
  final txt;

  const CatagoryContainer({super.key, this.img, this.color, this.txt});

  @override
  State<CatagoryContainer> createState() => _CatagoryContainerState();
}

class _CatagoryContainerState extends State<CatagoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77,
      width: 77,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: widget.color),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            widget.img,
            height: 32,
            width: 32,
          ),
          AppText.appText(widget.txt,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              textColor: AppTheme.textColor),
        ],
      ),
    );
  }
}
