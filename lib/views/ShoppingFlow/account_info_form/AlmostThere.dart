import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/views/ShoppingFlow/account_info_form/AccountInfoForm.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';


class AlmostThereScreen extends StatelessWidget {
  final List<Cart>? data;
  const AlmostThereScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 14.w, top: 21),
                  child: Row(
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppTheme.appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 55.h,),
              Text(
                'Almost There!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'In order to proceed, we need a little more information about you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13.3.sp,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AppButton.appButton(
                  'Continue',
                  height: 43.h,
                  backgroundColor: AppTheme.appColor,
                  borderColor: AppTheme.appColor,
                  textColor: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  radius: 21.r,
                  onTap: () {
                     push(context, AccountInfoForm(data: data,));

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}