import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/views/All%20Categories/all_caetgories.dart';

import '../../../../data/response/status.dart';
import '../../../../models/category_model.dart';
import '../../../../view_model/category/category_view_model.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../All Categories/catagory_container.dart';
import '../../../All Categories/sub_categories_screen.dart';
import 'custom_row.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
      return Consumer<CategoryViewModel>(
          builder: (context, categoryProvider, child) {
        return Column(
          children: [
            CustomRow(
                txt1: "Categories",
                txt2: "View All",
                txt3: "",
                onTap: () {
                  push(
                      context,
                      const AllCategoriesScreen(
                        isList: false,
                      ), then: () {
                    getData(productViewModel);
                  });
                }),
            SizedBox(
              height: 110.h,
              width: screenWidth,
              child: categoryProvider.categoryList.status == Status.loading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppTheme.yellowColor,
                    ))
                  : ListView.builder(
                      padding: EdgeInsets.only(right: 5.w),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          categoryProvider.categoryList.data?.isNotEmpty ??
                                  false
                              ? 6
                              : 0,
                      itemBuilder: (context, index) {
                        List<CategoryModel> categoryList =
                            categoryProvider.categoryList.data ?? [];

                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  push(
                                      context,
                                      SubCategoriesScreen(
                                        title: categoryList[index].title,
                                        id: categoryList[index].id,
                                      ), then: () {
                                    getData(productViewModel);
                                  });
                                },
                                child: CategoryContainer(
                                  color: categoryList[index].color,
                                  img: categoryList[index].image,
                                  txt: categoryList[index].title,
                                  isList: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      });
    });
  }

  Future<void> getData(ProductViewModel productViewModel) async {
    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
  }
}
