import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../models/product_model.dart';
import '../../Profile Screen/profile_screen.dart';
import 'divider.dart';

class ProductReviewsSection extends StatelessWidget {
  final Product? product;
  const ProductReviewsSection({super.key, this.product});


  @override
  Widget build(BuildContext context) {
    if(product?.category?.name != 'Property for Rent' &&
        product?.category?.name != 'Property for Sale' && product?.category?.name != 'Jobs') {
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const AddDivider(),
          const AddDivider(),

          productRating(),

          const AddDivider(),

          SizedBox(height: 9.h,),

          // AppText.appText(
          //     "Item reviews",
          //     fontSize: 14.sp,
          //     fontWeight: FontWeight.w600,
          //     textColor: AppTheme.blackColor),


          if(product?.review?.isEmpty ?? true)...[
            SizedBox(height: 12.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.appText(
                    "No review added",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.blackColor),
              ],
            ),
            SizedBox(height: 25.h,),

          ]
          else...[
            for (int i = 0; i < (product?.review?.length ?? 0); i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 70.h,
                        width: 70.h,
                        decoration:  BoxDecoration(
                          image: DecorationImage(
                            image:
                                product?.review?[i].reviewer?.img != null
                                ? NetworkImage(product!.review![i].reviewer!.img!) as ImageProvider
                                :
                            const AssetImage(
                                'assets/images/default_image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?.review?[i].reviewer?.name ?? '' ,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 2.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                StarRating(
                                  percentage: percentageOfFive(product?.review?[i].rating),
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                AppText.appText("  ${getRating(product?.review?[i].rating.toString())}.0" ?? '',
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    textColor: const Color(0xff1E293B)),
                              ],
                            ),
                            SizedBox(height: 4.h,),
                            if(product?.review?[i].comment!=null)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 220.w,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final text = product?.review?[i].comment ?? '';

                                        // Create a TextPainter to determine the number of lines
                                        final textPainter = TextPainter(
                                          text: TextSpan(
                                            text: text,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              color: const Color(0xff000000),
                                              fontSize: 12, // Default font size
                                            ),
                                          ),
                                          maxLines: 5,
                                          textDirection: TextDirection.ltr,
                                        );

                                        // Perform layout to calculate size
                                        textPainter.layout(maxWidth: constraints.maxWidth);

                                        // Determine the number of lines
                                        final lineCount = textPainter.computeLineMetrics().length;

                                        // Set font size based on line count
                                        final fontSize = lineCount > 3 ? 9.0 : lineCount > 1 ? 10.5 : 12.0;

                                        return AutoSizeText(
                                          text,
                                          maxLines: 5,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xff000000),
                                            fontSize: fontSize,
                                          ),
                                          minFontSize: 8, // Ensure it doesn't go below 8 if multiline
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
          ]
        ],
      ),
    );
    } else {
      return const SizedBox();
    }
  }


  Widget productRating(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText.appText(product?.reviewPercentage?.toStringAsFixed(1) ?? '0.0',
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              textColor: const Color(0xff1E293B)),
          SizedBox(width: 5.w,),
          StarRating(
            percentage: percentageOfFive(product?.reviewPercentage ?? 0),
            color: Colors.yellow,
            size: 25,
          ),
          SizedBox(width: 3.w,),
          Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: AppText.appText("(${product?.review?.length ?? 0})" ?? '',
                fontSize: 10.sp,
                fontWeight: FontWeight.normal,
                textColor: const Color(0xff1E293B)),
          ),
        ],
      ),
    );
  }
}
