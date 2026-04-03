
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import '../../../../Utils/resources/res/app_theme.dart';
import '../../../../data/response/status.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../Products/Auction Product/all_auction_procucts.dart';
import '../../../Products/Auction Product/auction_container.dart';
import '../../../Products/Auction Product/auction_info.dart';
import 'custom_product_row.dart';


class AuctionProductSection extends StatelessWidget {
  const AuctionProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
        return Column(
          children: [
            const ProductTypeDetails(
                txt1: "Auction Products",
                txt3: "Hurry up! The auction is ending soon."),
            const SizedBox(
              height: 15,
            ),


              productViewModel.auctionProductList.status == Status.loading
                  ? Center(
                child: AppText.appText("Loading...."),
              ):
              productViewModel.auctionProductList.status == Status.error
                  ? Center(
                child: AppText.appText("Error fetching products...."
                    // "${productViewModel.auctionProductList.message}"
                ),
              )
                : productViewModel.auctionProductList.data?.data?.productList?.isEmpty ?? false
                ? Center(
              child:
              AppText.appText("No Auction Product Added Yet"),
            )
                : SizedBox(
              height: 290.h,
              width: screenWidth,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
                scrollDirection: Axis.horizontal,
                itemCount:
                (productViewModel.auctionProductList.data?.data?.productList?.length ?? 0) > 4
                    ? 4
                    : productViewModel.auctionProductList.data?.data?.productList?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 14.w),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              push(context, AuctionInfoScreen(
                                  product: productViewModel.auctionProductList.data?.data?.productList?[index]),
                                  then: () {
                                    getData(productViewModel);
                                  });
                            },
                            child: AuctionProductContainer(
                              product: productViewModel.auctionProductList.data?.data?.productList?[index],
                            )),
                        if (index ==
                            (productViewModel.auctionProductList.data?.data?.productList?.length?? 0)  -
                                1)
                          const SizedBox(
                            width: 20,
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
           if(productViewModel.auctionProductList.data?.data?.productList?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      push(context, const ViewAllAuctionProducts(),
                          then: () {
                            getData(productViewModel);
                          });
                    },
                    child: AppText.appText("View All",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        textColor: AppTheme.textColor),
                  )
                ],
              ),
            )

          ],
        );
      }
    );
  }

  Future<void> getData(ProductViewModel productViewModel) async {

    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
  }


}


