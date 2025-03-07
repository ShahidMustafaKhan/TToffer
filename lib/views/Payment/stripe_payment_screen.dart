import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/payment-service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';
import '../../Utils/widgets/custom_rightArrow_button.dart';
import '../../Utils/widgets/image_radio_button.dart';
import '../../Utils/widgets/others/payment_confirmation_popup.dart';
import '../../data/response/api_response.dart';
import '../../models/payment_card_model.dart';
import '../../models/product_model.dart';
import '../../models/subscription_model.dart';
import 'new_card_screen.dart';

class StripePaymentScreen extends StatefulWidget {
  final Product? product;
  final Subscription? subscriptionModel;
  final bool checkout;


  const StripePaymentScreen(
      {super.key, this.product, this.subscriptionModel, this.checkout = false});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {

  bool loading = false;
  late PaymentViewModel paymentViewModel;

  Subscription? subscriptionModel;

  double? amount;
  int? userId;
  String? selectedValue;
  String? selectPayment;

  late bool checkout;


  @override
  void initState() {
   paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
   subscriptionModel = widget.subscriptionModel;

   checkout = widget.checkout;

   if(subscriptionModel != null){
     amount = subscriptionModel?.price;
   }

   userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
   getSavedPaymentCards();
   super.initState();
  }

  void getSavedPaymentCards(){
    paymentViewModel.getAllCards(userId: userId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar1(
        title: checkout ? 'Pay with' : 'Subscription',
      ),
      body: Consumer<PaymentViewModel>(
          builder: (context, paymentViewModel, child) {
            List<PaymentCard> paymentCardList = paymentViewModel.paymentCardList.data ?? [];
            return paymentViewModel.paymentLoading ?
                const Center(child: CircularProgressIndicator()) :
                SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addCard(),
                  _saveCardList(paymentCardList),
                  _googlePayButton(paymentCardList)

                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _addCard(){
    return _buildNewCardOption(
      image: 'add_new_card',
      title: 'Add new card',
      visibilityCondition: selectPayment == 'Visa',
    );
  }

  Widget _saveCardList(List<PaymentCard> paymentCardList){
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentCardList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(height: 7.h),
            SvgPicture.asset('assets/svg/divider.svg'),
            SizedBox(height: 10.h),
            _buildPaymentOption(
              onTap: (){
                if(checkout){
                  paymentViewModel.getCardDetail(userId: userId, id: paymentCardList[index].id).
                then((value){
                    Navigator.of(navigatorKey.currentState!.context).pop();
                  })
                      .onError((error, stackTrace){
                        showSnackBar(navigatorKey.currentState!.context, error.toString());
                  });
                }
                else{
                  selectedValue = (index + 1).toString();
                  selectPayment = '';
                  setState(() {});
                  paymentConfirmation(
                      context,
                      subscriptionModel?.price,
                          (){
                        Navigator.of(context).pop();
                        PaymentService.boostProductWithSavedCard(context: context,
                            userId: userId,
                            productId: widget.product?.id,
                            subscription: subscriptionModel,
                            cardId: paymentCardList[index].id
                        ).onError((error, stackTrace) {
                          paymentViewModel.setPaymentLoading(false);
                          debugPrint("Error in payment: $error\n$stackTrace");
                          showSnackBar(navigatorKey.currentState!.context, error.toString());
                        });
                      }
                  );
                }},
              val: (index + 1).toString(),
              image: paymentCardList[index].brand == 'MasterCard' || paymentCardList[index].brand == 'Master' ? 'master' :
              paymentCardList[index].brand == 'Visa' || paymentCardList[index].brand == 'visa' ? 'visa' : 'add_new_card',
              title: capitalizeWords(paymentCardList[index].brand ?? ''),
              visibilityCondition: selectPayment == 'Master',
            )
          ],
        );
      },
    );
  }

  Widget _googlePayButton(List<PaymentCard> paymentCardList){
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 7.h),
          SvgPicture.asset('assets/svg/divider.svg'),
          SizedBox(height: 10.h),
          _buildPaymentOption(
            onTap: (){
              if(checkout == true){
                paymentViewModel.setSelectedPaymentCard(ApiResponse.completed(PaymentCard(brand: 'Google Pay')));
                Navigator.of(navigatorKey.currentState!.context).pop();
              }
              else{
                selectPayment = 'Google Pay';
                selectedValue = paymentCardList.isEmpty ? "1" : (paymentCardList.length+1).toString();
                setState(() {});
              }
            },
            val: (paymentCardList.isEmpty ? "1" : (paymentCardList.length+1).toString() ),
            image: 'google1',
            title: 'Google Pay',
            visibilityCondition: selectPayment == 'Google Pay',
          ),
          SizedBox(height: 7.h),
          SvgPicture.asset('assets/svg/divider.svg'),
          SizedBox(height: 10.h),
          if(widget.checkout == false)
          _buildPlatformSpecificPayment(),
        ],
      ),
    );
  }


  Widget _buildPaymentOption({
    required String val,
    required String image,
    required String title,
    Function()? onTap,
    bool visibilityCondition = false,
  }) {
    return Column(
      children: [
        ImageWithRadio(
          val: val,
          onTap: onTap,
          groupValue: selectedValue,
          image: image,
          title: title,
          onChanged: (val) {
            onTap;
            setState(() {
              selectedValue = val;
              selectPayment = title;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNewCardOption({
    required String image,
    required String title,
    bool visibilityCondition = false,
  }) {
    return Column(
      children: [
        ImageWithRightArrow(
          onTap: (){
            push(context, const NewCardInfo(), then: (){selectedValue = null;
            selectPayment = null;
            setState(() {});});
          },
          groupValue: selectedValue,
          image: image,
          title: title,
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
                amount: amount?.toString() ?? '0',
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
    } else if (selectPayment == 'Google Pay' && Platform.isAndroid) {
      return GooglePayButton(
        paymentItems: [
          PaymentItem(
            label: 'Total',
            amount: amount?.toString() ?? '0',
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



  Future<void> onGooglePayResult(paymentResult) async {
    PaymentService.boostProductWithGooglePay(
        paymentResult: paymentResult,
        paymentViewModel: paymentViewModel,
        userId: userId,
        productId: widget.product?.id,
        subscriptionModel: subscriptionModel);
  }



}


