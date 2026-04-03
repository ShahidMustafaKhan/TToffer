import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/view_model/category/category_view_model.dart';
import 'package:tt_offer/views/All%20Categories/catagory_container.dart';

import '../../utils/utils.dart';
import 'sub_categories_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  final bool isList;

  const AllCategoriesScreen({super.key, required this.isList});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "All Categories",
      ),
      body: ListView.builder(
        itemCount: apiProvider.categoryList.data?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          List<CategoryModel> categoryList =
              apiProvider.categoryList.data ?? [];
          return InkWell(
              onTap: () {
                push(
                    context,
                    SubCategoriesScreen(
                      title: categoryList[index].title,
                      id: categoryList[index].id,
                    ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 4)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        'Others',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  CategoryContainer(
                    color: categoryList[index].color,
                    img: categoryList[index].image,
                    txt: categoryList[index].title,
                    isList: widget.isList,
                  ),
                ],
              ));
        },
      ),
    );
  }
}
