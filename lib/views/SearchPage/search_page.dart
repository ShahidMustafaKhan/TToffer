import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/providers/search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: const CustomAppBar1(title: 'Search'),
        body: SafeArea(
            child: Column(
          children: [for (var l in data.selling) Text(l.title)],
        )),
      );
    });
  }
}
