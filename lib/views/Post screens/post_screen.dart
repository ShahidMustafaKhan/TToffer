import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    final imageProvider = Provider.of<ImageNotifyProvider>(context);
    String title =
        _titleController.text; // Ensure _titleController.text is not null

    // if (widget.selling != null) {
    //   Provider.of<ImageNotifyProvider>(context).imagePaths =
    //       widget.selling!.photo!.map((photo) => photo.src).toList();
    //
    //   print(
    //       'pathsssssss--->${Provider.of<ImageNotifyProvider>(context).imagePaths = widget.selling!.photo!.map((photo) => photo.src).toList()}');
    // }
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
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
                                      productId: l.productId!,
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

                        // if (_descController.text.length <= 100) {
                        //   showSnackBar(context,
                        //       "Description must be at least 100 characters");
                        //   return; // Exit the onTap callback if description is less than 100 characters
                        // }

                        // If all conditions are met, proceed with adding the product
                        await addProductFirstStep();

                        push(
                            context,
                            PostDetailScreen(
                              productId: widget.selling == null
                                  ? ourProductId
                                  : widget.selling!.id,
                              title: _titleController.text,
                              selling: widget.selling,
                            ));
                      },
                          height: 53,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          radius: 32.0,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future addProductFirstStep() async {
    final imageProvider =
        Provider.of<ImageNotifyProvider>(context, listen: false);

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
      if (widget.selling != null)
        MapEntry("product_id", widget.selling!.id.toString()),
    ]);

    print(
        'formData---->${formData.fields}'); // Print the content of formData.fields

    if (imageProvider.vedioPath.isNotEmpty) {
      formData.files
          .add(MapEntry("video", await MultipartFile.fromFile(videoFile.path)));
    }
    try {
      response = await dio.post(
          path: widget.selling != null
              ? AppUrls.updateProduct
              : AppUrls.addProduct,
          data: formData);
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

            ourProductId = productId;

            sendImages(
                productId:
                    widget.selling != null ? widget.selling!.id : "$productId");
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

  void getSellingProducts(context) async {
    log("getSellingProducts fired");

    var response;

    // try {
    response = await dio.get(path: AppUrls.sellingScreen);
    var responseData = response.data;
    if (response.statusCode == 200) {
      // sellingData = responseData["sold"];
      SellingProductsModel model = SellingProductsModel.fromJson(responseData);

      Provider.of<SellingPurchaseProvider>(context, listen: false)
          .updateData(model: model);
      // purchaseData = responseData["purchase"];
      // archieveData = responseData["archive"];
    }
    // } catch (e) {
    //   print("Something went Wrong $e");
    //   showSnackBar(context, "Something went Wrong.");
    // }
  }

  void sendImages({productId}) async {
    final imageProvider =
        Provider.of<ImageNotifyProvider>(context, listen: false);
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

    File? myfile;

    for (var i = 0; i < imageProvider.imagePaths.length; i++) {
      final file = File(imageProvider.imagePaths[i]);
      if (imageProvider.imagePaths.isNotEmpty) {
        myfile = File(imageProvider.imagePaths.first);
      }
      if (file.existsSync()) {
        imageFiles.add(await MultipartFile.fromFile(file.path));
      } else {
        // Handle the case where the file does not exist
      }
    }

    if (imageFiles.isNotEmpty) {
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
            showSnackBar(context, "${responseData["status"]}");

            setState(() {
              _isLoading = false;
            });

            print('respomsee--->${responseData["status"]}');
            print('new--->${responseData}');

            return;
          } else {
            setState(() {
              // _descController.clear();
              // _titleController.clear();
              imageProvider.vedioPath = "";
              // imageProvider.imagePaths.clear();
              _isLoading = false;

              title = _titleController.text ??
                  ''; // Ensure _titleController.text is not null

              // push(
              //     context,
              //     PostDetailScreen(
              //       productId: productId,
              //       title: widget.selling != null
              //           ? widget.selling!.title
              //           : _titleController.text,
              //       selling: widget.selling,
              //     ));
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
}
