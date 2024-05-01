import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Profile%20Screen/payment%20Screens/edit_add_new.dart';

class PostingPaymentScreen extends StatefulWidget {
  const PostingPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PostingPaymentScreen> createState() => _PostingPaymentScreenState();
}

class _PostingPaymentScreenState extends State<PostingPaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  List<bool> isSelectedList = [true, false, false, false];
  @override
  Widget build(BuildContext context) {
    print("object${isSelectedList[0]}");
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              accountContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardContainer({txt, txt1, img, apple, isSelected, onChanged, ontap}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 71,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(width: 1, color: AppTheme.borderColor)),
                    child: Center(
                      child: Image.asset(
                        "$img",
                        height: 20,
                        width: 45,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.appText("$txt",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.txt1B20),
                      const SizedBox(
                        height: 4,
                      ),
                      AppText.appText("$txt1",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: const Color(0xffA4A4A4)),
                      const SizedBox(
                        height: 4,
                      ),
                      apple == true
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                AppText.appText("Set as default",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: const Color(0xffA4A4A4)),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: ontap,
                                  child: AppText.appText("Edit",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppTheme.appColor),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onChanged,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.appColor : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.appColor),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomDivider())
      ],
    );
  }

  Widget accountContainer() {
    return Column(
      children: [
        cardContainer(
          img: "assets/images/ApplePayment.png",
          txt: "Apple Pay",
          txt1: "Default",
          isSelected: isSelectedList[0],
          onChanged: () {
            setState(() {
              isSelectedList = [true, false, false, false];
            });
          },
          apple: true,
        ),
        if (isSelectedList[0] == true) cardDetail(),
        cardContainer(
          img: "assets/images/visaPayment.png",
          txt: "Visa",
          isSelected: isSelectedList[1],
          txt1: "Expiry 06/2024",
          ontap: () {
            push(
                context,
                const AddEditCardScreen(
                  edit: true,
                ));
          },
          onChanged: () {
            setState(() {
              isSelectedList = [false, true, false, false];
            });
          },
        ),
        if (isSelectedList[1] == true) cardDetail(),
        cardContainer(
          img: "assets/images/masterCardPayment.png",
          txt: "MasterCard",
          isSelected: isSelectedList[2],
          txt1: "Expiry 06/2024",
          ontap: () {
            push(
                context,
                const AddEditCardScreen(
                  edit: true,
                ));
          },
          onChanged: () {
            setState(() {
              isSelectedList = [false, false, true, false];
            });
          },
        ),
        if (isSelectedList[2] == true) cardDetail(),
        cardContainer(
          img: "assets/images/googlePayment.png",
          txt: "Google Pay",
          isSelected: isSelectedList[3],
          txt1: "Expiry 06/2024",
          ontap: () {
            push(
                context,
                const AddEditCardScreen(
                  edit: true,
                ));
          },
          onChanged: () {
            setState(() {
              isSelectedList = [false, false, false, true];
            });
          },
        ),
        if (isSelectedList[3] == true) cardDetail(),
      ],
    );
  }

  Widget customColumn({txt, hintTxt, controller, width}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText("$txt",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.text09),
          const SizedBox(
            height: 10,
          ),
          CustomAppFormField(
            width: width ?? MediaQuery.of(context).size.width,
            texthint: "$hintTxt",
            controller: controller,
            borderColor: AppTheme.borderColor,
            hintTextColor: AppTheme.hintTextColor,
          )
        ],
      ),
    );
  }

  Widget cardDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        customColumn(
            txt: "Card Name",
            hintTxt: "Card Name",
            controller: _nameController),
        customColumn(
            txt: "Card Number",
            hintTxt: "2323 2342 4234 4324",
            controller: _cardNumController),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customColumn(
                width: MediaQuery.of(context).size.width * 0.4,
                txt: "MM/YY",
                hintTxt: "MM/YY",
                controller: _dateController),
            customColumn(
                width: MediaQuery.of(context).size.width * 0.4,
                txt: "CVC",
                hintTxt: "CVC",
                controller: _cvcController),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: AppButton.appButton("Save",
              onTap: () {},
              height: 53,
              radius: 32.0,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              backgroundColor: AppTheme.appColor,
              textColor: AppTheme.whiteColor),
        )
      ],
    );
  }
}
