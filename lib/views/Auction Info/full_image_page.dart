import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullImagePage extends StatefulWidget {
  var detailResponse;

  FullImagePage({this.detailResponse});

  @override
  State<FullImagePage> createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CarouselSlider(
          items:
              (widget.detailResponse["photo"] as List).map<Widget>((photoUrl) {
            return InteractiveViewer(
                boundaryMargin: EdgeInsets.all(20.0), // Add margin around the image
                minScale: 0.5, // Minimum scale (half size of the original)
                maxScale: 2.0, // Maximum scale (double the size of the original)
                panEnabled: true,
                trackpadScrollCausesScale: true,
                child: Image.network(photoUrl["src"] as String,
                    fit: BoxFit.cover));
          }).toList(),
          options: CarouselOptions(
            // Configure carousel options as needed
            aspectRatio: 1, // Example aspect ratio
            viewportFraction: 1,
            enableInfiniteScroll: true,
            autoPlay: false,
          ),
        ),
      ),
    );
  }
}
