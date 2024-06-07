import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/views/All%20Categories/catagory_container.dart';
import 'package:tt_offer/views/All%20Categories/category_products.dart';

import '../../utils/utils.dart';

class AllCategories extends StatefulWidget {
  final data;

  bool isList;

  AllCategories({super.key, this.data, required this.isList});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ProductsApiProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "All Categories",
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   mainAxisSpacing: 30,
        //   crossAxisSpacing: 20,
        //   crossAxisCount: 4,
        // ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Color color = Color(
              int.parse(widget.data[index]["color"].replaceFirst('#', '0xFF')));
          return InkWell(
            onTap: () {
              push(
                  context,
                  CatagoryProductScreen(
                    catId: apiProvider.catagoryData[index]["id"],
                    catNAme: "${apiProvider.catagoryData[index]["name"]}",
                  ));
            },
            child: CatagoryContainer(
              color: color,
              img: "${widget.data[index]["image"]}",
              txt: "${widget.data[index]["name"]}",
              isList: widget.isList,
            ),
          );
        },
      ),
    );
  }
}
