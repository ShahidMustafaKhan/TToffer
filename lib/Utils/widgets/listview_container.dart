import 'dart:io';

import 'package:flutter/material.dart';
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                        child: widget.selling.photo != null
                            ? Image.file(File(
                                Provider.of<ImageNotifyProvider>(context)
                                    .newImagePath
                                    .toString()))
                            : Image.network(
                                widget.selling.photo != null &&
                                        widget.selling.photo!.isNotEmpty
                                    ? widget.selling.photo![0].src.toString()
                                    : '',
                                // Provide a default value or handle the case where photo is empty
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.appText(widget.selling.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: AppTheme.txt1B20),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText(
                                getItemStatus(widget.selling.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.appColor),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 10,
                              width: 1,
                              color: const Color(0xffEAEAEA),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppText.appText(
                                  widget.selling.location ?? "",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppTheme.appColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
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
