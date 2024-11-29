import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';

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
  var userId;
  Timer? _timer;
  String selectedOption = 'Selling';
  String emptyMessage = 'Start a chat and it will appear\n   here. If you\'re looking for   \n  something, try to find it on \n                 TTOffer.\nOr post a random ad and act\n     fast! Don\'t miss a deal!';

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserId();
    getUserDetail();

    startTimer();
    super.initState();
  }


  getUserId() async {
    if(Provider.of<ProfileApiProvider>(context, listen: false).profileData!=null){
      userId = Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"];}
    else{
      await Provider.of<ProfileApiProvider>(context, listen: false).getProfile(dio: dio, context: context);
      userId = Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"];}
  }

  List<ChatListData> chatList = [];

  getUserDetail() async {
    final apiProvider = Provider.of<ChatApiProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var id = pref.getString(PrefKey.userId);

      apiProvider.getAllChats(dio: dio, context: context, userId: id);
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final apiProvider = Provider.of<ChatApiProvider>(context, listen: false);
        apiProvider.getAllChats(dio: dio, context: context, userId: userId);
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatApi = Provider.of<ChatApiProvider>(context);
    var chatWidget = Consumer<ChatListProvider>(
      builder: (context, data, child) {

        if (data.loading) {
          return LoadingDialog();
        } else if (selectedOption=='Selling' ? data.selling.isEmpty : data.buying.isEmpty  ) {
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
          chatList = selectedOption=='Selling' ? data.selling : data.buying;
        } else{
          List<ChatListData> temp=[];
          for (var item in selectedOption=='Selling' ? data.selling : data.buying) {
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
                if(chatList[index].receiver!.id == userId){
                  chatApi.changeUnReadMessagesStatus(
                    dio: dio,
                    context: context,
                    conversationId: chatList[index].conversationId,
                  );
                }

                push(
                    context,
                    OfferChatScreen(
                      userImgUrl: chatList[index].receiver!.id == userId
                          ? chatList[index].sender!.img
                          : chatList[index].receiver!.img,
                      conversationId: chatList[index].conversationId,
                          title: chatList[index].receiver!.id == userId
                              ? chatList[index].sender!.name
                              : chatList[index].receiver!.name,
                          recieverId:
                             chatList[index].receiver!.id == userId
                                  ?  int.parse(chatList[index].senderId!)
                                  : int.parse(chatList[index].receiverId!),
                          sellerId: int.parse(chatList[index].sellerId!),
                          buyerId:  int.parse(chatList[index].buyerId!),
                           productId: chatList[index].productId! ,
                    ));

                // chatApi.getConversation(
                //     dio: dio,
                //     context: context,
                //     conversationId: chatList[index].conversationId,
                //     title: chatList[index].receiver!.id == userId
                //         ? chatList[index].sender!.name
                //         : chatList[index].receiver!.name,
                //     recieverId:
                //         chatList[index].receiver!.id == userId
                //             ? chatList[index].senderId
                //             : chatList[index].receiverId,
                //     sellingId: chatList[index].sellerId,
                //     buyerId:  chatList[index].buyerId,
                //
                // ).then((value) => chatApi.getAllChats(dio: dio, context: context, userId: userId));
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
                            width: 35.w,
                            height: 35.w
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

                            const SizedBox(
                              width: 20,
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
                                        chatList[index].receiver!.id ==
                                            userId
                                            ? capitalizeWords(chatList[index].sender!.name!)
                                            : capitalizeWords(chatList[index].receiver!.name!),
                                        fontSize: 14.5.sp,
                                        fontWeight: FontWeight.w700,
                                        textColor: AppTheme.blackColor),
                                  ),
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
                                        chatList[index].senderId! == userId.toString(),
                                        chatList[index].sender!.name ?? ''
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
                                        chatList[index].unReadMsgsCount != 0 && chatList[index].receiver!.id == userId ? FontWeight.w700 :FontWeight.w400,
                                    textColor: chatList[index].unReadMsgsCount != null &&
                                        chatList[index].unReadMsgsCount != 0 && chatList[index].receiver!.id == userId ? AppTheme.blackColor : Color(0xff626C7B)),
                              ),
                            ],
                          ),
                        ),)

                          ],
                        ),
                      ),

                      Stack(
                        children: [
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
                                    decoration: BoxDecoration(
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

  getImageUrl(ChatListData chatList) {
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
