import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/notification_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
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

  List<bool> checks = [];

  getNotificationHandler() async {
    setState(() {
      loading = true;
    });

    await NotificationService().notificationService(context: context);

    setState(() {});

    setState(() {
      loading = false;
    });

    notification =
        Provider.of<NotificationProvider>(context, listen: false).notifications;
    checks = List.generate(notification.length, (index) => false);

    setState(() {});
  }

  getNotificationHandlerWithoutLoader() async {
    await NotificationService().notificationService(context: context);

    notification =
        Provider.of<NotificationProvider>(context, listen: false).notifications;
    checks = List.generate(notification.length, (index) => false);

    setState(() {});
  }

  deleteHandler(int? id) async {
    setState(() {
      delLoading = true;
    });

    await NotificationDeleteRequest()
        .notificationDeleteRequest(context: context, notificationId: id);

    setState(() {
      delLoading = false;
    });
    getNotificationHandlerWithoutLoader();
    Navigator.pop(context);
  }

  deleteAllNotificationsHandler() async {
    setState(() {
      delLoading = true;
    });
    await NotificationDeleteRequest().deleteAllNotificationRequest(
        context: context, notifications: checkBoxId);
    setState(() {
      delLoading = false;
    });
    getNotificationHandlerWithoutLoader();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getNotificationHandler();
    });
  }

  bool showCheck = false;

  List<int> checkBoxId = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              checks.first = false;
              showCheck = !showCheck;
              setState(() {});
            },
            child: const Center(child: Text('Clear'))),
        actions: [
          checks.isNotEmpty // Check if 'checks' is not empty
              ? checks.first == false // Check the first element if not empty
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: deleteAllNotificationsHandler,
                      child: delLoading
                          ? CircularProgressIndicator(color: AppTheme.appColor)
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: AppTheme.appColor,
                              ),
                            ))
              : const SizedBox.shrink(),
        ],
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setStatess) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0)),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: 346,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: AppTheme.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                AppText.appText(
                                                    'Confirm Delete',
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w700,
                                                    textColor: const Color(
                                                        0xff14181B)),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  child: AppText.appText(
                                                      'Are you sure want to delete this notification',
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      textColor: const Color(
                                                          0xff14181B)),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                delLoading
                                                    ? CircularProgressIndicator(
                                                        color:
                                                            AppTheme.appColor)
                                                    : AppButton.appButton(
                                                        'Delete',
                                                        onTap: () async {
                                                        deleteHandler(
                                                            notification[index]
                                                                .id);

                                                        setStatess(() {});

                                                        await NotificationService()
                                                            .notificationService(
                                                                context:
                                                                    context);
                                                        setStatess(() {});
                                                      },
                                                        height: 53,
                                                        fontSize: 14,
                                                        radius: 32.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textColor:
                                                            AppTheme.whiteColor,
                                                        backgroundColor:
                                                            AppTheme.appColor),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                AppButton.appButton('Cancel'!,
                                                    onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                    height: 53,
                                                    fontSize: 14,
                                                    radius: 32.0,
                                                    border: true,
                                                    fontWeight: FontWeight.w500,
                                                    textColor:
                                                        AppTheme.blackColor,
                                                    backgroundColor:
                                                        AppTheme.whiteColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                });
                              },
                            );
                          },
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                showCheck
                                    ? Checkbox(
                                        activeColor: AppTheme.appColor,
                                        value: checks[index],
                                        onChanged: (che) {
                                          setState(() {
                                            checks[index] = che!;
                                            if (che) {
                                              // Add the ID to checkBoxId when the checkbox is checked
                                              checkBoxId
                                                  .add(notification[index].id!);
                                            } else {
                                              // Remove the ID from checkBoxId when the checkbox is unchecked
                                              checkBoxId.remove(
                                                  notification[index].id!);
                                            }
                                            print('checkBoxId: $checkBoxId');
                                          });
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              notification[index]
                                                  .user!
                                                  .img
                                                  .toString()),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                SizedBox(width: 10)
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            horizontalTitleGap: 0,
                            minLeadingWidth: 0,
                            title: Text(notification[index].text.toString()),
                            subtitle: Text(notification[index].type.toString()),
                            trailing: const Text('31min Ago'),
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
