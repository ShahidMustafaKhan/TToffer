import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/View/Profile%20Screen/Account%20Settigs/account_setting.dart';
import 'package:tt_offer/View/Profile%20Screen/custom_link.dart';
import 'package:tt_offer/View/Profile%20Screen/payment%20Screens/payment_screen.dart';
import 'package:tt_offer/View/Profile%20Screen/saved_products.dart';
import 'package:tt_offer/View/Sellings/selling_purchase.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? pickedFilePath;
  var userId;
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
    profileApi.getProfile(
      dio: dio,
      context: context,
    );
    getUserDetail();

    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.userId);
    });
  }

  pickImage() async {
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);

    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedFilePath = image.path;
        profileApi.updateProfile(
            dio: dio,
            context: context,
            userId: userId,
            profile: true,
            imgPath: pickedFilePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileApi = Provider.of<ProfileApiProvider>(context);

    return Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  pushUntil(context, const SigInScreen());
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileApi.profileData == null
                  ? LoadingDialog()
                  : Column(
                      children: [
                        upperContainer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            verifiedContainer(
                                txt: "Email Verified",
                                img: "assets/images/sms.png",
                                color: profileApi
                                            .profileData["email_verified_at"] ==
                                        null
                                    ? Colors.greenAccent
                                    : AppTheme.appColor),
                            verifiedContainer(
                                txt: "Image Verified",
                                img: "assets/images/gallery.png",
                                color: profileApi
                                            .profileData["image_verified_at"] ==
                                        null
                                    ? Colors.greenAccent
                                    : AppTheme.appColor),
                            verifiedContainer(
                                txt: "Phone Verified",
                                img: "assets/images/call.png",
                                color: profileApi
                                            .profileData["phone_verified_at"] ==
                                        null
                                    ? Colors.greenAccent
                                    : AppTheme.appColor),
                            verifiedContainer(
                                txt: "Join TruYou",
                                img: "assets/images/verify1.png"),
                          ],
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
              customRow(
                  onTap: () {
                    push(context, const PaymentScreen());
                  },
                  txt: "Payment & Deposit method",
                  img: "assets/images/payment.png"),
              const CustomDivider(),
              headingText(txt: "Save"),
              customRow(
                  onTap: () {
                    push(context, const SavedItemsScreen());
                  },
                  txt: "Saved items",
                  img: "assets/images/heart.png"),
              customRow(
                  onTap: () {},
                  txt: "Search alerts",
                  img: "assets/images/notification.png"),
              const CustomDivider(),
              headingText(txt: "Account"),
              customRow(
                  onTap: () {
                    push(context, const AccountSettingScreen());
                  },
                  txt: "Account Setting",
                  img: "assets/images/accountSetting.png"),
              customRow(
                  onTap: () {},
                  txt: "Boost Plus",
                  img: "assets/images/boostPlus.png"),
              customRow(
                  onTap: () {
                    push(context, const CustomLinkScreen());
                  },
                  txt: "Custom Profile Link",
                  img: "assets/images/link.png"),
              const CustomDivider(),
              headingText(txt: "Help"),
              customRow(
                  onTap: () {},
                  txt: "Help Center",
                  img: "assets/images/helpCenter.png"),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }

  Widget verifiedContainer({img, txt, color}) {
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 80,
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              width: 20,
            ),
            Container(
              child: AppText.appText("$txt",
                  textAlign: TextAlign.center,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.txt1B20),
            ),
          ],
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

  Widget upperContainer() {
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 92,
                  width: 80,
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppTheme.text09,
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
                            : profileApi.profileData["img"] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      fit: BoxFit.fill,
                                      "${profileApi.profileData["img"]}",
                                    ))
                                : null,
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
                AppText.appText("${profileApi.profileData["name"]}",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.txt1B20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StarRating(
                      percentage: profileApi.profileData["review_percentage"],
                      color: Colors.yellow,
                      size: 14,
                    ),
                    AppText.appText(
                        "${(profileApi.profileData["review_percentage"]) / 100 * 5}",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
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
            color: const Color(0xffD5DADD),
            size: size,
          );
        }
      }),
    );
  }
}
