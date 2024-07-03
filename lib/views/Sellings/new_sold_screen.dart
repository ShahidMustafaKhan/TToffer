import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';

import '../../utils/utils.dart';
import '../../utils/widgets/custom_loader.dart';
import '../../utils/widgets/others/delete_notification_dialog.dart';
import 'rating_screen.dart';

class NewSoldScreen extends StatefulWidget {
  Selling selling;

  NewSoldScreen({required this.selling});

  @override
  State<NewSoldScreen> createState() => _NewSoldScreenState();
}

class _NewSoldScreenState extends State<NewSoldScreen> {
  List<String> messages = [
    'Some from TToffer',
    'Someone from Outside TToffer?',
    'Anthony',
    'Mark'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: CustomAppBar1(title: 'Mark as Sold'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget!.selling.photo![0].src.toString()),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: Column(
                      children: [
                        AppText.appText(widget.selling.title.toString(),
                            fontSize: 17, fontWeight: FontWeight.bold),
                        const SizedBox(height: 8),
                        AppText.appText(
                            '\$${widget.selling.fixPrice == null ? widget.selling.auctionPrice.toString() : widget.selling.fixPrice.toString()}'),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Who Bought your product?',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.grey.shade200,
              ),
              for (int i = 0; i < messages.length; i++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade200,
                          ),
                          const SizedBox(width: 10),
                          Text(messages[i]),
                        ],
                      ),
                    ),
                    if (i < messages.length - 1)
                      Divider(
                        color: Colors.grey.shade200,
                      ),
                    // Only add Divider if not the last item
                  ],
                ),
              const SizedBox(
                  // width: getWidth(context),
                  height: 150,
                  child: ChatScreen(isProductChat: true)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.appColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            push(
                                context, RatingScreen(selling: widget.selling));
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
                        await markAsSold(widget.selling.id, context);
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

  Future<void> markAsSold(int? id, context) async {
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
        // showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductSold}/$id");

          showSnackBar(context, responce["message"]);

          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            push(context, RatingScreen(selling: widget.selling));

            getSellingProducts(context);
            // Navigator.pop(context);
          }
          // Navigator.of(context).pop(true);
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
}
