import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Post%20screens/post_screen.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';
import 'package:tt_offer/views/Sellings/item_dashboard.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/views/Sellings/new_sold_screen.dart';
import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../Utils/widgets/others/no_data_found.dart';
import '../../config/keys/pref_keys.dart';
import '../../data/response/status.dart';
import '../../models/product_model.dart';
import '../../view_model/selling/selling_view_model.dart';
import '../Rating/user_rating_screen.dart';


class SellingPurchaseScreen extends StatefulWidget {
  final String title;
  final String? selectedOption;

  const SellingPurchaseScreen({Key? key, required this.title, this.selectedOption})
      : super(key: key);

  @override
  State<SellingPurchaseScreen> createState() => _SellingPurchaseScreenState();
}

class _SellingPurchaseScreenState extends State<SellingPurchaseScreen> {
  String selectedOption = 'Buying';
  bool isLoading = false;
  AppLogger logger = AppLogger();
  int? userId;

  SellingProductsModel? sellingProductsModel;
  List<Product>? soldProductsList;

  late SellingViewModel sellingViewModel;


  getUserId(){
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    sellingViewModel = Provider.of<SellingViewModel>(context, listen: false);

    if(widget.selectedOption!=null){
      selectedOption = widget.selectedOption!;
    }
    getUserId();

    getSellingProducts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: widget.title,
        leading: false,
      ),
      body: Consumer<SellingViewModel>(
        builder: (context, sellingViewModel, child) {
          List<Product>? selling = sellingViewModel.selling.data ?? [];
          List<Product>? buying = sellingViewModel.buying.data ?? [];
          List<Product>? history = sellingViewModel.history.data ?? [];

          if (sellingViewModel.selling.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.appColor,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                selectOption(),
                if (selectedOption == "Selling")
                  Expanded(
                      child: SellingPurchaseListView(
                    ischeck: 1,
                    productList: selling,
                  )),
                if (selectedOption == "Buying")
                  Expanded(
                      child: SellingPurchaseListView(
                    ischeck: 2,
                    productList: buying,
                  )),
                if (selectedOption == "History")
                  Expanded(
                      child: SellingPurchaseListView(
                    productList: history,
                    ischeck: 3,
                  )),]
            ),
          );
        },
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 21.h , bottom: 15.h),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.3) {
            setState(() {
              selectedOption = 'Buying';
            });
          } else if (tapPosition < screenWidth * 0.6) {
            setState(() {
              selectedOption = 'Selling';
            });
          } else {
            setState(() {
              selectedOption = 'History';
            });
          }
        },
        child: Container(
          height: 40,
          width: screenWidth,
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
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Buying'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Buying',
                    style: TextStyle(
                      color: selectedOption == 'Buying'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    color: selectedOption == 'Selling'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Selling',
                    style: TextStyle(
                      color: selectedOption == 'Selling'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'History'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'History',
                    style: TextStyle(
                      color: selectedOption == 'History'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> getSellingProducts(BuildContext context) async {
  
  SellingViewModel sellingViewModel = Provider.of<SellingViewModel>(context, listen: false);
  sellingViewModel.getSellingProduct();
}


Future<void> getUserSoldProducts(BuildContext context) async {
  try {

    int? userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    var res = await customGetRequest.httpGetRequest(url: 'user/info/$userId');

    if (res['data'] != null || res['success'] == true) {

      List productList = res['data']['products'];
      List<Product> sellingModelList=[];



      for (var element in productList) {
        Product product = Product.fromJson(element);

        if(product.isSold == "1"){
          sellingModelList.add(product);
        }
      }

      Provider.of<SellingPurchaseProvider>(context, listen: false)
          .updateSoldProductData(soldProductList: sellingModelList);


    } else {

    }
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
}






class SellingPurchaseListView extends StatefulWidget {
  final int? ischeck;
  List<Product>? productList;

  SellingPurchaseListView({
    super.key,
    this.ischeck,
    this.productList,
  });

  @override
  State<SellingPurchaseListView> createState() =>
      _SellingPurchaseListViewState();
}

class _SellingPurchaseListViewState extends State<SellingPurchaseListView> {
  // int listCount = 0;
  late List<Product> data;

  @override
  void initState() {
    super.initState();

    data = widget.productList ?? [];
  }



  bool? isItemPurchased(Product product){
    int? userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

      if(product.userId.toString() == userId.toString()){
        return false;
      }
      else if(product.soldToUserId.toString() == userId.toString()){
        return true;
      }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    data = widget.productList ?? [];



    data.sort((a, b) {
      DateTime? dateA = a.createdAt != null ? DateTime.parse(a.createdAt!) : null;
      DateTime? dateB = b.createdAt != null ? DateTime.parse(b.createdAt!) : null;

      // Handle null cases explicitly
      if (dateA == null && dateB == null) {
        return 0; // Both are null, consider them equal
      } else if (dateA == null) {
        return 1; // Place nulls after non-null dates
      } else if (dateB == null) {
        return -1; // Place nulls after non-null dates
      }

      // Both dates are non-null, compare them
      return dateB.compareTo(dateA);
    });

    if (data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NoDataFound.noDataFound(
             bottomPadding: widget.ischeck == 1 ? 20.h : 125.h,
              fontSize: widget.ischeck == 3 ? 14.sp : 15.sp,
              emptyImage : widget.ischeck == 3 ?  'assets/images/empty_data.png' : null,
              spaceHeight: 20.h,
              imageHeight: widget.ischeck == 3 ? 185.h : 255.h,
              emptyText: widget.ischeck == 2 ? 'Begin Buying Items!' : widget.ischeck == 3 ? 'Your purchased and sold items\nwill appear here' : 'Begin Selling Items!',
              spacer: 0),

          if(widget.ischeck == 1)...[
            SizedBox(height: 30.h,),
            AppButton.appButton('Post an items',
                backgroundColor: AppTheme.appColor,
                onTap: (){push(context, const PostScreen());},
                height: 48.h,
                width: 180.w,
                fontSize: 14.sp,
                imagePath: "assets/images/ic_gallery.png",
                imageColor: Colors.white,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                textColor: Colors.white),
            SizedBox(height: 27.h,),
          ]
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: data.length,
      itemBuilder: (context, index) {
        bool restrictMarkSold = false;
        if(data[index].productType == 'auction' && endTimeReached(data[index].auctionEndingDate ?? '', data[index].auctionEndingTime ?? '')==false){
          restrictMarkSold = true;
        }
        return InkWell(
          onTap:() {
            if(widget.ischeck == 1) {
              push(
                context,
                ItemDashBoard(
                  product: data[index],
                ));
            }
            else {
                navigateToProductPage(productId: data[index].id);
            }


          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.ischeck == 1) {
                          push(
                              context,
                              ItemDashBoard(
                                product: data[index],
                              ),
                          then: (){
                            getSellingProducts(context);
                          });
                        }
                        else{
                            navigateToProductPage(productId: data[index].id);}
                      },
                      child: SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: data[index].photo?.isEmpty ?? true
                                              ? Image.asset('assets/images/gallery.png')
                                              : Image.network(
                                                 data[index].photo![0].url!,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                                height: 25.h,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(16),
                                                    bottomRight: Radius.circular(16),
                                                  ),

                                                ),
                                                child: Center(child: AppText.appText(productPriceForImage(data[index]), fontSize: 10.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85))))),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: getWidth(context) * .5,
                                          child: AppText.appText(
                                              data[index].title ?? "",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              maxlines: 1,
                                              textColor: AppTheme.txt1B20),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        if(widget.ischeck != 2)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (widget.ischeck == 1)
                                                InkWell(
                                                  onTap: () {
                                                    if (widget.ischeck == 1) {
                                                      push(
                                                        context,
                                                        SellFaster(
                                                          product: data[index],
                                                          fromLocation: false,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: AppText.appText(
                                                    "Sell faster",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    textColor: AppTheme.yellowColor,
                                                  ),
                                                )
                                              else
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.yellowColor,
                                                        borderRadius: BorderRadius.circular(8.r),
                                                      ),
                                                      child: AppText.appText(
                                                        widget.ischeck == 2
                                                            ? 'Purchased'
                                                            : widget.ischeck == 3
                                                            ? isItemPurchased(data[index]) == true
                                                            ? 'Purchased'
                                                            : 'Sold for ${productPriceInFull(data[index], auctionFullPrice : true)}'
                                                            : '',
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w400,
                                                        textColor: AppTheme.appColor,
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                              const SizedBox(width: 10),

                                              if (widget.ischeck == 1)
                                                Container(
                                                  height: 10,
                                                  width: 1,
                                                  color: const Color(0xffEAEAEA),
                                                ),

                                              const SizedBox(width: 10),

                                              if (widget.ischeck != 3)
                                                InkWell(
                                                  onTap: () {
                                                    if (widget.ischeck == 1) {
                                                      if (!restrictMarkSold) {
                                                        push(
                                                          context,
                                                          NewSoldScreen(
                                                            product: data[index],
                                                            fromMyAds: true,
                                                          ),
                                                          then: () {
                                                            getSellingProducts(context);
                                                            getUserSoldProducts(context);
                                                          },
                                                        );
                                                      } else {
                                                        showSnackBar(context, 'You cannot mark this as sold until the auction has ended.');
                                                      }
                                                    } else if (widget.ischeck == 3) {
                                                      makrAsUnArchive(data[index].categoryId, context);
                                                    }
                                                  },
                                                  child: AppText.appText(
                                                    widget.ischeck == 1
                                                        ? "Mark as sold"
                                                        : widget.ischeck == 3
                                                        ? "Unarchive"
                                                        : '',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    textColor: AppTheme.appColor,
                                                  ),
                                                ),
                                            ],
                                          ),

                                        if(widget.ischeck == 3)...[
                                          const SizedBox(
                                            height: 7,
                                          ),

                                        GestureDetector(
                                          onTap: (){
                                            if(isItemPurchased(data[index]) == true){
                                              push(context,
                                                  UserRatingScreen(
                                                      id: data[index].userId?.toString() ?? '',
                                                      userModel : data[index].user,
                                                      productId: data[index].id.toString() ));
                                            }
                                            else{
                                              push(context,
                                                  UserRatingScreen(
                                                      id: data[index].soldToUserId.toString(),
                                                      reviewBuyer: true,
                                                      userModel: data[index].soldToUser,
                                                      productId: data[index].id.toString() ));
                                            }

                                          },
                                          child: AppText.appText(
                                            'Review ${isItemPurchased(data[index]) == true ? "Seller" : 'Buyer'} ',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor,
                                          ),
                                        ),
                                        ]



                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  if(widget.ischeck == 3 && ( isItemPurchased(data[index]) == false ? data[index].soldToUser?.img != null : data[index].user?.img != null ))
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        isItemPurchased(data[index]) == false ? data[index].soldToUser!.img! : data[index].user!.img!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const CustomDivider()
            ],
          ),
        );
      },
    );
  }

  Future<void> markAsSold(int? id, context, int index) async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want mark item as sold ?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Mark as sold",
      context: context,
      loading: isLoading,

      onTap: () async {
        Navigator.of(context).pop();
        showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductSold}/$id");


          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context).then((value) {
              showSnackBar(context, responce["message"], title: 'Success!');
              Navigator.of(context).pop(true);
            });
          }
          else{
            Navigator.of(context).pop(true);
          }

          //
          // }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }

  void makrAsUnArchive(id, BuildContext context) {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want to Unarchive?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Unarchive",
      context: context,
      loading: isLoading,
      onTap: () async {
        Navigator.of(context).pop();
        showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductUnarchive}/$id");

          showSnackBar(context, responce["message"], error: false);
          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context).then((value) => Navigator.of(context).pop(true));
          }
          else {
            Navigator.of(context).pop(true);
          }
          //
          // }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }

  void navigateToProductPage({productId, limit}) async {

    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.navigateToProductPage(productId, context);
  }

 

  
  
  bool endTimeReached(String endDate, String endTimeString) {
    DateTime? endTime = convertEndTimeToUserTimeZone(_parseEndingDateTime(endDate, endTimeString));

    if (kDebugMode) {
      print('endTime $endTime');
    }

    // If the current time is after or at the endTime, return true (end time reached)
    return !endTime.isAfter(DateTime.now());
  }

  DateTime _parseEndingDateTime(String endDate, String endTime) {
    String? endingTimeString = endTime;
    String? endingDateString = endDate;
    DateTime endingDate =
    DateFormat("yyyy-MM-dd").parse(endDate);
    DateTime endingTime;

    if (endingTimeString.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse(endTime);
      if (kDebugMode) {
        print(" vkrvlrvm$endingTime");
      }
    } else {
      endingTime = DateFormat("HH:mm").parse(endTime);
      if (kDebugMode) {
        print(" jf3o3jfpfp3fpk$endingTime");
      }
    }
    return DateTime(
      endingDate.year,
      endingDate.month,
      endingDate.day,
      endingTime.hour,
      endingTime.minute,
    );
  }


  DateTime convertEndTimeToUserTimeZone(DateTime endTime) {
    // Get the user's local time zone offset (e.g., UTC+5)
    Duration userTimeZoneOffset = DateTime.now().timeZoneOffset;

    // Define the time zone offset for UTC+4 (Dubai time)
    const dubaiTimeZoneOffset = Duration(hours: 0);

    // Calculate the difference between user time zone and Dubai time zone
    Duration timeDifference = userTimeZoneOffset - dubaiTimeZoneOffset;

    // Add or subtract the time difference to the endTime
    return endTime.add(timeDifference);
  }


}
