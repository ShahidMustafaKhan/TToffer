import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/All%20Categories/catagory_container.dart';

class AllCategories extends StatefulWidget {
  final data;
  const AllCategories({super.key, this.data});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Categories",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: widget.data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 30,
            crossAxisSpacing: 20,
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            Color color = Color(int.parse(
                widget.data[index]["color"].replaceFirst('#', '0xFF')));
            return CatagoryContainer(
              color: color,
              img: "${widget.data[index]["image"]}",
              txt: "${widget.data[index]["name"]}",
            );
          },
        ),
      ),
    );
  }
}
