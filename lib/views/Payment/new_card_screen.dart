
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/payment-service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';


class NewCardInfo extends StatefulWidget {

  const NewCardInfo(
      {super.key});

  @override
  _NewCardInfoState createState() => _NewCardInfoState();
}

class _NewCardInfoState extends State<NewCardInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  bool loading = false;
  late PaymentViewModel paymentViewModel;
  int? userId;
  final FocusNode _focusNode = FocusNode();



  @override
  void initState() {
    paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
     paymentViewModel.setLoading(false);
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar1(
        title: 'Enter your new card info',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lock_sharp, size: 17,),
                SizedBox(width: 7.w,),
                Expanded(
                  child: AppText.appText(
                      'Your Payment is secure. Your card details will not be shared with sellers.',
                      fontWeight: FontWeight.w600,
                      fontSize: 11.2.sp
                  ),
                )
              ],
            ),
            inputCardDetails(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.1),
                  child: Icon(Icons.info_outline, size: 15.w,),
                ),
                SizedBox(width: 5.w,),
                AppText.appText(
                    'Your card will be saved for future orders.',
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5.sp
                ),
              ],
            ),
            const Spacer(),
            _saveButton()



          ],
        ),
      ),
    );
  }


  Widget inputCardDetails(){
    return
      Padding(
        padding: EdgeInsets.only(top: 20.h, bottom: 0.h, left: 6.w, right: 6.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CardFormField(
                onCardChanged: (value){
                  _card = value;
                },
                autofocus: false,

                style: CardFormStyle(
                    borderRadius: 10,
                    backgroundColor: Colors.white,
                    borderColor: Colors.black,
                    placeholderColor: const Color(0xff1E293B),
                    textColor: Colors.black,
                    borderWidth: 1),
              ),
            ],
          ),
        ),
      );
  }

  Widget _saveButton(){
    return Consumer<PaymentViewModel>(
        builder: (context, paymentViewModel, child) {
          return AppButton.appButton('Save',
            backgroundColor: AppTheme.appColor,
            height: 53,
            radius: 32.r,
            textColor: Colors.white,
            loading: paymentViewModel.loading,
            loadingColor: Colors.white,
            onTap: _handlePayPress);
      }
    );
  }



  void _handlePayPress() async {

    if (_formKey.currentState?.validate() == true && _card?.complete == true) {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        paymentViewModel.setLoading(true);
        await PaymentService.saveNewCard(userId, _card?.brand ?? '', context);
        paymentViewModel.setLoading(false);
        Navigator.of(context).pop();
        showSnackBar(context, 'Your card has been added successfully!', title: "Congratulations!");

      } on StripeException catch (e) {
        paymentViewModel.setLoading(false);
        showSnackBar(context, e.error.localizedMessage ?? '');
      } catch (e) {
        paymentViewModel.setLoading(false);
        showSnackBar(context, e.toString());
      }
    }
    else{
      showSnackBar(context, 'Card details not complete');
    }
  }







}


