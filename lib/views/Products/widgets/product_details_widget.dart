import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../models/product_model.dart';


class ProductDetailsWidget extends StatefulWidget {
  final Product? product;


  const ProductDetailsWidget({super.key, this.product});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {

  int? _productViewsCount;

  @override
  void initState() {
    _productViewsCount = widget.product?.viewsCount;
    productViewCount();
    // TODO: implement initState
    super.initState();
  }


  productViewCount() async{
    final productApi = Provider.of<ProductViewModel>(context, listen: false);
   productApi.incrementProductViews(widget.product?.id, widget.product?.userId).then((value){
     _productViewsCount = value;
     if(mounted) {
       setState(() {});
     }
   });
  }



  @override
  Widget build(BuildContext context) {

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 0),
          child: AppText.appText(
              widget.product?.title ?? '',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              textColor: AppTheme.textColor),
        ),
        if(widget.product?.location != null)
        Padding(
          padding: const EdgeInsets.only(top: 9.0, bottom: 0),
          child: AppText.appText(getLocation(),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.textColor),
        ),
        Padding(
          padding: EdgeInsets.only(top: 9.0, bottom: (widget.product?.deliveryType?.isNotEmpty ?? false) ? 0 : 15),
          child: AppText.appText("${formatTimestamp(widget.product?.createdAt ?? '', full: true)}  ${_productViewsCount != null ? "·  ${_productViewsCount ?? 0} views" : '' }",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.textColor),
        ),
        if(widget.product?.deliveryType?.isNotEmpty ?? false)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 9.0, bottom: 15),
          itemCount: widget.product?.deliveryType?.length ?? 0, // your list length
          itemBuilder: (context, index) {
            String deliveryType = widget.product?.deliveryType?[index] ?? ''; // or the appropriate variable

            return Column(
              children: [
                if (shippingMethodIcon(deliveryType) != null)
                  Row(
                    children: [
                      Image.asset(
                        shippingMethodIcon(deliveryType)!,
                        height: 16.h,
                      ),
                      SizedBox(width: 8.w),
                      AppText.appText(
                        shippingMethodTitle(deliveryType) ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.textColor,
                      ),
                    ],
                  ),
              ],
            );
          }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 9,); },
        )




      ],
    );
  }

  String getLocation() {

    String location = widget.product?.location ?? '';

    return location;
  }
}
