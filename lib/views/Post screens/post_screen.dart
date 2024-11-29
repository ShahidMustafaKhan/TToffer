import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/add_post_detail.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../main.dart';

class PostScreen extends StatefulWidget {
  Selling? selling;

  PostScreen({this.selling});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  bool isBack = false;
  String? productId;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserId();


    if (widget.selling != null) _titleController.text = widget.selling!.title!;
    if (widget.selling != null) {
      _descController.text = widget.selling!.description!;
    }

    super.initState();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(PrefKey.userId);
    });
  }

  bool galImage = false;

  var ourProductId;

  @override
  Widget build(BuildContext context) {

    final imageProvider = Provider.of<ImageNotifyProvider>(context);

    return PopScope(
      onPopInvoked: (value){
        imageProvider.imagePaths=[];
        imageProvider.vedioPath='';
        imageProvider.isCompressing=false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar1(
          title: widget.selling != null ? 'Update Post' : "Post an Item",
          leading: false,
          action: true,
          img: "assets/images/cross.png",
          actionOntap: () {
            pushUntil(context, const BottomNavView());
          },
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0,0,20,0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                StepsIndicator(
                  conColor1: AppTheme.appColor,
                  circleColor1: AppTheme.appColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: AppButton.appButtonWithLeadingImage("Take Photo",
                      onTap: () {
                    imageProvider.takePicture();
                  },
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor,
                      imagePath: "assets/svg/camera.svg",
                      // imgHeight: 20,
                      containerWidth: 120.w,
                      height: 48,
                      space: 20.0),
                ),
                AppButton.appButtonWithLeadingImage("Select Image", onTap: () {
                  setState(() {
                    galImage = true;
                  });
                  imageProvider.getImagesFromGallery();
                },
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.textColor,
                    imagePath: "assets/images/gallery1.png",
                    imgHeight: 20,
                    containerWidth: 120.w,
                    height: 48,
                    space: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: AppButton.appButtonWithLeadingImage("Select Video",
                      onTap: () {
                    imageProvider.getVediosFromGallery(context);
                  },
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.textColor,
                      imagePath: "assets/images/video.png",
                      imgHeight: 20,
                      height: 48,
                      containerWidth: 120.w,
                      space: 20.0),
                ),
                imageProvider.isCompressing == true
                    ? SizedBox(
                        height: 110,
                        child: LoadingDialog(),
                      )
                    : imageProvider.imagePaths.isEmpty
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: imageProvider.imagePaths.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 10,
                                          top: 10,
                                          right: 5),
                                      child: Container(
                                        height: 120,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: AppTheme.hintTextColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                                image: FileImage(
                                                  File(imageProvider
                                                      .imagePaths[index]),
                                                ) as ImageProvider,
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 1,
                                      top: 1,
                                      child: InkWell(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          imageProvider.removeImage(index);
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                widget.selling != null && imageProvider.imagePaths.isEmpty
                    ? Wrap(
                        children: [
                          for (var l in widget.selling!.photo!)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 8),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(l.src.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  top: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      await ImageDeleteService()
                                          .imageDeleteService(
                                        context: context,
                                        id: l.id!,
                                        productId: int.parse(l.productId!),
                                      );
                                      setState(() {
                                        widget.selling!.photo!.remove(l);
                                      });
                                    },
                                    child: const Card(
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )
                    : widget.selling != null ||
                            imageProvider.imagePaths.isNotEmpty
                        ? const SizedBox.shrink()
                        : AppText.appText("Add your cover photo first",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.textColor),
                LableTextField(
                  labelTxt: "Title",
                  hintTxt: "NAME, BRAND, MODEL, ETC.",
                  keyboard: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[ -~]'), // This regex allows all printable ASCII characters
                    ),
                  ],
                  onChanged: _capitalizeWords,
                  controller: _titleController,
                ),
                LableTextField(
                  labelTxt: "Description",
                  hintTxt: "DESCRIBE YOUR PRODUCT",
                  controller: _descController,
                  keyboard: TextInputType.visiblePassword,
                  onChanged: _capitalizeFirstWord,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[ -~]'), // This regex allows all printable ASCII characters
                    ),
                  ],
                  maxLines: 3,
                  height: 100.0,
                ),
                Consumer<PostProductViewModel>(
                    builder: (context, provider, child){
                      return provider.firstStepLoading == true
                        ? LoadingDialog()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: AppButton.appButton("Next", onTap: () async {
                              if (imageProvider.imagePaths.isEmpty &&
                                  widget.selling == null) {
                                showSnackBar(context, "Add at least one image");
                                return; // Exit the onTap callback if conditions are not met
                              }

                              if (_titleController.text.isEmpty) {
                                showSnackBar(context, "Enter title");
                                return; // Exit the onTap callback if title is empty
                              }

                              if (_descController.text.isEmpty) {
                                showSnackBar(context, "Enter Description");
                                return; // Exit the onTap callback if description is empty
                              }


                              Map<String, dynamic> data = {
                                "user_id": userId,
                                "title": _titleController.text,
                                "description": _descController.text,
                                if (widget.selling != null) "product_id": widget.selling!.id.toString(),
                                if (isBack == true) "product_id": ourProductId.toString(),
                              };

                              String? videoPath;

                               if (imageProvider.vedioPath.isNotEmpty) {
                                videoPath = imageProvider.vedioPath;
                              }

                              provider.addProductFirstStep(data, imageProvider.imagePaths, update: widget.selling != null || isBack == true, videoPath : videoPath).then((value){
                                var productId = value.data?.productId;
                                ourProductId = productId;

                                Navigator.push(context, CupertinoPageRoute(builder: (_) =>
                                    PostDetailScreen(
                                      productId: value.data?.productId,
                                      title: _titleController.text,
                                      selling: widget.selling,
                                    ))).then((value){
                                  setState(() {
                                    isBack = true;
                                  });
                                });

                              }).onError((error, stackTrace){
                                showSnackBar(context, error.toString());
                                if (kDebugMode) {
                                  print(error.toString());
                                }
                              });


                            },
                                height: 53,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                radius: 32.0,
                                backgroundColor: AppTheme.appColor,
                                textColor: AppTheme.whiteColor),
                          );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  void _capitalizeWords(String text) {
    String capitalizedText = text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    // Update the TextField only if the text is different to avoid unnecessary updates
    if (_titleController.text != capitalizedText) {
      _titleController.value = _titleController.value.copyWith(
        text: capitalizedText,
        selection: TextSelection.collapsed(offset: capitalizedText.length),
      );
    }
  }

  void _capitalizeFirstWord(String text) {
    if (text.isNotEmpty) {
      String capitalizedText = text[0].toUpperCase() + text.substring(1);

      // Update the TextField only if the text is different to avoid unnecessary updates
      if (_descController.text != capitalizedText) {
        _descController.value = _descController.value.copyWith(
          text: capitalizedText,
          selection: TextSelection.collapsed(offset: capitalizedText.length),
        );
      }
    }
  }

}
