
import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
          child: CircularProgressIndicator(
        color: AppTheme.txt1B20,
      )),
    );
  }
}
