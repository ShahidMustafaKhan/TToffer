import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';
import 'package:tt_offer/views/Sellings/selling_purchase.dart';

import '../../Controller/APIs Manager/chat_api.dart';
import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Controller/APIs Manager/send_notification_service.dart';
import '../../Utils/widgets/loading_popup.dart';
import '../../config/dio/app_dio.dart';
import '../../config/keys/pref_keys.dart';
import '../../custom_requests/bids_service.dart';
import '../../models/bids_model.dart';
import '../../models/chat_list_model.dart';
import '../../providers/bids_provider.dart';
import '../../providers/chat_list_provider.dart';
import '../../utils/utils.dart';
import '../../utils/widgets/custom_loader.dart';
import '../../utils/widgets/others/delete_notification_dialog.dart';
import 'rating_screen.dart';

class NewSoldScreen extends StatefulWidget {
  final String? productId;
  String? title;
  String? image;
  String? fixPrice;
  String? auctionPrice;
  bool auction;
  bool fromNotification;
  bool fromMyAds;

  NewSoldScreen({super.key,  this.auction=false, this.productId , this.fixPrice , this.title, this.auctionPrice, this.image, this.fromNotification = false, this.fromMyAds = false});

  @override
  State<NewSoldScreen> createState() => _NewSoldScreenState();
}

class _NewSoldScreenState extends State<NewSoldScreen> {
  late String? id;

  List<String> messages = [
    'Someone from TToffer',
    'Someone from Outside TToffer?',
    // 'Anthony',
    // 'Mark'
  ];
  List<String> avatar = [
    'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg',
    'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg',
    // 'Anthony',
    // 'Mark'
  ];
  List<ChatListData> chatList = [];

  List<BidsData> bids = [];

  bool fromTTOffer = false;

  int? selectedIndex;
  late final dio;

