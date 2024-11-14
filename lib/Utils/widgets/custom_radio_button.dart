



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/res/app_theme.dart';
import 'others/app_text.dart';

class CustomRadioButton extends StatefulWidget {
  final bool color;
  final String? txt;
  final Function()? onTap;

  CustomRadioButton(this.color, this.txt, this.onTap);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.onTap),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 17,
              width: 17,
              decoration: BoxDecoration(
                  color: widget.color ? AppTheme.appColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: widget.color
                          ? AppTheme.appColor
                          : AppTheme.appColor)),
            ),
          ),
          const SizedBox(width: 8),
          AppText.appText(widget.txt!)
        ],
      ),
    );
  }
}