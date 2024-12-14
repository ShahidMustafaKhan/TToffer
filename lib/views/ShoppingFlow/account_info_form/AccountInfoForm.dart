import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/views/ShoppingFlow/checkout/checkout_screen.dart';

import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../config/app_urls.dart';
import '../../../config/keys/pref_keys.dart';
import '../../../main.dart';
import '../cart/cart_screen.dart';



// Main AccountInfoForm widget
class AccountInfoForm extends StatefulWidget {
  final List<Cart>? data;
  const AccountInfoForm({super.key, this.data});

  @override
  State<AccountInfoForm> createState() => _AccountInfoFormState();
}

class _AccountInfoFormState extends State<AccountInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  // Controllers for each text field
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController streetAddress2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isPhoneNumberLandline = false;
  String? selectedCountry;
  String? selectedCity;
  int? selectedCountryId;
  int? selectedCityId;
  List<DropdownMenuItem<String>> countryItems = [];
  List<DropdownMenuItem<String>> cityItems = [];

  int? userId;

  late final CartViewModel cartViewModel;

  @override
  void initState() {
    phoneNumberController.text = "+92";
    userId = int.parse(pref.getString(PrefKey.userId)!);
    cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    fetchCountries();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      appBar: CustomAppBar1(
        title: "Register",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Complete your account info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To continue, we need your contact information.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20.h),
                chooseCountry(),
                const SizedBox(height: 16),
                customTextField(
                  labelText: 'Street Address',
                  controller: streetAddressController,
                ),
                const SizedBox(height: 16),
                customTextField(
                  labelText: 'Street Address 2 (Optional)',
                  controller: streetAddress2Controller,
                ),
                const SizedBox(height: 16),
                if(selectedCountry!=null && cityItems.isNotEmpty )...[
                chooseCity(),
                const SizedBox(height: 16)],
                Row(
                  children: [
                    Expanded(
                      child: customTextField(
                        labelText: 'State or Province',
                        controller: stateController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: customTextField(
                        labelText: 'Zip Code',
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                phoneField(controller: phoneNumberController, context: context),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isPhoneNumberLandline,
                      onChanged: (value) {
                        setState(() {
                          isPhoneNumberLandline = value!;
                        });
                      },
                    ),
                    const Text('Phone number is a landline'),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<CartViewModel>(
                    builder: (context, cartViewModel, child) {
                      return cartViewModel.loading ? const Center(child: CircularProgressIndicator()) :
                    AppButton.appButton(
                                  'Continue',
                                  height: 45.h,
                                  backgroundColor: AppTheme.appColor,
                                  borderColor: AppTheme.appColor,
                                  textColor: Colors.white,
                                  fontSize: 14.sp,
                                  radius: 21.r,
                                  onTap: () {

                    if (selectedCountry == null) {
                      showSnackBar(context, "Please select a country.");
                    } else if (streetAddressController.text.isEmpty) {
                      showSnackBar(context, "Please enter your street address.");
                    }
                    else if (selectedCityId == null) {
                      showSnackBar(context, "Please select a city.");
                    }
                    else if (stateController.text.isEmpty) {
                      showSnackBar(context, "Please enter your state or province.");
                    } else if (zipCodeController.text.isEmpty) {
                      showSnackBar(context, "Please enter your zip code.");
                    } else if (phoneNumberController.text.isEmpty) {
                      showSnackBar(context, "Please enter your phone number.");
                    } else if (isValidPhoneNumber(phoneNumberController.text) == false) {
                      showSnackBar(context, "Please enter correct phone number with country code");
                    } else {
                      saveUserInfo(
                        userId: userId,
                        cityId: selectedCityId,
                        address: streetAddressController.text ,
                        address2: streetAddress2Controller.text,
                        phoneNo: phoneNumberController.text,
                        isLandLine: isPhoneNumberLandline ? 1 : 0 ,
                        state: stateController.text,
                        zipCode: zipCodeController.text

                      );
                    }
                                  },
                                );
                  }
                )
        
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneField({required TextEditingController controller, required BuildContext context}) {
    String initialCountry = "ae";
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          border: Border.all(color: const Color(0xffE5E9EB)),
          borderRadius: BorderRadius.circular(14)),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CountryListPick(
            onChanged: (CountryCode? countryCode) {
              controller.text = countryCode?.dialCode ?? '';
            },
            theme: CountryTheme(
                isShowFlag: true,
                showEnglishName: true,
                isShowTitle: false,
                isShowCode: false,
                isDownIcon: false),
            initialSelection: initialCountry,
            useUiOverlay: false,
            useSafeArea: false,
          ),
          Expanded(
            child: TextFormField(
              cursorColor: AppTheme.textColor,
              cursorHeight: 25,
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  fillColor: Colors.black38,
                  focusedBorder: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseCountry() {
    return Container(
      color: Colors.white,
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          fillColor: Colors.white,
          labelText: 'Country or region',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xffE5E9EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Color(0xffE5E9EB),
            ),
          ),
          errorBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 9, left: 12, right: 12),
        ),
        items: countryItems,
        onChanged: (value) {
          setState(() {
            selectedCountry = value;
            selectedCity = null; // Reset city selection
          });
          if (selectedCountryId != null) {
            cityItems=[];
            setState(() {

            });
            fetchCities(selectedCountryId!);
          }
        },
      ),
    );
  }

  Widget chooseCity() {
    return Container(
      color: Colors.white,
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        value: selectedCity,
        decoration: InputDecoration(
          fillColor: Colors.white,
          labelText: 'City',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xffE5E9EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xffE5E9EB),
            ),
          ),
          errorBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 9, left: 12, right: 12),
        ),
        items: cityItems,
        onChanged: (value) {
          setState(() {
            selectedCity = value;
          });
        },
      ),
    );
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Regular expression for validating phone numbers in the format +923341622234
    final RegExp regex = RegExp(r'^\+92\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  void saveUserInfo({int? userId, int? cityId, String? address, String? address2,
    String? phoneNo, int? isLandLine, String? state, String? zipCode
  }) async {

    Map<String, dynamic> data = {
      "user_id": userId,
      "city_id": cityId,
      "country_id": selectedCountryId,
      "address": address,
      if(address2 != null)
      "address_2": address2,
      "phone_no": phoneNo,
      "is_landline": isLandLine.toString(),
      "state": state,
      "zip_code": zipCode,
    };

    cartViewModel.saveAddress(data).then((value) {
      push(context, CheckOutScreen(items: widget.data, fromAccountInfo: true,));
    }).onError((error, stackTrace){
      showSnackBar(context, error.toString());
    });
  }

  Future<void> fetchCountries() async {

    cartViewModel.fetchCountries().then((data) {
      setState(() {
        countryItems = (data['data'] as List).map((country) {
          return DropdownMenuItem<String>(
            value: country['name'],
            child: Text(country['name']),
            onTap: () {
              selectedCountryId = country['id'];
            },
          );
        }).toList();
      });
    }).onError((error, stackTrace){
      showSnackBar(context, error.toString());
    });
  }

  Future<void> fetchCities(int countryId) async {

    Map<String, dynamic> data = {
      "country_id": countryId.toString(),
    };

    cartViewModel.fetchCities(data).then((data) {
      setState(() {
        cityItems = (data['data'] as List).map((city) {
          return DropdownMenuItem<String>(
            value: city['name'],
            child: Text(city['name']),
            onTap: (){
              selectedCityId = city['id'];
            },
          );
        }).toList();
      });
    }).onError((error, stackTrace){
      showSnackBar(context, error.toString());
    });

  }


  Widget customTextField({required TextEditingController controller, required String labelText, TextInputType keyboardType = TextInputType.text}){
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          border: Border.all(color: const Color(0xffE5E9EB)),
          borderRadius: BorderRadius.circular(14)),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: AppTheme.textColor,
              cursorHeight: 25,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                  labelText : labelText,
                  fillColor: Colors.black38,
                  focusedBorder: InputBorder.none,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 4, left: 12, right: 12)
              ),
            ),
          ),
        ],
      ),
    );
  }



}

