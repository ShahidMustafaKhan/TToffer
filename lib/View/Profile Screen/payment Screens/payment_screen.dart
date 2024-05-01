import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Profile%20Screen/payment%20Screens/edit_add_new.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedOption = 'Accounts';
  int selectedCardIndex = 0;
  List<bool> isSelectedList = [true, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Align(alignment: Alignment.center, child: selectOption()),
            if (selectedOption == "Accounts") accountContainer(),
            if (selectedOption == "Transactions") transactionContainer(),
          ],
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

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.3) {
            setState(() {
              selectedOption = 'Accounts';
            });
          } else if (tapPosition < screenWidth * 0.6) {
            setState(() {
              selectedOption = 'Transactions';
            });
          }
        },
        child: Container(
          height: 45,
          width: 210,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: selectedOption == 'Accounts'
                            ? AppTheme.appColor
                            : const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Accounts'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: AppText.appText(
                    'Accounts',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    textColor: selectedOption == 'Accounts'
                        ? Colors.white // Change text color when selected
                        : Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    border: Border.all(
                        color: selectedOption == 'Transactions'
                            ? AppTheme.appColor
                            : const Color(0xffEDEDED)),
                    color: selectedOption == 'Transactions'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: AppText.appText(
                    'Transactions',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    textColor: selectedOption == 'Transactions'
                        ? Colors.white // Change text color when selected
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountContainer() {
    return Column(
      children: [
        SizedBox(
          height: 70,
          width: 105,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("Total Balance",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.txt1B20),
              AppText.appText("\$5000",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.blackColor),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.appText("Cards",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppTheme.txt1B20),
            GestureDetector(
              onTap: () {
                push(
                    context,
                    const AddEditCardScreen(
                      edit: false,
                    ));
              },
              child: AppText.appText("Add New Card",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.appColor),
            ),
          ],
        ),
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
      ],
    );
  }

  Widget transactionContainer() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Image.asset(
          "assets/images/transaction.png",
          height: 140,
        ),
      ),
    );
  }
}
