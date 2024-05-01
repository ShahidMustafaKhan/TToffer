import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class StepsIndicator extends StatefulWidget {
  final conColor1;
  final conColor2;
  final conColor3;
  final circleColor1;
  final circleColor2;
  final circleColor3;
  final circleColor4;

  const StepsIndicator({
    super.key,
    this.conColor1,
    this.conColor2,
    this.conColor3,
    this.circleColor1,
    this.circleColor2,
    this.circleColor3,
    this.circleColor4,
  });

  @override
  State<StepsIndicator> createState() => _StepsIndicatorState();
}

class _StepsIndicatorState extends State<StepsIndicator> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 60,
      width: screenWidth * 0.7,
      child: Stack(
        children: [
          Row(
            children: [
              progressIndicator(
                  color: widget.conColor1 ?? const Color(0xffD1D5DB)),
              progressIndicator(
                  color: widget.conColor2 ?? const Color(0xffD1D5DB)),
              progressIndicator(
                  color: widget.conColor3 ?? const Color(0xffD1D5DB)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              progressNum(bottomTxt: "Post", color1: widget.circleColor1),
              progressNum(bottomTxt: "Detail", color1: widget.circleColor2),
              progressNum(bottomTxt: "Price", color1: widget.circleColor3),
              progressNum(bottomTxt: "Finish", color1: widget.circleColor4),
            ],
          )
        ],
      ),
    );
  }

  progressIndicator({color}) {

    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          height: 2,
          color: color,
          width: MediaQuery.of(context).size.width * 0.2333,
        ));
  }

  progressNum({bottomTxt, color1}) {
    return Column(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color1 ?? Colors.white,
            shape: BoxShape.circle,
            border:
                Border.all(width: 2, color: color1 ?? const Color(0xffD1D5DB)),
          ),
          child: color1 != null
              ? Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    "assets/images/tic.png",
                    height: 9,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffD1D5DB)),
                  ),
                ),
        ),
        const SizedBox(
          height: 8,
        ),
        AppText.appText("$bottomTxt", fontSize: 12, fontWeight: FontWeight.w400)
      ],
    );
  }
}
