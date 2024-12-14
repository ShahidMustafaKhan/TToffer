import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/data/response/api_response.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/views/Boost%20Plus%20Screens/boost_work.dart';
import 'package:tt_offer/views/ContactPage/contact_page.dart';
import 'package:tt_offer/views/EmailVerification/email_verification_screen.dart';
import 'package:tt_offer/views/PhoneVerify/phone_verify_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/Account%20Settigs/account_setting.dart';
import 'package:tt_offer/views/Profile%20Screen/Settings/settings.dart';
import 'package:tt_offer/views/Profile%20Screen/custom_link.dart';
import 'package:tt_offer/views/Profile%20Screen/saved_products.dart';
import 'package:tt_offer/views/Profile%20Screen/wish_list_products.dart';
import 'package:tt_offer/views/Sellings/selling_purchase.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../Utils/widgets/custom_loader.dart';
import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../data/response/status.dart';
import '../../models/user_model.dart';
import '../../providers/selling_purchase_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? pickedFilePath;
  int? userId;
  late AppDio dio;
  AppLogger logger = AppLogger();

  late UserViewModel userViewModel;


  @override
  void initState() {
    dio = AppDio(context);
    logger.init();

    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getUserProfile();
    getUserDetail();

    super.initState();
  }


  int percentageOfFive(double value) {
    // Convert the string input to a double


    // Calculate the percentage with respect to 5
    int percentage = ((value / 5) * 100).round();

    return percentage;
  }

  getUserDetail() async {
    setState(() {
      userId = int.parse(pref.getString(PrefKey.userId)!);
    });
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedFilePath = image.path;
        userViewModel.updateUserProfileAndImage(userId, pickedFilePath ?? '').then((value){
          showSnackBar(context, 'Profile updated Successfully!', title: 'Congratulations!');
          userViewModel.updateVerification(userId);
        }).onError((error, stackTrace){
          showSnackBar(context, error.toString());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        // backgroundColor: AppTheme.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: AppText.appText("Profile",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.blackColor),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  logoutDialog();
                },
                child: Image.asset(
                  "assets/images/logout.png",
                  height: 20,
                  width: 20,
                ),
              ),
            )
          ],
        ),
        body: Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              UserModel? userModel = userViewModel.userModel.data;
              return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userViewModel.userModel.status == Status.loading
                      ? LoadingDialog()
                      : Column(
                          children: [
                            upperContainer(userModel),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatItem('0', 'Bought'),
                                buildStatItem('0', 'Sold'),
                                buildStatItem('0', 'Followers'),
                                buildStatItem('0', 'Following'),
                              ],
                            ),

                            SizedBox(height: 3.h,),

                            if(userModel?.emailVerifiedAt == null ||
                                userModel?.imageVerifiedAt == null ||
                                userModel?.phoneVerifiedAt == null)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verifiedContainer(
                                      onTap: userModel?.emailVerifiedAt == null
                                          ? () {
                                              push(context,
                                                  const EmailVerificationScreen());
                                            }
                                          : null,
                                      txt: userModel?.emailVerifiedAt == null
                                          ? "Email\nis not\nVerified"
                                          : "Email\nVerified",
                                      img: "assets/images/sms.png",
                                      color: userModel?.emailVerifiedAt == null
                                          ? Colors.red
                                          : null),
                                  verifiedContainer(
                                    onTap: userModel?.imageVerifiedAt == null
                                        ? ()=>pickImage() : null,
                                      img: "assets/images/gallery.png",
                                      color: userModel?.imageVerifiedAt == null
                                          ? Colors.red
                                          : null,
                                      txt: userModel?.imageVerifiedAt == null
                                          ? "Image\nis not\nVerified"
                                          : "Image\nVerified"),
                                  verifiedContainer(
                                      onTap: userModel?.phoneVerifiedAt == null
                                          ? () {
                                              push(context, PhoneVerifyScreen());
                                            }
                                          : null,
                                      txt: userModel?.phoneVerifiedAt == null
                                          ? "Phone\nis not\nVerified"
                                          : "Phone\nVerified",
                                      img: "assets/images/call.png",
                                      color: userModel?.phoneVerifiedAt == null
                                          ? Colors.red
                                          : null),
                                  // if(profileApi
                                  //     .profileData["phone_verified_at"] != null && profileApi
                                  //     .profileData["image_verified_at"] != null && profileApi
                                  //     .profileData["email_verified_at"] != null)
                                  // verifiedContainer(
                                  //     txt: "Join TruYou",
                                  //     color:
                                  //         profileApi.profileData["is_true_you"] == 0
                                  //             ? Colors.red
                                  //             : null,
                                  //     img: "assets/images/verify1.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                  headingText(txt: "Transactions"),
                  customRow(
                      onTap: () {
                        push(
                            context,
                            const SellingPurchaseScreen(
                              title: "Purchase & Sale",
                            ));
                      },
                      txt: "Purchases & Sales",
                      img: "assets/images/receipt.png"),
                  // customRow(
                  //     onTap: () {
                  //       push(context, const PaymentScreen());
                  //     },
                  //     txt: "Payment & Deposit method",
                  //     img: "assets/images/payment.png"),
                  const CustomDivider(),
                  headingText(txt: "Save"),
                  customRow(
                      onTap: () {
                        push(context, const SavedItemsScreen());
                      },
                      txt: "Saved items",
                      img: "assets/images/heart.png"),
                  // customRow(
                  //     onTap: () {},
                  //     txt: "Search alerts",
                  //     img: "assets/images/notification.png"),
                  const CustomDivider(),
                  headingText(txt: "Wishlist"),
                  customRow(
                      onTap: () {
                        push(context, const WishListItemsScreen());
                      },
                      txt: "Wishlist items",
                      img: "assets/images/heart.png"),
                  // customRow(
                  //     onTap: () {},
                  //     txt: "Search alerts",
                  //     img: "assets/images/notification.png"),
                  const CustomDivider(),
                  headingText(txt: "Account"),
                  customRow(
                      onTap: () {
                        push(context, const AccountSettingScreen(), then: (){
                          userViewModel.getUserProfile();
                        });
                      },
                      txt: "Account Settings",
                      img: "assets/images/accountSetting.png"),
                  customRow(
                      onTap: () {
                        push(context, const BoostWorkScreen());
                      },
                      txt: "Boost Plus",
                      img: "assets/images/boostPlus.png"),
                  customRow(
                      onTap: () {
                        push(
                            context,
                            CustomLinkScreen(
                              link: userModel?.username,
                            ));
                      },
                      txt: "Custom Profile Link",
                      img: "assets/images/link.png"),
                  const CustomDivider(),
                  headingText(txt: "Help"),
                  customRow(
                      onTap: () {
                        push(context, const ContactPage());
                      },
                      txt: "Help Center",
                      img: "assets/images/helpCenter.png"),
                  customRow(
                      onTap: () {
                        push(context, const SettingScreen());
                      },
                      txt: "Settings",
                      img: "assets/images/settings.png"),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          }
        ));
  }


  Future<void> logoutDialog() async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Confirm logout",
      description: "Are you sure you want to logout?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes",
      context: context,
      loading: isLoading,

      onTap: () async {
        Navigator.of(context).pop();
        clearCacheAndSignOut();
        SharedPreferences pref =
        await SharedPreferences.getInstance();
        pref.clear();
        Provider.of<SellingPurchaseProvider>(context, listen: false).sellingProductsModel = null;
        userViewModel.userModel =  ApiResponse.notStarted();
        pushUntil(context, const SigInScreen());
      },
    );
  }


  Future<void> clearCacheAndSignOut() async {
    // Sign out from Google
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // Clear shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Optionally, clear other caches if needed
    // e.g., app-specific caches, in-memory caches, etc.

    // Restart the authentication flow or navigate to the login screen
    // For example:
    // Navigator.of(context).pushReplacementNamed('/login');
  }


  Widget verifiedContainer({img, txt, color, Function()? onTap}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        child: InkWell(
          onTap: (onTap),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color ?? AppTheme.appColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "$img",
                    height: 20,
                    color: AppTheme.whiteColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              WordsOnNewLine(text: txt),
              if (!txt.contains("not"))
                const SizedBox(
                  width: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget headingText({txt}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: AppText.appText("$txt",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          textColor: AppTheme.txt1B20),
    );
  }

  Widget customRow({img, txt, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "$img",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget customRowSetting({img, txt, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  img,
                  size: 22,
                  color: Colors.black87,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget upperContainer(UserModel? userModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 110,
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: pickedFilePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(pickedFilePath!),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : userModel?.img != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      fit: BoxFit.fill,
                                      userModel!.img!,
                                    ))
                                : Image.asset(
                                  fit: BoxFit.cover,
                                  "assets/images/default_image.png",
                                ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: AppTheme.whiteColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset("assets/images/camera.png"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12.h,),
                AppText.appText(capitalizeWords(userModel?.name ?? ''),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.txt1B20),
                SizedBox(height: 4.h,),
                AppText.appText("Joined ${formatMonthYear(userModel?.createdAt)}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
                if(userModel?.location!=null)...[
                SizedBox(height: 4.h,),
                AppText.appText(userModel?.location?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20)],
                SizedBox(height: 6.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: userModel?.reviewPercentage == null || userModel?.reviewPercentage == 0.0 ? 40.w : 12.w,),
                    StarRating(
                      percentage: userModel?.reviewPercentage?.round() ?? 0,
                      color: Colors.yellow,
                      size: 25,
                    ),
                    SizedBox(width: 3.w,),
                    AppText.appText(
                            starCount(userModel?.reviewPercentage),
                            fontSize: userModel?.reviewPercentage == null || userModel?.reviewPercentage == 0.0 ? 11.sp : 12.sp,
                            fontWeight: FontWeight.normal,
                            textColor: AppTheme.txt1B20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int percentage;
  final double size;
  final Color color;

  const StarRating({
    Key? key,
    required this.percentage,
    this.size = 30,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the rating based on the percentage
    double rating = (percentage / 100) * 5;
    int filledStars = rating.floor();
    bool hasHalfStar = rating - filledStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < filledStars) {
          return Icon(
            Icons.star,
            color: color,
            size: size,
          );
        } else if (index == filledStars && hasHalfStar) {
          return Icon(
            Icons.star_half,
            color: color,
            size: size,
          );
        } else {
          return Icon(
            Icons.star,
            color:
                const Color(0xffD5DADD),
            size: size,
          );
        }
      }),
    );
  }
}

class WordsOnNewLine extends StatelessWidget {
  final String text;

  WordsOnNewLine({required this.text});

  @override
  Widget build(BuildContext context) {
    // Split the text into words and join them with \n

    return AppText.appText(text,
              textAlign: TextAlign.center,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.txt1B20);
  }
}