import 'package:flutter/cupertino.dart';

class CustomRoute {
  Route createRoute(Widget page) { // Use createRoute to return a Route
    return PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      pageBuilder: (context, animation, secondaryAnimation) => page, // Pass the page to be displayed
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define your custom transition here
        // Example: Fade transition
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}