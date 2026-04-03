import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';


class ProductAttributesWidget extends StatelessWidget {
  final String? categoryName;
  final String? subCategoryName;
  final List attributeKeyList;
  final List attributeValueList;
  final double? userRating;
  final bool isProperty;
  final int? loopLimit;
  final String? hireStatus;
  final String? propertyOwner;

  const ProductAttributesWidget({super.key, this.categoryName, this.subCategoryName, required this.attributeKeyList, required this.attributeValueList, this.userRating, this.isProperty=false, this.loopLimit, this.hireStatus, this.propertyOwner});


  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.only(top: 17.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          categoryName == 'Property for Rent' || categoryName == 'Vehicles' ||
              categoryName == 'Property for Sale' || categoryName == 'Jobs'
              ? Row(
            children: [
              Transform.translate(
                offset: const Offset(-6.0, 0), // Adjust this offset as needed to remove the padding
                child: Transform.scale(
                  scale: 1.0,
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    activeColor: AppTheme.appColor,
                    value: true,
                    onChanged: (v) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SizedBox(width: 0.w,),
              AppText.appText(
                categoryName == 'Jobs' ? hireStatus ?? '' : 'Sell by ${propertyOwner ?? ''}',
                fontSize: categoryName == 'Jobs' ? 15.sp : 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ) : const SizedBox.shrink(),


          if(categoryName == 'Property for Rent' || categoryName == 'Vehicles' ||
              categoryName == 'Property for Sale' || categoryName == 'Jobs')
            SizedBox(height: categoryName == 'Jobs' ? 11 : 14,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText(
                  "Details",
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  textColor: AppTheme.blackColor),

              Padding(
                padding: EdgeInsets.only(top: 13.0, left: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: AppText.appText(
                          "Subcategory ",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.textColor
                      ),
                    ),
                    Expanded(
                      child: AppText.appText(
                        subCategoryName ?? '-',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        textColor: AppTheme.blackColor,
                      ),
                    ),

                  ],
                ),
              ),


              Column(
                children: [
                  for (int i = 0; i <= loopLimit!; i++)
                    if(attributeValueList[i] != '' && attributeValueList[i] != '-' && attributeValueList[i] != null && attributeValueList[i].contains("null")==false)
                    Padding(
                      padding: EdgeInsets.only(top: 13.0, left: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: AppText.appText(
                                "${attributeKeyList[i]} ",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppTheme.textColor
                            ),
                          ),
                          if(i <= attributeValueList.length-1)
                          Expanded(
                            child: AppText.appText(
                              attributeValueList[i] == null ||attributeValueList[i] == 'null' || attributeValueList[i] == '' ? '-' : attributeValueList[i] ?? '-',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              textColor: AppTheme.blackColor,
                            ),
                          )
                          else
                            AppText.appText(
                              '-',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              textColor: AppTheme.blackColor,
                            ),
                    
                    
                        ],
                      ),
                    ),
                ],
              ),
            ],
          )


        ],
      ),
    );
  }
  
}
