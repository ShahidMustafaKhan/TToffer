import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/utils.dart';

class StripePaymentScreen extends StatefulWidget {
  Selling? selling;
  String? amount;
  String? currency;
  String? day;

  StripePaymentScreen(
      {super.key, this.selling, this.amount, this.day, this.currency});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  bool loading = false;

  void _handlePayPress() async {
    if (_formKey.currentState?.validate() == true && _card != null) {
      try {
        TokenData data =
            await Stripe.instance.createToken(const CreateTokenParams.card(
                params: CardTokenParams(
          currency: "aed",
        )));

        // final tokenData = await Stripe.instance.createPaymentMethod(
        //   params: const PaymentMethodParams.card(
        //     paymentMethodData: PaymentMethodData(),
        //   ),
        // );
        print('Token generated: ${data.id}');

        await fasterProductHandler(
            widget.day!, widget.amount!, widget.currency!, data.id);

        // You can send this token to your backend server to process the payment
      } catch (e) {
        print('Error: $e');

        showSnackBar(context, "Something went wrong");
      }
    }
  }

  fasterProductHandler(
      String day, String amount, String currency, String token) async {
    setState(() {
      loading = true;
    });

    await SellFasterStripeService().sellFasterStripeService(
        context: context,
        productId: widget.selling!.id,
        nod: day,
        amount: amount,
        currency: currency,
        token: token);
    setState(() {
      loading = false;
    });
  }

  String? selectedValue;
  String? selectPayment;

  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController cvc = TextEditingController();
  String? _errorCardNameText;
  String? _errorCardNumberText;
  String? _errorCardDateText;
  String? _errorCardCvcText;



