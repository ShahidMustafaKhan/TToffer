import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/models/selling_serach_model.dart';

class NewFeatureInfoScreen extends StatefulWidget {
  SearchData? searchData;

  NewFeatureInfoScreen({this.searchData});

  @override
  State<NewFeatureInfoScreen> createState() => _NewFeatureInfoScreenState();
}

class _NewFeatureInfoScreenState extends State<NewFeatureInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          widget.searchData!.photo![0].src.toString()),
                      fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }
}
