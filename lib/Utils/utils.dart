import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';

showSnackBar(context, text) {
  var snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: AppTheme.appColor,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    elevation: 3,
    width: getWidth(context) * .9,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

push(context, screen) {
  Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
}

pushReplacement(context, screen) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (_) => screen));
}

pushUntil(context, screen) {
  Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (_) => screen), (route) => false);
}
