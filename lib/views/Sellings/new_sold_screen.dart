import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_list_view_model.dart';
import 'package:tt_offer/view_model/selling/selling_view_model.dart';
import '../../Controller/APIs Manager/send_notification_service.dart';
import '../../config/dio/app_dio.dart';
import '../../config/keys/pref_keys.dart';
import '../../data/response/status.dart';
import '../../models/bids_model.dart';
import '../../models/chat_list_model.dart';
import '../../providers/bids_provider.dart';
import '../../utils/utils.dart';
import '../../view_model/bids/bids_view_model.dart';
import '../Rating/rating_screen.dart';

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
  int? id;

  List<String> messages = [
    'Someone from TToffer',
    'Someone from Outside TToffer?',
    // 'Anthony',
    // 'Mark'
  ];
  List<String> avatar = [
    'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg',
    'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg',
  ];
  List<Conversation> chatList = [];

  List<BidsData> bids = [];

  bool fromTTOffer = false;

  int? selectedIndex;
  late final dio;

  late ChatListViewModel chatListViewModel;

  getAllChat() async {
    setState(() {

      chatListViewModel.getAllChat(id);
    });
  }

  getBidsHandler() async {
    if(widget.productId != null) {
      final bidViewModel = Provider.of<BidsViewModel>(context, listen: false);
      await bidViewModel.getBids(int.parse(widget.productId!));

      if(bidViewModel.bidsList.status == Status.completed){

        bids = bidViewModel.bidsList.data?.data ?? [];
        Set uniqueUserIds = {};

        // Use the where method to filter out bids with duplicate user IDs
        bids.retainWhere((bid) => uniqueUserIds.add(bid.userId));

        setState(() {});
      }


    }
  }


  @override
  void initState() {
    dio = AppDio(context);
    id = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    chatListViewModel = Provider.of<ChatListViewModel>(context, listen: false);

    if(widget.auction == false) {
      getAllChat();
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
                        if(widget.image!=null)
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
                                'AED ${widget.auction == true ? widget.auctionPrice.toString() : widget.fixPrice.toString()}'),
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
                      child: Consumer<ChatListViewModel>(
                          builder: (context, data, child) {
                            List<Conversation> temp=[];
                              for (var item in data.sellingChat.data ?? []) {
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
                                              id.toString()
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
                                             capitalizeWords(bids[i].user?.name ?? ''),
                                                  textColor: selectedIndex == i ? AppTheme.yellowColor : null),
                                            ],
                                          ),
                                        ),
                                          Divider(
                                            color: Colors.grey.shade200,
                                          ),
                                      ],
                                    ) : const SizedBox(),
                                  );
                                },
                              );
                            }
                        ),
                      ),


          ],
                ),
              ),



              Consumer<SellingViewModel>(
                  builder: (context, sellingViewModel, child) {
                    return Padding(
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
                                sellingViewModel.markSoldProduct(null, int.parse(widget.productId!), context, (){});
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
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }


  getImageUrl(Conversation chatList) {
    String? receiverImg;
    if (id.toString() == chatList.receiver?.id.toString()) {
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

  getUserId(Conversation chatList) {
    String? userId;
    if (id.toString() == chatList.receiver?.id.toString()) {
      userId = chatList.sender?.id.toString();
    } else {
      userId = chatList.receiver?.id.toString();
    }

    return userId;
  }

  getUserName(Conversation chatList) {
    String? userName;
    if (id.toString() == chatList.receiver?.id.toString()) {
      userName = chatList.sender?.name;
    } else {
      userName = chatList.receiver?.name;
    }

    return userName;
  }


  Future<void> markAsSold(int? id, context, sellerId) async {
           await Provider.of<SellingViewModel>(context, listen: false).markSoldProduct(fromTTOffer==true ? widget.auction == false ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId! : null, int.parse(widget.productId!), context, (){productMarkedSuccessfully(sellerId);});
  }

  void productMarkedSuccessfully(int? sellerId){
    if(fromTTOffer){
      SendNotification.sendNotification(
          context: context,
          userId: widget.auction == false ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId!,
          buyerId: widget.auction == false ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId!,
          sellerId: sellerId,
          text: "Review ${capitalizeWords(widget.auction == false ? getUserName(chatList[selectedIndex!]) : bids[selectedIndex!].user!.name )} for ${(widget.title)} ",
          type: "Review",
          typeId: "${sellerId}0000${widget.productId}",
        productId: int.tryParse(widget.productId ?? ''),);
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
  }


  void deleteProductConversation(){
    chatListViewModel.deleteProductConversation(int.tryParse(widget.productId ?? ''));
  }







}
