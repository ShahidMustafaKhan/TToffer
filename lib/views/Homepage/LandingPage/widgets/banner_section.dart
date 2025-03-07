
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/models/advertisement_banner.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../view_model/banner/banner_view_model.dart';
import '../../../../Utils/resources/res/app_theme.dart';
import '../../../../data/response/status.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../Products/Auction Product/all_auction_procucts.dart';
import '../../../Products/Auction Product/auction_container.dart';
import 'custom_row.dart';


class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return Consumer<BannerViewModel>(
        builder: (context, bannerViewModel, child) {
        return Column(
          children: [
            if(bannerViewModel.firstBanner.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 7.0,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                    const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: bannerViewModel.firstBanner.map((String imagePath) {
                    return Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: imagePath,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              height: 30.h,
                              child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                            ),
                          ),
                          errorWidget: (context, url, error) => SizedBox(),
                          cacheKey: imagePath, // Cache key to identify this image
                          fadeInDuration: Duration(milliseconds: 500), // Smooth fade-in effect
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if(bannerViewModel.firstBanner.isNotEmpty)
              const SizedBox(
                height: 15,
              ),
            if(bannerViewModel.secondBanner.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 7.0,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                    const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: bannerViewModel.secondBanner.map((AdvertisementBanner banner) {
                    return InkWell(
                      onTap: () async {
                        String? url = banner.redirect;

                        if(url != null){
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          } else {
                            showSnackBar(context, "Could not launch the URL");
                          }
                        }

                      },
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: banner.path ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                height: 30.h,
                                child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                              ),
                            ),
                            errorWidget: (context, url, error) => const SizedBox(),
                            cacheKey: banner.path ?? '', // Cache key to identify this image
                            fadeInDuration: const Duration(milliseconds: 500), // Smooth fade-in effect
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if(bannerViewModel.secondBanner.isNotEmpty)
              const SizedBox(
                height: 15,
              ),
            if(bannerViewModel.thirdBanner.isNotEmpty)...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 3,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                    const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: bannerViewModel.thirdBanner.map((AdvertisementBanner banner) {
                    return InkWell(
                      onTap: () async {
                        String? url = banner.redirect;

                        if(url != null){
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          } else {
                            showSnackBar(context, "Could not launch the URL");
                          }
                        }

                      },
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: banner.path ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                height: 30.h,
                                child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: SizedBox(
                                height: 30.h,
                                child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                              ),
                            ),
                            cacheKey: banner.path ?? '', // Cache key to identify this image// Specify disk cache size to optimize loading
                            fadeInDuration: const Duration(milliseconds: 500), // Smooth fade-in effect
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h,)
            ],

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


