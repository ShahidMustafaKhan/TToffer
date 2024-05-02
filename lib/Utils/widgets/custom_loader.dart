import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';

alertDialogueWithLoader({required BuildContext context}) {
  log("alertDialogueWithLoader fired");
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        // height: 300,
        color: Colors.transparent,
        child: Center(
            child: SizedBox(
          // height: 60,
          // width: 60,
          child: CircularProgressIndicator(
            color: AppTheme.appColor,
          ),
        )),
      );
    },
  );
}
