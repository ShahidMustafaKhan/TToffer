import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/View/Authentication%20screens/GoogleSignIn/authentication.dart';
import 'package:tt_offer/View/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';

import '../../../Utils/widgets/others/app_button.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    final googleSignInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: googleSignInProvider.isSigningIn
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.appColor),
              ),
            )
          : Center(
              child: AppButton.appButtonWithLeadingImage(
                "Continue with Google",
                onTap: () async {
                  googleSignInProvider.setSigningIn(true);
                  // setState(() {
                  //   _isSigningIn = true;
                  // });

                  try {
                    await Authentication.initializeFirebase(context: context);
                    print("initialize");
                    await Authentication.signInWithGoogle(context: context);
                    googleSignInProvider.setSigningIn(false);
                  } catch (e) {
                    googleSignInProvider.setSigningIn(false);
                    print("fbjkbfjeblfbekb$e");
                  }
                },
                height: 44,
                imgHeight: 20,
                imagePath: "assets/images/google.png",
              ),
            ),
    );
  } 
}
