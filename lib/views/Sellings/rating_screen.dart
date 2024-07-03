import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';

class RatingScreen extends StatefulWidget {
  Selling? selling;

  RatingScreen({this.selling});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double? starValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Rate Seller',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 50),
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26),
                      image: DecorationImage(
                          image: widget.selling!.user!.img.isEmpty
                              ? const AssetImage('assets/images/profile.png')
                              : NetworkImage(
                                      widget.selling!.user!.img.toString())
                                  as ImageProvider)),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.selling!.user!.name.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                Text(widget.selling!.user!.location.toString()),
                const SizedBox(height: 20),
                RatingBar(
                  glow: true,
                  itemSize: 50,
                  unratedColor: Colors.black45,
                  updateOnDrag: true,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                  glowColor: Colors.blue,
                  ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      half: const Icon(
                        Icons.star_half,
                        color: Colors.blue,
                      ),
                      empty: const Icon(
                        Icons.star_border,
                        color: Colors.blue,
                      )),
                  onRatingUpdate: (double value) {
                    starValue = value;
                    print('starValuew--->$starValue');

                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 15),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20)),
                      height: 170,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                            hintText:
                                'How was your experience about this seller?',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20)),
                      )),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
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
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          ratingService(context);
                        },
                        child: loading
                            ? CircularProgressIndicator(
                                color: AppTheme.appColor)
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppTheme.appColor),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 55.0, vertical: 8),
                                    child: Text(
                                      'Post Seller',
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
      ),
    );
  }

  bool loading = false;

  Future ratingService(BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        "user_id": '${widget.selling!.userId}',
        "review_quantity": '$starValue'
      };

      setState(() {
        loading = true;
      });

      var res = await customPostRequest.httpPostRequest(
          url: 'user-review', body: body);

      if (res != null) {
        showSnackBar(context, 'Review Added Successfully');
      } else {
        return false;
      }

      setState(() {
        loading = false;
      });
    } catch (err) {
      print(err);
      return false;
    }
  }
}
