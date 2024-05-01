import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/View/Post%20screens/add_post_detail.dart';
import 'package:tt_offer/View/Post%20screens/indicator.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(PrefKey.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageNotifyProvider>(context);
    print("istrue:   ${imageProvider.isCompressing}");
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Post an Item",
        leading: false,
        action: true,
        img: "assets/images/cross.png",
        actionOntap: () {
          pushUntil(context, const BottomNavView());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    imagePath: "assets/images/camera.png",
                    imgHeight: 20,
                    height: 48,
                    space: 20.0),
              ),
              AppButton.appButtonWithLeadingImage("Select Image", onTap: () {
                imageProvider.getImagesFromGallery();
              },
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor,
                  imagePath: "assets/images/gallery1.png",
                  imgHeight: 20,
                  height: 48,
                  space: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AppButton.appButtonWithLeadingImage("Select Vedio",
                    onTap: () {
                  imageProvider.getVediosFromGallery(context);
                },
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.textColor,
                    imagePath: "assets/images/video.png",
                    imgHeight: 20,
                    height: 48,
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
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 10),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: AppTheme.hintTextColor,
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: FileImage(
                                            File(imageProvider
                                                .imagePaths[index]),
                                          ),
                                          fit: BoxFit.fill)),
                                ),
                              );
                            },
                          ),
                        ),
              AppText.appText("Add your cover photo first",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppTheme.textColor),
              LableTextField(
                labelTxt: "Title",
                hintTxt: "Title",
                controller: _titleController,
              ),
              LableTextField(
                labelTxt: "Description",
                hintTxt: "Description",
                controller: _descController,
                maxLines: 3,
                height: 100.0,
              ),
              _isLoading == true
                  ? LoadingDialog()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: AppButton.appButton("Next", onTap: () {
                        // push(context, const PostDetailScreen());

                        if (imageProvider.imagePaths.isNotEmpty) {
                          if (_titleController.text.isNotEmpty) {
                            if (_descController.text.isNotEmpty) {
                              if (_descController.text.length > 100) {
                                addProductFirstStep();
                              } else {
                                showSnackBar(context,
                                    "Description must be alteast 100 characters");
                              }
                            } else {
                              showSnackBar(context, "Enter Description");
                            }
                          } else {
                            showSnackBar(context, "Enter title");
                          }
                        } else {
                          showSnackBar(context, "Add atleast one image");
                        }
                      },
                          height: 53,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          radius: 32.0,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void addProductFirstStep() async {
    final imageProvider = Provider.of<ImageNotifyProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500;
    int responseCode413 = 413; // For For data not found

    File videoFile = File(imageProvider.vedioPath);
    var formData = FormData();
    formData.fields.addAll([
      MapEntry("user_id", "$userId"),
      MapEntry("title", _titleController.text),
      MapEntry("description", _descController.text),
    ]);
    if (imageProvider.vedioPath.isNotEmpty) {
      formData.files
          .add(MapEntry("video", await MultipartFile.fromFile(videoFile.path)));
    }
    try {
      response = await dio.post(path: AppUrls.addProduct, data: formData);
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
      } else if (response.statusCode == responseCode413) {
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
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            var productId = responseData["product_id"];
            sendImages(productId: "$productId");
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void sendImages({productId}) async {
    final imageProvider = Provider.of<ImageNotifyProvider>(context, listen: false);
    print("objectId $productId");
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode413 = 413; // For For data not found
    int responseCode500 = 500; // Internal server error.
    List<MultipartFile> imageFiles = [];

    for (var i = 0; i < imageProvider.imagePaths.length; i++) {
      File file = File(imageProvider.imagePaths[i]);
      imageFiles.add(await MultipartFile.fromFile(file.path));
    }
    var formData = FormData.fromMap({
      "product_id": productId,
      "src[]": imageFiles,
    });

    try {
      response = await dio.post(path: AppUrls.addImage, data: formData);
      var responseData = response.data;
      print("object${responseData}");
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode413) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _descController.clear();
            _titleController.clear();
            imageProvider.vedioPath = "";
            imageProvider.imagePaths.clear();
            _isLoading = false;

            push(
                context,
                PostDetailScreen(
                  productId: productId,
                ));
          });
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
