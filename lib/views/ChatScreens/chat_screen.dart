import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_list_view_model.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import '../../Utils/utils.dart';
import 'offer_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.isProductChat, this.productId});

  final bool isProductChat;
  final String? productId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  int? userId;
  Timer? _timer;
  String selectedOption = 'Selling';
  String emptyMessage = 'Start a chat and it will appear\n   here. If you\'re looking for   \n  something, try to find it on \n                 TTOffer.\nOr post a random ad and act\n     fast! Don\'t miss a deal!';
  late ChatListViewModel chatListViewModel;

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    chatListViewModel = Provider.of<ChatListViewModel>(context, listen: false);

    dio = AppDio(context);
    logger.init();
    getUserId();
    getUserDetail();

    startTimer();
    super.initState();
  }


  getUserId() async {
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    if(userId != null){
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.getUserProfile();
      userId = userViewModel.userModel.data?.id;
    }

    }


  List<Conversation> chatList = [];

  getUserDetail() async {
       var id = pref.getString(PrefKey.userId);
      chatListViewModel.getAllChat(int.tryParse(id ?? ''));
  }

  void startTimer() {
    if(widget.isProductChat == false){
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      getUserDetail();
    });
  }
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatWidget = Consumer<ChatListViewModel>(
      builder: (context, chatListViewModel, child) {
        List<Conversation>? sellingChatList = chatListViewModel.sellingChat.data;
        List<Conversation>? buyingChatList = chatListViewModel.buyingChat.data;

        if ((selectedOption =='Selling' && chatListViewModel.sellingChat.status == Status.loading) || (selectedOption =='Buying' && chatListViewModel.buyingChat.status == Status.loading) ) {
          return LoadingDialog();
        } else if ((selectedOption =='Selling' && (sellingChatList?.isEmpty ?? true))  || (selectedOption =='Buying' && (buyingChatList?.isEmpty ?? true) )) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/no_data_folder.png", height: widget.isProductChat==false ? 150.h : 143.h,)),
              if(widget.isProductChat==true)
                SizedBox(height: 15.h,),

              if(widget.isProductChat==false)...[
                SizedBox(height: 15.h,),
              AppText.appText(emptyMessage,
                  fontSize: 14,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.black),
              SizedBox(height: 12.h,)]
            ],
          );
        }
        if(widget.isProductChat==false) {
          chatList = selectedOption=='Selling' ? sellingChatList ?? [] : buyingChatList ?? [];
        } else{
          List<Conversation> temp=[];
          for (var item in selectedOption=='Selling' ? sellingChatList ?? [] : buyingChatList ?? []) {
            if (item.productId.toString() == widget.productId) {
              temp.add(item);
            }
          }
          chatList = temp;
        }
        if(widget.isProductChat==true && chatList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/no_data.png", height : 180.h ),
              ],
            ),
          );
        } else {
          return ListView.builder(
          reverse: false,
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                // if(chatList[index].receiver!.id == userId){
                //   chatListViewModel.markReadChat(chatList[index].conversationId);
                // }

                push(
                    context,
                    OfferChatScreen(
                      userImgUrl: chatList[index].receiver?.id == userId
                          ? chatList[index].sender?.img
                          : chatList[index].receiver?.img,
                      userRating: chatList[index].receiver?.id == userId
                          ? chatList[index].sender?.reviewPercentage
                          : chatList[index].receiver?.reviewPercentage,
                      conversationId: chatList[index].conversationId,
                          title: chatList[index].receiver?.id == userId
                              ? chatList[index].sender?.name
                              : chatList[index].receiver?.name,
                          receiverId:
                             chatList[index].receiver?.id == userId
                                  ?  chatList[index].senderId
                                  : chatList[index].receiverId,
                          sellerId: chatList[index].sellerId,
                          buyerId:  chatList[index].buyerId,
                           productId: chatList[index].productId ,
                    ));


              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(getImageUrl(chatList[index]) == null)
                        SvgPicture.asset('assets/images/Avatar.svg',
                            width: 55.w,
                            height: 55.w
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: getImageUrl(chatList[index]) == null ? Border.all(
                                  color: const Color(0xffa2a2a2),
                                  width: 2
                              ) : null
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                            getImageUrl(chatList[index]) != null
                                ? NetworkImage(getImageUrl(chatList[index]))
                                : const AssetImage("assets/images/user.png")
                            as ImageProvider,
                            radius: 26,
                          ),
                        ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: getImageUrl(chatList[index]) == null ? 11.w : 20.w,
                            ),
                         Expanded(child:  SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppText.appText(
                                        chatList[index].receiver?.id ==
                                            userId
                                            ? capitalizeWords(chatList[index].sender?.name ?? '')
                                            : capitalizeWords(chatList[index].receiver?.name ?? ''),
                                        fontSize: 14.5.sp,
                                        maxlines: 1,
                                        fontWeight: FontWeight.w700,
                                        textColor: AppTheme.blackColor),
                                  ),
                                  SizedBox(width: 8.w,),
                                  if(chatList[index].createdAt!= null)
                                  AppText.appText(
                                      formatTimestamp("${chatList[index].createdAt}"),
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: const Color(0xffA7ACB4)),
                                  SizedBox(width: 15.w,)

                                ],
                              ),


                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: AppText.appText(
                                    msg(chatList[index].message ?? "Image",
                                        chatList[index].senderId == userId,
                                        chatList[index].sender?.name ?? ''
                                    ),

                                    // capitalizeWholeTitle(chatList[index].message ?? "Image",
                                    //   chatList[index].receiver!.id ==
                                    //       userId
                                    //       ? chatList[index].sender!.name!
                                    //       : chatList[index].receiver!.name!,
                                    // ) ,
                                    fontSize: 12.3.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: chatList[index].unReadMsgsCount != null &&
                                        chatList[index].unReadMsgsCount != 0 && chatList[index].receiver?.id == userId ? FontWeight.w700 :FontWeight.w400,
                                    textColor: chatList[index].unReadMsgsCount != null &&
                                        chatList[index].unReadMsgsCount != 0 && chatList[index].receiver?.id == userId ? AppTheme.blackColor : Color(0xff626C7B)),
                              ),
                            ],
                          ),
                        ),)

                          ],
                        ),
                      ),

                      Stack(
                        children: [
                          if(chatList[index].imagePath?.src!=null)
                          Container(
                            width: 55.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                    image: NetworkImage(chatList[index].imagePath!.src!)
                                )
                            ),),
                          if(chatList[index].product!=null)
                            Positioned(
                                bottom: 0,
                                child: Container(
                                    height: 25.h,
                                    width: 55.w,
                                    decoration: const BoxDecoration(
                                        color: Colors.black38,

                                    ),
                                    child: Center(child: AppText.appText(chatList[index].product!.productType == 'auction' ? "Auction" : "AED ${abbreviateNumber(chatList[index].product!.fixPrice.toString() ?? '')}" ?? '', fontSize: 10.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85))))),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        );
        }
      },
    );

    if (widget.isProductChat) {
      return chatWidget;
    } else {
      return Scaffold(
          backgroundColor: AppTheme.whiteColor,
          appBar: AppBar(
            forceMaterialTransparency : false,
            backgroundColor: AppTheme.whiteColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: AppText.appText("Chat",
                fontSize: 20,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.blackColor),
          ),
          body: Column(
            children: [
              selectOption(),
              Expanded(child: chatWidget),
            ],
          ));
    }
  }

  // String? getImage(ChatListData chatData) {
  //   String? receiverImg;
  //   if (recieverId == model.data.participant1.id) {
  //     receiverImg = model.data.participant1.img;
  //   } else {
  //     receiverImg = model.data.participant2.img;
  //   }
  // }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(timestamp);

    Duration difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} M ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} H ago";
    } else if (difference.inDays == 1) {
      return "yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }

  getImageUrl(Conversation chatList) {
    String? receiverImg;
    if (userId == chatList.receiver?.id) {
      receiverImg = chatList.sender?.img;
    } else {
      receiverImg = chatList.receiver?.img;
    }

    return receiverImg;
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 25.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.5) {
            setState(() {
              selectedOption = 'Buying';
            });
          } else {
            setState(() {
              selectedOption = 'Selling';
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
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
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
            ],
          ),
        ),
      ),
    );
  }
  String msg(String? message, bool isCurrentUserSender, String title){
    if(message!=null){
      if(message.contains('accepted the offer') || message.contains('accepted your offer')){
        if(isCurrentUserSender==true) {
          return 'You have accepted this offer';
        }
        else{
          return 'Congratulations!, ${capitalizeWords(title ?? '')} has accepted the offer';
        }
      }
      else if(message.contains('rejected the offer') || message.contains('rejected your offer')){
        if(isCurrentUserSender==true) {
          return 'You have rejected this offer';
        }
        else{
          return '${capitalizeWords(title ?? '')} has rejected the offer';
        }
      }
      else if(message.contains('made an offer')){
        if(isCurrentUserSender==true) {
          return 'You have made an offer';
        }
        else{
          return capitalizeWholeTitle(message, title ?? '');
        }
      }
      else if(message.contains('Unfortunately, the seller has canceled the offer.')){
        if(isCurrentUserSender==true) {
          return 'You have declined the buyer\’s offer and made a special offer';
        }
        else{
          return message;
        }
      }
      else{
        return message;
      }
    }
    else{
      return '';
    }
  }


}
