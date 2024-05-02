import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/notification_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/custom_logout_pop_up.dart';
import 'package:tt_offer/Utils/widgets/others/delete_notification_dialog.dart';
import 'package:tt_offer/custom_requests/notification_delete_request.dart';
import 'package:tt_offer/models/notifications_model.dart';
import 'package:tt_offer/providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool loading = false;
  bool delLoading = false;

  List<NotificationData> notification = [];

  getNotificationHandler() async {
    setState(() {
      loading = true;
    });

    await NotificationService().notificationService(context: context);

    setState(() {
      loading = false;
    });

    notification =
        Provider.of<NotificationProvider>(context, listen: false).notifications;
    setState(() {});
  }

  deleteHandler() async {
    await NotificationDeleteRequest()
        .notificationDeleteRequest(context: context);
    getNotificationHandler();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getNotificationHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Notifications",
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              color: AppTheme.appColor,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notification.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            // CustomAlertDialog(
                            //     context,
                            //     'Confirm Delete',
                            //     'Are you sure want to delete this notification',
                            //     'Delete', () async {
                            //   deleteHandler();
                            // }, delLoading, 'Cancel');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/auction2.png"),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 230,
                                              child: AppText.appText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  notification[index]
                                                      .text
                                                      .toString(),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  textColor:
                                                      AppTheme.textColor),
                                            ),
                                            AppText.appText(
                                                notification[index]
                                                    .type
                                                    .toString(),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                textColor: AppTheme.textColor),
                                          ],
                                        ),
                                      ],
                                    ),
                                    AppText.appText("34m Ago",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        textColor: AppTheme.textColor),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
