import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/add_post_detail.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import '../../Utils/widgets/video_player.dart';
import '../../models/product_model.dart';

class PostScreen extends StatefulWidget {
  final Product? product;

  const PostScreen({super.key, this.product});

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

  Product? product;

  String? titleError;
  String? descriptionError;

  final _formKey = GlobalKey<FormState>(); // Key to identify the form


  @override
  void initState() {
    product = widget.product;

    dio = AppDio(context);
    logger.init();
    getUserId();


    if (product != null) _titleController.text = product!.title ?? '';
    if (product != null) {
      _descController.text = product!.description ?? '';
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
        imageProvider.videoPath='';
        imageProvider.isCompressing=false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar1(
          title: product != null ? 'Update Post' : "Post an Item",
          leading: false,
          action: true,
          img: "assets/images/cross.png",
          actionOntap: () {
            pushUntil(context, const BottomNavView());
          },
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,0,20,0),
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
                      containerWidth: 110,
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
                    containerWidth: 110,
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
                      containerWidth: 110,
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

                product != null && imageProvider.imagePaths.isEmpty
                    ? Wrap(
                        children: [
                          for (var l in product!.photo!)
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
                                        image: NetworkImage(l.url.toString()),
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
                                        productId: l.productId!,
                                      );
                                      setState(() {
                                        product?.photo!.remove(l);
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
                    : product != null ||
                            imageProvider.imagePaths.isNotEmpty
                        ? const SizedBox.shrink()
                        : imageProvider.videoPath.isNotEmpty ? const SizedBox.shrink() :
                            AppText.appText("Add your cover photo first",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.textColor),

                if(imageProvider.videoPath.isNotEmpty)
                  Stack(
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: VideoPlayerWidget(
                              videoPath: imageProvider.videoPath, // Add your video path here
                            ),
                          ),
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
                            imageProvider.removeVideo();
                          },
                        ),
                      ),
                    ],
                  ),


                Column(
                  children: [
                    LableTextField(
                      labelTxt: "Title",
                      hintTxt: "NAME, BRAND, MODEL, ETC.",
                      keyboard: TextInputType.visiblePassword,
                      errorText: titleError,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[ -~]'), // This regex allows all printable ASCII characters
                        ),
                      ],
                      controller: _titleController,
                      onChanged: (value) {
                        _capitalizeWords(value);

                        if (value.isEmpty) {
                          titleError = "Title is required.";
                        }
                        else{
                          titleError = null;
                        }
                        setState(() {});
                      },
                    ),
                    LableTextField(
                      labelTxt: "Description",
                      hintTxt: "DESCRIBE YOUR PRODUCT",
                      controller: _descController,
                      errorText: descriptionError,
                      keyboard: TextInputType.visiblePassword,
                      onChanged: (value) {
                        _capitalizeFirstWord(value);
                        if (value.isEmpty) {
                          descriptionError = "Description is required.";
                        }
                        else if (value.length < 10) {
                          descriptionError = "Description must be at least 10 characters long.";
                        }
                        else{
                          descriptionError = null;
                        }
                        setState(() {});
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[ -~]'), // This regex allows all printable ASCII characters
                        ),
                      ],
                      maxLines: 3,
                      height: 100.0,
                    ),
                  ],
                ),
                Consumer<PostProductViewModel>(
                    builder: (context, provider, child){
                      return provider.firstStepLoading == true
                        ? LoadingDialog()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: AppButton.appButton("Next", onTap: () async {
                              if (imageProvider.imagePaths.isEmpty &&
                                  product == null) {
                                showSnackBar(context, "Add at least one image");
                                return; // Exit the onTap callback if conditions are not met
                              }

                              if (titleError!=null || descriptionError!=null) {
                                return; // Exit the onTap callback if conditions are not met
                              }

                                // If all fields are valid
                                Map<String, dynamic> data = {
                                  "user_id": userId,
                                  "title": _titleController.text,
                                  "description": _descController.text,
                                  if (product != null) "product_id": product?.id.toString(),
                                  if (isBack == true) "product_id": ourProductId.toString(),
                                };

                                String? videoPath;

                                if (imageProvider.videoPath.isNotEmpty) {
                                  videoPath = imageProvider.videoPath;
                                }

                                provider.addProductFirstStep(data, imageProvider.imagePaths, videoPath : videoPath, update: widget.product != null).then((value){
                                  var productId = value.data?.productId;
                                  ourProductId = productId;

                                  Navigator.push(context, CupertinoPageRoute(builder: (_) =>
                                      PostDetailScreen(
                                        productId: value.data?.productId,
                                        title: _titleController.text,
                                        product: product,
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




