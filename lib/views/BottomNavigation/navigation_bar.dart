import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/banner_api.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';
import 'package:tt_offer/views/Homepage/LandingPage/landing_screen.dart';
import 'package:tt_offer/views/Post%20screens/post_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';
import 'package:tt_offer/views/Sellings/selling_purchase.dart';

import '../../Constants/app_logger.dart';
import '../../Controller/APIs Manager/chat_api.dart';
import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Utils/widgets/others/congragulations_dialog.dart';
import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../config/app_urls.dart';
import '../../config/dio/app_dio.dart';
import '../../config/keys/pref_keys.dart';
import '../../custom_requests/firebase_messaging_service.dart';
import '../../main.dart';
import '../../models/chat_list_model.dart';
import '../../providers/chat_list_provider.dart';
import '../../providers/screen_state_notifier.dart';
import '../Authentication screens/login_screen.dart';

class BottomNavView extends StatefulWidget {
  final int? index;
  final bool fromLogin;
  final bool showDialog;
  final String? sellerOption;
  const BottomNavView({super.key, this.index, this.fromLogin=false, this.showDialog=false, this.sellerOption});

  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late int selectedIndex;
  bool showUnreadMessageIndicator=false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  var token;
  var authorizationToken;

  static final List<Widget> _widgetOptions = <Widget>[
    const LandingScreen(),
    const ChatScreen(
      isProductChat: false,
    ),
    // PostScreen(),
    const SellingPurchaseScreen(
      title: "Selling"
    ),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    if(authorizationToken==null && index != 0){
      push(context, const SigInScreen());
    }
    else{
      final imageProvider =
      Provider.of<ImageNotifyProvider>(context, listen: false);
      imageProvider.vedioPath = "";
      imageProvider.imagePaths.clear();
      setState(() {
        selectedIndex = index;
      });

      if(index == 1) {
        Provider.of<ScreenStateNotifier>(context, listen: false)
            .setChatScreenActive(true);
      }
      else{
        Provider.of<ScreenStateNotifier>(context, listen: false)
            .setChatScreenActive(false);
      }
    }

  }

  int backPressCounter = 1;
  bool canPopScope = false;


  getAllChat() async {
    final apiProvider = Provider.of<ChatApiProvider>(context, listen: false);

    token = pref.getString('device-token');

      if(authorizationToken != null) {
        apiProvider.getAllChats(
            dio: dio, context: context, userId: userId, updateChatOnly: true);
        if (token != null && token.isNotEmpty) {
          updateDeviceToken(
              dio: dio, context: context, userId: userId, token: token);
        }
      }
  }


  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    authorizationToken = pref.getString(PrefKey.authorization);

