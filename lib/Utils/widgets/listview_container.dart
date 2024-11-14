import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/main.dart';

import '../../models/selling_products_model.dart';

class ListViewContainer extends StatefulWidget {
  const ListViewContainer({super.key, required this.selling});

  final Selling selling;

  @override
  State<ListViewContainer> createState() => _ListViewContainerState();
}

class _ListViewContainerState extends State<ListViewContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.selling.photo == null ||
                        widget.selling.photo!.isEmpty ||
                        widget.selling.photo![0].src == null
                        ? Image.asset('assets/images/gallery.png')
                        : Image.network(
                      widget.selling.photo![0].src!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(widget.selling.title ?? '',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppTheme.txt1B20),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        // width: widget.selling.status== 1 ? 165.w : 270.w,
                        child: AppText.appText(
                            widget.selling.location ?? "",
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.appColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const CustomDivider()
      ],
    );
  }
}
