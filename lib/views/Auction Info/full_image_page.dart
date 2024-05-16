import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullImagePage extends StatefulWidget {
  final dynamic detailResponse;

  FullImagePage({Key? key, required this.detailResponse}) : super(key: key);

  @override
  State<FullImagePage> createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  @override
  Widget build(BuildContext context) {
    var photos = widget.detailResponse["photo"] as List;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: photos.length == 1
            ? InteractiveViewer(
                // boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.5,
                maxScale: 4.0,
                panEnabled: true,
                trackpadScrollCausesScale: true,
                child: Image.network(
                  photos[0]["src"] as String,
                  fit: BoxFit.cover,
                ),
              )
            : CarouselSlider(
                items: photos.map<Widget>((photoUrl) {
                  return InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.5,
                    maxScale: 2.0,
                    panEnabled: true,
                    trackpadScrollCausesScale: true,
                    child: Image.network(
                      photoUrl["src"] as String,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  aspectRatio: 1,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                ),
              ),
      ),
    );
  }
}