  void _validateCardName(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorCardNameText = 'Card name is required';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _errorCardNameText = 'Card name can only contain letters and spaces';
      } else {
        _errorCardNameText = null;
      }
    });
  }

  void _validateCardNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorCardNumberText = 'Card number is required';
      } else if (value.replaceAll(' ', '').length != 16) {
        _errorCardNumberText = 'Card number must be 16 digits';
      } else {
        _errorCardNumberText = null;
      }
    });
  }

  void _validateExpiryDate(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorCardDateText = 'Expiry date is required';
      } else if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
        _errorCardDateText = 'Expiry date must be MM/YY format';
      } else {
        _errorCardDateText = null;
      }
    });
  }

  void _validateCVC(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorCardCvcText = 'CVC is required';
      } else if (value.length != 3) {
        _errorCardCvcText = 'CVC must be 3 digits';
      } else {
        _errorCardCvcText = null;
      }
    });
  }

  String _formatExpiryDate(String value) {
    if (value.length == 2 && !value.contains('/')) {
      return '$value/';
    }
    return value;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar1(
        title: 'Subscription',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 10.h,),
                ImageWithRadio(
                  val: '2',
                  groupValue: selectedValue,
                  image: 'visa',
                  title: 'Visa',
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val;
                      selectPayment = 'Visa';
                    });
                  },
                ),

                Visibility(
                    visible: selectPayment == 'Visa',
                    child: inputCardDetails()),

                SizedBox(height: 7.h,),

                SvgPicture.asset('assets/svg/divider.svg'),

                SizedBox(height: 10.h,),

                ImageWithRadio(
                  val: '3',
                  groupValue: selectedValue,
                  image: 'master',
                  title: 'Master',
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val;
                      selectPayment = 'Master';
                    });
                  },
                ),

                Visibility(
                    visible: selectPayment == 'Master',
                    child: inputCardDetails()),


                SizedBox(height: 7.h,),

                SvgPicture.asset('assets/svg/divider.svg'),

                SizedBox(height: 10.h,),


                ImageWithRadio(
                  val: '4',
                  groupValue: selectedValue,
                  image: 'google1',
                  title: 'Google Pay',
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val;
                      selectPayment = 'Google';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 7.h,),

          SvgPicture.asset('assets/svg/divider.svg'),


        SizedBox(height: 10.h,),

            if (Platform.isIOS)
              ImageWithRadio(
                val: '1',
                groupValue: selectedValue,
                image: 'apple1',
                title: 'Apple Pay',
                onChanged: (val) {
                  setState(() {
                    selectedValue = val;
                    selectPayment = 'Apple';
                  });
                },
              ),

            if (Platform.isIOS)
              ApplePayButton(
                paymentItems: [
                  PaymentItem(
                    label: 'Total',
                    amount: widget.amount!,
                    status: PaymentItemStatus.final_price,
                  ),
                ],
                paymentConfigurationAsset: 'apple_pay_config.json',
                width: 200,
                height: 60,
                margin: const EdgeInsets.only(top: 10.0, bottom: 0, left: 4),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            selectPayment == 'Google' && Platform.isAndroid
                ? GooglePayButton(
                    // paymentConfiguration: PaymentConfiguration.fromJsonString(
                    //     'defaultApplePayConfigString'),
                    paymentItems: [
                      PaymentItem(
                        label: 'Total',
                        amount: widget.amount!,
                        status: PaymentItemStatus.final_price,
                      ),
                    ],
                    paymentConfigurationAsset: 'google_pay_configuration.json',
                    width: 200,
                    height: 60,
                    type: GooglePayButtonType.plain,
                    margin:
                        const EdgeInsets.only(top: 10.0, bottom: 0, left: 4),
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox.shrink(),

            SizedBox(height: 8,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.appText("TToffer Gift Card", fontWeight: FontWeight.w600, fontSize: 15.5.sp, textColor: const Color(0xff1E293B)),
                  SizedBox(height: 8.h,),

                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textColor.withOpacity(0.6), // Slight opacity for hint
                      ),
                      hintText: "Enter TTOffer gift card",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                    ),
                    onChanged: (_) {
                      setState(() {
                        // Update logic here
                      });
                    },
                  ),
                ],
              ),
            ),






            // if (selectPayment == 'Apple' || selectPayment == 'Google')
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         CustomAppFormField(
            //             texthint: 'Card Name', controller: cardName),
            //         const SizedBox(height: 15),
            //         CustomAppFormField(
            //             texthint: 'Card Number', controller: cardNumber),
            //         const SizedBox(height: 15),
            //         Row(
            //           children: [
            //             Expanded(
            //                 child: CustomAppFormField(
            //                     texthint: 'mm/yy', controller: month)),
            //             const SizedBox(width: 10),
            //             Expanded(
            //                 child: CustomAppFormField(
            //                     texthint: 'Last name', controller: cvc)),
            //           ],
            //         ),
            //         const SizedBox(height: 30),
            //         AppButton.appButton('Pay Now',
            //             height: 50, textColor: Colors.white)
            //       ],
            //     ),
            //   )
            // else
            //   const SizedBox.shrink(),

            // selectPayment == 'Master' || selectPayment == 'Visa'
            //     ? Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            //   child: Form(
            //     key: _formKey,
            //     child:  Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Card Name Title
            //         AppText.appText(
            //           'Card name',
            //             fontSize: 12.sp,
            //             fontWeight: FontWeight.w600,
            //             textColor: Colors.black,
            //         ),
            //         SizedBox(height: 8.h),
            //         // Card Name TextField
            //         customTextField(
            //             hintText: 'Card Name',
            //             controller: cardName,
            //             keyboardType: TextInputType.text,
            //             onChanged: _validateCardName,
            //             errorText: _errorCardNameText
            //         ),
            //         SizedBox(height: 16.h),
            //
            //         AppText.appText(
            //           'Card Number',
            //           fontSize: 12.sp,
            //           fontWeight: FontWeight.w600,
            //           textColor: Colors.black,
            //         ),
            //         SizedBox(height: 8.h),
            //         // Card Name TextField
            //         customTextField(
            //           hintText: '2323 2342 4234 4324',
            //           controller: cardNumber,
            //           keyboardType: TextInputType.number,
            //           onChanged: (value) {
            //             _validateCardNumber(value);
            //             final formattedText = value.replaceAll(' ', '');
            //             if (formattedText.length <= 16) {
            //               final newText = formattedText.replaceAllMapped(
            //                 RegExp(r'.{1,4}'),
            //                     (match) => '${match.group(0)} ',
            //               ).trim();
            //               cardNumber.value = TextEditingValue(
            //                 text: newText,
            //                 selection: TextSelection.collapsed(offset: newText.length),
            //               );
            //             }
            //           },
            //           errorText: _errorCardNumberText
            //
            //         ),
            //
            //         SizedBox(height: 16.h),
            //
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   AppText.appText(
            //                     'MM/YY',
            //                     fontSize: 12.sp,
            //                     fontWeight: FontWeight.w600,
            //                     textColor: Colors.black,
            //                   ),
            //                   SizedBox(height: 8.h),
            //                   // Card Name TextField
            //                   customTextField(
            //                       hintText: 'mm/yy',
            //                       controller: month,
            //                       keyboardType: TextInputType.number,
            //                       onChanged:  (value) {
            //                         final newText = _formatExpiryDate(value);
            //                         month.value = TextEditingValue(
            //                           text: newText,
            //                           selection: TextSelection.collapsed(offset: newText.length),
            //                         );
            //                         _validateExpiryDate(newText);
            //                       },
            //                       errorText: _errorCardDateText
            //
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             SizedBox(width: 17.w,),
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   AppText.appText(
            //                     'CVC',
            //                     fontSize: 12.sp,
            //                     fontWeight: FontWeight.w600,
            //                     textColor: Colors.black,
            //                   ),
            //                   SizedBox(height: 8.h),
            //                   // Card Name TextField
            //                   customTextField(
            //                       hintText: 'CVC',
            //                       controller: cvc,
            //                       keyboardType: TextInputType.number,
            //                       onChanged: _validateCVC,
            //                       errorText: _errorCardCvcText
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //
            //         SizedBox(height: 40.h),
            //
            //         AppButton.appButton('Pay Now',
            //             onTap: (){
            //           if(cardNumber.text.isNotEmpty && cardName.text.isNotEmpty && month.text.isNotEmpty && cvc.text.isNotEmpty) {
            //             if (_errorCardCvcText == null &&
            //                 _errorCardNumberText == null &&
            //                 _errorCardNameText == null && _errorCardDateText ==
            //                 null) {
            //               _card = CardFieldInputDetails(
            //                 expiryMonth: int.parse(month.text.split('/')[0]),
            //                 expiryYear: int.parse(month.text.split('/')[1]),
            //                 complete: true,
            //                 cvc: cvc.text,
            //                 number: cardNumber.text,
            //               );
            //
            //               _handlePayPress();
            //             }
            //           }
            //             },
            //             backgroundColor: AppTheme.appColor,
            //             textColor: Colors.white,
            //             radius: 32.r,
            //             fontSize: 13.sp,
            //             padding: EdgeInsets.symmetric(vertical: 15.w))
            //
            //       ],
            //     ),
            //   ),
            // )
            //     : const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }


  Widget customTextField({
    required String hintText,
    required TextEditingController controller,
    required Function(String) onChanged,
    required TextInputType keyboardType,
    required String? errorText,
  }){
    return TextField(
      style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight : FontWeight.normal
      ),
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: const Color(0xff939699),
            fontSize: 14.sp,
            fontWeight : FontWeight.normal
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 20.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: Color(0xFFE5E9EB),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: Color(0xFFE5E9EB),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }


  Widget inputCardDetails(){
    return
        Visibility(
          visible: selectPayment == 'Master' || selectPayment == 'Visa',
          child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CardFormField(
                  onCardChanged: (card) {
                    _card = card;
                  },
                  style: CardFormStyle(
                      borderRadius: 10,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                      placeholderColor: const Color(0xff1E293B),
                      textColor: Colors.black,
                      borderWidth: 1),
                ),
                loading
                    ? CircularProgressIndicator(
                    color: AppTheme.appColor)
                    : AppButton.appButton('Pay',
                    backgroundColor: AppTheme.appColor,
                    height: 53,
                    radius: 32.r,
                    textColor: Colors.white,
                    onTap: _handlePayPress),
              ],
            ),
          ),
                ),
              ),
        );
  }


  Future<void> onGooglePayResult(paymentResult) async {
    // Handle the payment result, which contains the payment token
    print('Payment Result: $paymentResult');

    try {
      // Extract the payment token from the result
      String? paymentToken =
      paymentResult['paymentMethodData']['tokenizationData']['token'];

      String? last4Digits =  paymentResult['paymentMethodData']['info']['cardDetails'];
      String? brand =  paymentResult['paymentMethodData']['info']['cardNetwork'];


      if (paymentToken != null && paymentToken.isNotEmpty) {
        // Payment was successful
        if (kDebugMode) {
          print('Payment was successful');
        }
        // Call your backend processing with the payment token
        await SellFasterStripeService().sellFasterGooglePay(
            context: context,
            productId: widget.selling!.id,
            nod: widget.day!,
            amount: widget.amount!,
            currency: widget.currency!,
            token: paymentToken,
            brand: brand,
            lastFour: last4Digits,
             );
      } else {
        // Payment failed or token is invalid
        if (kDebugMode) {
          print('Payment failed: Invalid token');
        }
      }
    } catch (e) {
      // Handle any errors during the process
      if (kDebugMode) {
        print('Error processing payment: $e');
      }
    }
  }




}

class ImageWithRadio extends StatefulWidget {
  final String? image;
  final String? val;
  final String? groupValue;
  final String? title;

  final Function(String?)? onChanged;

  ImageWithRadio({this.val, this.image, this.onChanged, this.groupValue, this.title});

  @override
  State<ImageWithRadio> createState() => _ImageWithRadioState();
}

class _ImageWithRadioState extends State<ImageWithRadio> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      height: 57.h,
                      width: 71.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Image.asset('assets/images/${widget.image}.png'),
                      )),
                  SizedBox(width: 20.w,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(widget.title!, fontWeight: FontWeight.w600, fontSize: 15.5.sp, textColor: const Color(0xff1E293B)),
                      SizedBox(height: 3.h,),
                      AppText.appText('default', fontWeight: FontWeight.normal, fontSize: 11.5.sp, textColor: const Color(0xffA4A4A4) )

                    ],
                  )
                ],
              ),
              Radio<String>(
                activeColor: AppTheme.appColor,
                value: widget.val!,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
            ],
          ),

        ],
      ),
    );
  }
}
