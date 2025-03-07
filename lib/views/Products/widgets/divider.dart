import 'package:flutter/material.dart';

class AddDivider extends StatelessWidget {
  const AddDivider({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 1,
      width: screenWidth,
      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
    );
  }

}
