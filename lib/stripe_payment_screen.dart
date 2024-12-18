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
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';

import 'Utils/widgets/image_radio_button.dart';
import 'models/product_model.dart';

class StripePaymentScreen extends StatefulWidget {
  final Product? product;
  final String? amount;
  final String? currency;
  final String? day;

  const StripePaymentScreen(
      {super.key, this.product, this.amount, this.day, this.currency});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  bool loading = false;
  late PaymentViewModel paymentViewModel;


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

  @override
  void initState() {
   paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
   super.initState();
  }


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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildPaymentOptions(),
              SizedBox(height: 10.h),
              _buildPlatformSpecificPayment(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  List<Widget> _buildPaymentOptions() {
    return [
      _buildPaymentOption(
        val: '2',
        image: 'visa',
        title: 'Visa',
        visibilityCondition: selectPayment == 'Visa',
      ),
      SizedBox(height: 7.h),
      SvgPicture.asset('assets/svg/divider.svg'),
      SizedBox(height: 10.h),
      _buildPaymentOption(
        val: '3',
        image: 'master',
        title: 'Master',
        visibilityCondition: selectPayment == 'Master',
      ),
      SizedBox(height: 7.h),
      SvgPicture.asset('assets/svg/divider.svg'),
      SizedBox(height: 10.h),
      _buildPaymentOption(
        val: '4',
        image: 'google1',
        title: 'Google Pay',
      ),
      SizedBox(height: 7.h),
      SvgPicture.asset('assets/svg/divider.svg'),
    ];
  }

  Widget _buildPaymentOption({
    required String val,
    required String image,
    required String title,
    bool visibilityCondition = false,
  }) {
    return Column(
      children: [
        ImageWithRadio(
          val: val,
          groupValue: selectedValue,
          image: image,
          title: title,
          onChanged: (val) {
            setState(() {
              selectedValue = val;
              selectPayment = title;
            });
          },
        ),
        Visibility(
          visible: visibilityCondition,
          child: inputCardDetails(),
        ),
      ],
    );
  }

  Widget _buildPlatformSpecificPayment() {
    if (Platform.isIOS) {
      return Column(
        children: [
          _buildPaymentOption(
            val: '1',
            image: 'apple1',
            title: 'Apple Pay',
          ),
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
        ],
      );
    } else if (selectPayment == 'Google' && Platform.isAndroid) {
      return GooglePayButton(
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
        margin: const EdgeInsets.only(top: 10.0, bottom: 0, left: 4),
        onPaymentResult: onGooglePayResult,
        loadingIndicator: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const SizedBox.shrink();
  }


  Widget inputCardDetails(){
    return
      Consumer<PaymentViewModel>(
          builder: (context, paymentViewModel, child) {
            return Visibility(
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
                    paymentViewModel.loading
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
        );
  }

  void _handlePayPress() async {

    paymentViewModel.setLoading(true);

    if (_formKey.currentState?.validate() == true && _card != null) {
      try {
        TokenData data =
        await Stripe.instance.createToken(const CreateTokenParams.card(
            params: CardTokenParams(
              currency: "aed",
            )));


        await fasterProductHandler(
            widget.day!, widget.amount!, widget.currency!, data.id);

      } on StripeException catch (e) {
        paymentViewModel.setLoading(false);
        showSnackBar(context, e.error.localizedMessage ?? '');
      } catch (e) {
        paymentViewModel.setLoading(false);
        showSnackBar(context, e.toString());
      }
    }
  }

  fasterProductHandler(
      String day, String amount, String currency, String token) async {

    await SellFasterStripeService().sellFasterStripeService(
        context: context,
        paymentViewModel: paymentViewModel,
        productId: widget.product?.id,
        nod: day,
        amount: amount,
        currency: currency,
        token: token);

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

        await SellFasterStripeService().sellFasterGooglePay(
            context: context,
          paymentViewModel: paymentViewModel,
          productId: widget.product?.id,
            nod: widget.day!,
            amount: widget.amount!,
            currency: widget.currency!,
            token: paymentToken,
            brand: brand,
            lastFour: last4Digits,
             );
      } else {
        if (kDebugMode) {
          print('Payment failed: Invalid token');
        }
      }
    } catch (e) {
       showSnackBar(context, e.toString());
      if (kDebugMode) {
        print('Error processing payment: $e');
      }
    }
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

}


