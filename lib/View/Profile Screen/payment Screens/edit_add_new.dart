import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';

class AddEditCardScreen extends StatefulWidget {
  final edit;
  const AddEditCardScreen({super.key, this.edit});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: widget.edit == false ? "Add New Card" : "Edit",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
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
                child: AppButton.appButton(  widget.edit == true? "Edit": "Add Payment Method", onTap: () {
                  push(context, const BottomNavView());
                },
                    height: 53,
                    radius: 32.0,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    backgroundColor: AppTheme.appColor,
                    textColor: AppTheme.whiteColor),
              )
            ],
          ),
        ),
      ),
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
}