    userId = pref.getString(PrefKey.userId);
  }

  @override
  void initState() {
    selectedIndex = widget.index ?? 0;


    dio = AppDio(context);
    logger.init();


    asynchronousMethod();

    Provider.of<BannerController>(context, listen: false).getAllBanner(dio: dio, context: context);


    super.initState();
  }

  @override
  void didChangeDependencies(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.showDialog) {
        congratulationAlertDialog(title: 'Congratulations!', description: "Your ad posted successfully.", context: context, loading: false, onTap: () => Navigator.of(context).pop());
      }
    });
    super.didChangeDependencies();

  }


  Future<void> asynchronousMethod() async {
      await getToken();
      await FirebaseMessagingService().initialize(context, dio);
      getUserProfile();
      getAllChat();
    }


 getUserProfile(){
    if(authorizationToken!=null) {
      final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
      profileApi.getProfile(dio: dio, context: context);
    }
 }


  Future<void> exitDialog() async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Confirm Exit",
      description: "Are you sure you want to exit app?",
      cancelButtonTitle: "Cancel",
      confirmButtonTitle: "Confirm",
      context: context,
      loading: isLoading,

      onTap: () async {
        Navigator.of(context).pop();
        SystemNavigator.pop();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfff6f6f6),
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark

    ));




    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        log("backPressCounter = $backPressCounter");
        if (backPressCounter < 2) {
          backPressCounter++;
          Future.delayed(const Duration(seconds: 2), () {
            backPressCounter--;
          });
        }
        // else if (backPressCounter == 2){
        //   showSnackBar(context,
        //       "Are you sure you want to close the app? Press again to confirm", title: 'Exit Confirmation');
        //   backPressCounter++;
        //   Future.delayed(const Duration(seconds: 4), () {
        //     backPressCounter--;
        //   });
        // }
        else {
          // Navigator.pop(context);
          SystemNavigator.pop();

        }
      },
      child: Scaffold(
          backgroundColor: AppTheme.whiteColor,resizeToAvoidBottomInset: false,
          body: _widgetOptions.elementAt(selectedIndex),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(top: 28.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if(authorizationToken==null && selectedIndex == 0){
                      push(context, const SigInScreen());
                    }
                    else {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen()));
                    }
                  },
                  child: Container(
                    height: 46.w,
                      width: 46.w,
                      decoration: const BoxDecoration(
                         shape: BoxShape.circle,
                     ),
                  child: SvgPicture.asset('assets/svg/add.svg',),
                  ),),
                const SizedBox(height: 5),
                 Text('SELL',style: GoogleFonts.poppins( color: AppTheme.appColor,fontWeight: FontWeight.w600,fontSize: 12.sp),)
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: 61.h,
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.7),
            color: const Color(0xffFCFCFC),
            surfaceTintColor: const Color(0xffFCFCFC),
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomNavBarCard(
                  image1: 'assets/svg/ic_home.svg',
                  image2: 'assets/svg/ic_home_dark.svg',
                  title: 'HOME',
                  changes: selectedIndex == 0 ? true : false,
                  onTap: () {
                    _onItemTapped(0);
                  },
                ),
                SizedBox(width: 25.w,),
                Consumer<ChatApiProvider>(
                    builder: (context, data, child) {
                    return BottomNavBarCard(
                      image1: 'assets/svg/ic_message.svg',
                      image2: 'assets/svg/ic_message_dark.svg',
                      title: 'CHATS',
                      showIndicator: data.showUnReadMessageIndicator,
                      changes: selectedIndex == 1 ? true : false,
                      onTap: () {
                        _onItemTapped(1);
                      },
                    );
                  }
                ),
                Spacer(),
                BottomNavBarCard(
                  image1: 'assets/svg/ic_tag.svg',
                  image2: 'assets/svg/ic_tag_dark.svg',
                  title: 'My ADS',
                  changes: selectedIndex == 2 ? true : false,
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
                SizedBox(width: 25.w,),
                Consumer<ProfileApiProvider>(
                    builder: (context, profileApi, child) {
                      return BottomNavBarCard(
                      image1: profileApi.profileData!=null && profileApi.profileData["img"]!=null ? profileApi.profileData["img"]: 'assets/svg/ic_profile.svg',
                      image2: 'assets/svg/ic_profile_dark.svg',
                      title: 'ACCOUNT',
                      changes: selectedIndex == 3 ? true : false,
                      onTap: () {
                        _onItemTapped(3);
                      },
                    );
                  }
                ),
              ],
            ),
          )

          ),
    );
  }

  updateDeviceToken(
      {required dio,
        required context,
        required userId,
        required token,
      }) async {
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "user_id": userId,
      "token": token,
    };
    try {
      response = await dio.post(path: AppUrls.updateDeviceToken, data: params);
      var responseData = response.data;

      if (responseData['success'] == true) {
      }

      if (response.statusCode == responseCode400) {
      } else if (response.statusCode == responseCode401) {

      } else if (response.statusCode == responseCode404) {


      } else if (response.statusCode == responseCode500) {


      } else if (response.statusCode == responseCode422) {

      } else if (response.statusCode == responseCode200) {

      }
    } catch (e) {
      print("Something went Wrong ${e}");

    }
  }

}

class BottomNavBarCard extends StatefulWidget {
  String? image1;
  String? image2;
  String? title;
  bool? showIndicator;

  Function()? onTap;

  bool changes;

  BottomNavBarCard(
      {super.key,
      this.title,
      this.image1,
      this.onTap,
      this.showIndicator=false,
      required this.changes,
      this.image2});

  @override
  State<BottomNavBarCard> createState() => _BottomNavBarCardState();
}

class _BottomNavBarCardState extends State<BottomNavBarCard> {
  ValueNotifier valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (widget.onTap),
          child: Stack(
            children: [
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 2.h,),
                    Container(
                      height: 3.5.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color:
                          widget.changes ? AppTheme.appColor : Colors.transparent),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        if(widget.image1!.endsWith(".svg"))
                        SvgPicture.asset(
                          fit: BoxFit.cover,
                          widget.changes == true ? widget.image2! : widget.image1!,
                          color: widget.changes == true ? null : const Color(0xff1E293B),
                          height: 24,
                          width: 24,
                        )
                        else
                          Container(
                            height: 24,
                            width: 24,
                            child: CircleAvatar(
                                backgroundImage: NetworkImage(widget.image1!),),
                          ),
                        if(widget.showIndicator==true)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 8, // Adjust the size as needed
                            width: 8,  // Adjust the size as needed
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(widget.title!,style: GoogleFonts.poppins( color: AppTheme.appColor,fontWeight: FontWeight.w600,fontSize: 11.sp),)

                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }




}