  getUserDetail() async {
    final apiProvider = Provider.of<ChatApiProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString(PrefKey.userId);

      apiProvider.getAllChats(dio: dio, context: context, userId: id);
    });
  }

  getBidsHandler() async {



    await BidsService().getBidsService(
        context: context, productId: int.parse(widget.productId!));

    bids = Provider.of<BidsProvider>(context, listen: false).bids;
    Set uniqueUserIds = {};

    // Use the where method to filter out bids with duplicate user IDs
    bids.retainWhere((bid) => uniqueUserIds.add(bid.userId));

    setState(() {});

    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString(PrefKey.userId);
    });


    print('getBids--->${bids}');

  }

  @override
  void initState() {
    dio = AppDio(context);
    if(widget.auction == false) {
      getUserDetail();
    } else{
      getBidsHandler();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: CustomAppBar1(title: 'Mark as Sold'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(widget.image!=null && widget.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 70.w,
                            width: 70.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.image!.toString()),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(widget.title!,
                                fontSize: 17, fontWeight: FontWeight.bold),
                            const SizedBox(height: 8),
                            AppText.appText(
                                'AED ${widget.fixPrice == null ? widget.auctionPrice.toString() : widget.fixPrice.toString()}'),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      fromTTOffer == true ? 'Who Bought your product from TToffer?' : 'Who Bought your product?',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: Colors.grey.shade200,
                    ),

                    if(widget.auction == false)
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 120.h,
                      ),
                      child: Consumer<ChatListProvider>(
                          builder: (context, data, child) {
                            List<ChatListData> temp=[];
                              for (var item in data.selling) {
                                if (item.productId.toString() == widget.productId!) {
                                  temp.add(item);
                                }
                              }
                              chatList = temp;
                            return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: fromTTOffer == false ? 2 : chatList.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: (){
                                  selectedIndex=i;

                                  setState(() {
                                  });
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          if(fromTTOffer == false )
                                            SvgPicture.asset('assets/images/Avatar.svg',
                                                width: 35.w,
                                                height: 35.w
                                            )
                                          else
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.green.shade200,
                                              backgroundImage: NetworkImage(fromTTOffer == false ? avatar[i] :
                                              getImageUrl(chatList[i])),
                                            ),

                                          const SizedBox(width: 16),
                                          AppText.appText(fromTTOffer == false ? messages[i] :
                                          chatList.isNotEmpty ? chatList[i].receiver!.id.toString() ==
                                              id
                                              ? capitalizeWords(chatList[i].sender!.name!)
                                              : capitalizeWords(chatList[i].receiver!.name!) : '',
                                              textColor: selectedIndex == i ? AppTheme.yellowColor : null),
                                        ],
                                      ),
                                    ),
                                      Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      ),
                    ),

                    if(widget.auction == true)
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 120.h,
                        ),
                        child: Consumer<BidsProvider>(
                            builder: (context, data, child) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: fromTTOffer == false ? 2 : bids.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: (){
                                      selectedIndex=i;

                                      setState(() {
                                      });
                                    },
                                    child:(fromTTOffer == true && bids[i].user != null) || fromTTOffer == false ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              if(fromTTOffer == false )
                                                SvgPicture.asset('assets/images/Avatar.svg',
                                                width: 35.w,
                                                height: 35.w
                                                )
                                              else
                                              CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Colors.green.shade200,
                                                backgroundImage: NetworkImage(fromTTOffer == false  ? avatar[i] :
                                                getImageUrlBids(bids[i])),
                                              ),
                                              const SizedBox(width: 16),
                                              AppText.appText(fromTTOffer == false  ? messages[i] :
                                             capitalizeWords(bids[i].user!.name!),
                                                  textColor: selectedIndex == i ? AppTheme.yellowColor : null),
                                            ],
                                          ),
                                        ),
                                          Divider(
                                            color: Colors.grey.shade200,
                                          ),
                                      ],
                                    ) : SizedBox(),
                                  );
                                },
                              );
                            }
                        ),
                      ),


          ],
                ),
              ),



              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 22.w),
              //   child: AppText.appText('Messages', fontWeight: FontWeight.w600, fontSize: 16.sp),
              // ),
              // Expanded(
              //   child: SizedBox(
              //       child: Padding(
              //         padding: const EdgeInsets.only(right: 5.0),
              //         child: ChatScreen(isProductChat: true, productId: widget.productId!,),
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25,0,25,5),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.appColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            // showAlertLoader(context: context);
                            try {
                              var responce = await customGetRequest.httpGetRequest(
                                  url: "${AppUrls.markProductSold}/${widget.productId}");


                              if (responce["success"] == true) {
                                showSnackBar(context, responce["message"], title: 'Congratulations!');


                                if(widget.fromNotification == false && widget.fromMyAds == false) {
                                  Navigator.of(context).pop();
                                }
                                Navigator.of(context).pop();

                              }

                              log("responce = $responce");
                            } catch (e) {
                              log("excepion = ${e.toString()}");
                              showSnackBar(context, "Something went Wrong");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 55.0, vertical: 8),
                            child: Text(
                              'Skip',
                              style: TextStyle(color: AppTheme.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        if(fromTTOffer == false && selectedIndex == 0){

                          if(widget.auction == false && chatList.isEmpty){
                            showSnackBar(context, "No users from TT Offer have made an offer on this product yet.");
                          }
                          else if(widget.auction == true && bids.isEmpty){
                            showSnackBar(context, "No users from TT Offer have made an bid on this product yet.");
                          }
                          else{
                            setState(() {
                              fromTTOffer = true;
                            });
                          }

                        }
                        else{
                          if(selectedIndex!=null) {
                            await markAsSold(int.parse(widget.productId!), context , id);
                          }
                          else{
                            showSnackBar(context, "Please select who bought your product or press the skip button to continue.");
                          }
                        }


                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.appColor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 55.0, vertical: 8),
                            child: Text(
                              'Done',
                              style: TextStyle(color: AppTheme.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  getImageUrl(ChatListData chatList) {
    String? receiverImg;
    if (id == chatList.receiver?.id.toString()) {
      receiverImg = chatList.sender?.img ?? avatar[0];
    } else {
      receiverImg = chatList.receiver?.img ?? avatar[0];
    }

    return receiverImg;
  }

  getImageUrlBids(BidsData bidsData) {

    String receiverImg = bidsData.user!=null && bidsData.user!.img!=null ? bidsData.user!.img! :avatar[0];


    return receiverImg;
  }

  getUserId(ChatListData chatList) {
    String? userId;
    if (id == chatList.receiver?.id.toString()) {
      userId = chatList.sender?.id.toString();
    } else {
      userId = chatList.receiver?.id.toString();
    }

    return userId;
  }

  getUserName(ChatListData chatList) {
    String? userName;
    if (id == chatList.receiver?.id.toString()) {
      userName = chatList.sender?.name;
    } else {
      userName = chatList.receiver?.name;
    }

    return userName;
  }


  Future<void> markAsSold(int? id, context, sellerId) async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Do you want mark item as sold ?",
      description: "",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Mark as sold",
      context: context,
      loading: isLoading,
      onTap: () async {
        Navigator.of(context).pop();
        // showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductSold}/$id");


          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {

            showSnackBar(context, responce["message"], title: 'Success!');


            // push(context, RatingScreen(selling: widget.selling));

            if(fromTTOffer){
              SendNotification.sendNotification(
                  context: context,
                  userId: widget.auction == false ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId!,
                  buyerId: widget.auction == false ? getUserId(chatList[selectedIndex!]) : bids[selectedIndex!].userId!,
                  sellerId: sellerId!,
                  text: "Review ${capitalizeWords(widget.auction == false ? getUserName(chatList[selectedIndex!]) : bids[selectedIndex!].user!.username )} for ${(widget.title)} ",
                  type: "Review",
                  typeId: "${sellerId}0000${widget.productId}",
                  status: "unread");
            }

            deleteProductConversation();

            if(widget.fromNotification==false) {
              if(widget.fromMyAds == true){
                Navigator.of(context).pop();
              }
              else{
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            } else{
              Navigator.of(context).pop();
            }
          //
          }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          // showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }


  void deleteProductConversation(){
      deleteProductRelatedConversation(widget.productId!, context);
  }

  Future<void> deleteProductRelatedConversation(String productId, context) async {
    try {
      var responce = await customPostRequest.httpPostRequest(
          url: AppUrls.deleteProductConversation, body: {
            "product_id" : productId,
      });


      if (responce["success"] == true) {

        // push(context, RatingScreen(selling: widget.selling));

        //
      }

      log("responce = $responce");
    } catch (e) {
      log("excepion = ${e.toString()}");
    }
  }

  getSellingProducts(context) async {
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




  Future<void> getUserSoldProducts(BuildContext context) async {
    try {
      var res = await customGetRequest.httpGetRequest(url: 'user/info/${Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"]}');

      if (res['data'] != null || res['success'] == true) {

        List productList = res['data']['products'];
        List<Selling> sellingModelList=[];



        for (var element in productList) {
          Selling selling = Selling.fromJson(element);

          if(selling.isSold == "1"){
            sellingModelList.add(selling);
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

}
