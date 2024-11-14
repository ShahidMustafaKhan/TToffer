import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/views/ShoppingFlow/checkout/checkout_screen.dart';

import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../config/app_urls.dart';
import '../../../config/keys/pref_keys.dart';
import '../../../main.dart';
import '../cart/cart_screen.dart';

// Reusable CustomTextField widget
class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;

  CustomTextField({
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
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
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText : labelText,
                  fillColor: Colors.black38,
                  focusedBorder: InputBorder.none,
                  border: OutlineInputBorder(
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

// Main AccountInfoForm widget
class AccountInfoForm extends StatefulWidget {
  List<Data>? data;
  AccountInfoForm({super.key, this.data});

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

  bool _isLoading = false;

  int? userId;

  @override
  void initState() {
    phoneNumberController.text = "+92";
    userId = int.parse(pref.getString(PrefKey.userId)!);
    fetchCountries();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Register",
        actionOntap: () {
          // Action for Cancel button
        },
      ),
      body: Padding(
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
              SizedBox(height: 8),
              const Text(
                'To continue, we need your contact information.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20.h),
              chooseCountry(),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Street Address',
                controller: streetAddressController,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Street Address 2 (Optional)',
                controller: streetAddress2Controller,
              ),
              SizedBox(height: 16),
              if(selectedCountry!=null && cityItems.isNotEmpty )...[
              chooseCity(),
              SizedBox(height: 16)],
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: 'State or Province',
                      controller: stateController,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      labelText: 'Zip Code',
                      controller: zipCodeController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              phoneField(controller: phoneNumberController, context: context),
              SizedBox(height: 8),
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
                  Text('Phone number is a landline'),
                ],
              ),
              SizedBox(height: 16),
              _isLoading ? const Center(child: CircularProgressIndicator()) :
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
              } else if (selectedCityId == null) {
                showSnackBar(context, "Please select a city.");
              } else if (stateController.text.isEmpty) {
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
          )

          ],
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
            borderSide: BorderSide(
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
            borderSide: BorderSide(
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
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "user_id": userId,
      "city_id": cityId,
      "address": address,
      "address_2": address2,
      "phone_no": phoneNo,
      "is_landline": isLandLine.toString(),
      "state": state,
      "zip_code": zipCode,
    };
    try {
      response = await dio.post(path: AppUrls.saveAddress, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          _isLoading = false;
        });
        push(context, CheckOutScreen(items: widget.data, fromAccountInfo: true,));
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchCountries() async {
    final response = await dio.get(path: AppUrls.getCountries);

    if (response.statusCode == 200) {
      final data = response.data;
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
    } else {
      print("Failed to load countries");
    }
  }

  Future<void> fetchCities(int countryId) async {

    Map<String, dynamic> params = {
      "country_id": countryId.toString(),
    };

    final response = await dio.post(path: AppUrls.getCities, data: params);

    if (response.statusCode == 200) {
      final data = response.data;
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
    } else {
      print("Failed to load cities");
    }
  }



}

