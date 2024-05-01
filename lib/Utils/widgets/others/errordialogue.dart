import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

alertDialogError({context, message}) {
  return showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: AlertDialog(
          actionsPadding: const EdgeInsets.only(top: 5, left: 0, right: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: AppTheme.appColor,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: AppText.appText(
                "$message",
                fontSize: 24,
                textAlign: TextAlign.center,
                textColor: AppTheme.whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppTheme.whiteColor,
            ),
            Center(
              child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: AppTheme.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      );
    },
  );
}

alertDialogErrorLogin({context, message}) {
  return showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: AlertDialog(
          actionsPadding: const EdgeInsets.only(top: 5, left: 0, right: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: AppTheme.appColor,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: AppText.appText(
                "$message",
                fontSize: 24,
                textAlign: TextAlign.center,
                textColor: AppTheme.whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppTheme.whiteColor,
            ),
            Center(
              child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: AppTheme.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      );
    },
  );
}
