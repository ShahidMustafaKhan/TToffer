import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import '../../../models/product_model.dart';
import '../../Utils/widgets/grid_delegate.dart';

class CatagoryProductScreen extends StatefulWidget {
  final catId;
  final String? catNAme;
  final String? subCatId;
  final bool all;

  const CatagoryProductScreen({super.key, this.catId, this.catNAme, this.all=false, this.subCatId});

  @override
  State<CatagoryProductScreen> createState() => _CatagoryProductScreenState();
}

class _CatagoryProductScreenState extends State<CatagoryProductScreen> {
  String selectedOption = 'Auction';
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool isLoading = false;
  late List<Product>? auctionList;
  late List<Product>? filteredList;

  late ProductViewModel productViewModel;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();

    if(widget.catNAme == "Animals" ||
        widget.catNAme == "Jobs" ||
        widget.catNAme == "Services"){
      selectedOption = 'Featured';
    }

    productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if(widget.all==true){
      auctionList = productViewModel.auctionProductList.data?.data?.productList
          ?.where((item) => item.category?.id.toString() == widget.catId.toString())
          .toList();

      filteredList = productViewModel.featureProductList.data?.data?.productList?.where((item) {
        return item.category?.id.toString() == widget.catId.toString();
      }).toList();
    }
    else {
      auctionList = productViewModel.auctionProductList.data?.data?.productList?.where((item) {
        return item.subCategory?.id.toString() == widget.subCatId.toString();
      }).toList();

      filteredList = productViewModel.featureProductList.data?.data?.productList?.where((item) {
        return item.subCategory?.id.toString() == widget.subCatId.toString();
      }).toList();
    }


    return Scaffold(
      appBar: CustomAppBar1(
        title: "${widget.catNAme}",
        leading: true,
      ),
      body: Consumer<ProductViewModel>(
          builder: (context, apiProvider, child) {
            return Column(
            children: [
              if(widget.catNAme != "Animals" &&
                  widget.catNAme != "Jobs" &&
                  widget.catNAme != "Services")
              selectOption(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (selectedOption == "Auction" )
                        apiProvider.auctionProductList.status == Status.loading
                            ? LoadingDialog()
                            : auctionList?.isEmpty ?? true  ? NoDataFound.noDataFound()
                            : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                                height: 300.h
                            ),
                            shrinkWrap: true,
                            itemCount: auctionList?.length,
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    push(context, AuctionInfoScreen(product: auctionList?[index],));
                                  },
                                  child: AuctionProductContainer(
                                    product: auctionList?[index],
                                  ));
                            },
                          ),
                        ),
                      if (selectedOption == "Featured")
                        apiProvider.featureProductList.status == Status.loading
                            ? LoadingDialog()
                            : filteredList?.isEmpty ?? true ? NoDataFound.noDataFound(spacer : widget.catNAme != "Animals" &&widget.catNAme != "Jobs" && widget.catNAme != "Services" ? null : 200.h)
                            : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                mainAxisSpacing: 15.h,
                                crossAxisSpacing: 12,
                                crossAxisCount: 2,
                                height: 245.h
                            ),
                            shrinkWrap: true,
                            itemCount: filteredList?.length ?? 0,
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    push(context, FeatureInfoScreen(product: filteredList?[index],));
                                  },
                                  child: FeatureProductContainer(
                                    product: filteredList?[index],
                                  ));
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              )
              
            ],
          );
        }
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20, right: 20),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.45) {
            setState(() {
              if (selectedOption != 'Auction') {
                productViewModel.getAuctionProducts();
              }
              selectedOption = 'Auction';
            });
          } else if (tapPosition < screenWidth * 0.9) {
            setState(() {
              if (selectedOption == 'Auction') {
                productViewModel.getFeatureProducts();
              }
              selectedOption = 'Featured';
            });
          }
        },
        child: Container(
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Auction'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Auction',
                    style: TextStyle(
                      color: selectedOption == 'Auction'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'Featured'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: selectedOption == 'Featured'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
