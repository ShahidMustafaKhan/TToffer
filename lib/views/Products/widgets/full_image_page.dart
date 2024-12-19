import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Utils/widgets/video_player.dart';
import '../../../models/product_model.dart';

class FullImagePage extends StatefulWidget {
  final Product? product;

  const FullImagePage({Key? key, required this.product}) : super(key: key);

  @override
  State<FullImagePage> createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  int _currentPage = 0;
  late CarouselController _carouselController;
  Product? product;


  @override
  void initState() {
    product = widget.product;
    _carouselController = CarouselController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Photo>? photos = product?.photo;;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: (photos?.length ?? 0) == 1
                  ? InteractiveViewer(
                      // boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.5,
                      maxScale: 4.0,
                      panEnabled: true,
                      trackpadScrollCausesScale: true,
                      child: (product?.photo?.isNotEmpty ?? false)
                          ? product!.photo![0].url!.endsWith('.mp4') ?
                      VideoPlayerWidget(videoPath: product!.photo![0].url!, networkVideo: true,):
                      Image.network(
                        product!.photo![0].url!,
                        fit: BoxFit.cover,
                      ) : const SizedBox(),
                    )
                  : Stack(
                children: [
                  CarouselSlider(
                    items: photos?.map<Widget>((photoUrl) {
                      return InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 2.0,
                        panEnabled: true,
                        trackpadScrollCausesScale: true,
                        child:
                        photoUrl.url!.endsWith('.mp4') ?
                        VideoPlayerWidget(videoPath: photoUrl.url!, networkVideo: true,):
                        Image.network(
                          photoUrl.url as String,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      aspectRatio: 1,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
                  if((photos?.length ?? 0) > 1 && _currentPage!=0)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 30.w,),
                      onPressed: () {
                        _carouselController.previousPage();
                      },
                    ),
                  ),
                  if((photos?.length ?? 0) > 1 && _currentPage!=((photos?.length ?? 0) - 1))
                    Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 30.w),
                      onPressed: () {
                        _carouselController.nextPage();
                      },
                    ),
                  ),

                ],
              ),
            ),
            if((photos?.length ?? 0) > 1)
            Positioned(
              bottom: 35.h,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentPage,
                  count: (photos?.length ?? 0),
                  effect: const ScrollingDotsEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
