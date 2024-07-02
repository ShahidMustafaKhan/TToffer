import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/views/All%20Categories/category_products.dart';

class SubCategoriesScreen extends StatefulWidget {
  final String? title;
  final int? id;

  SubCategoriesScreen({super.key, this.title, this.id});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  List<SubCategoriesModel> filteredSubCategories = [];

  subCategoriesHandler() async {
    await SubCategoriesService().subCategoriesService(context: context);
    final provider = Provider.of<SubCategoriesProvider>(context, listen: false)
        .subCategories;
    filteredSubCategories =
        provider.where((subCategory) => subCategory.id == widget.id).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    subCategoriesHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: widget.title!,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText.appText('See all in ${widget.title}',
                      textColor: const Color(0xff1B63D8), fontSize: 16),
                ),
                for (int i = 0; i < filteredSubCategories.length; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          push(
                              context,
                              CatagoryProductScreen(
                                catId: filteredSubCategories[i].id,
                                catNAme: filteredSubCategories[i].title,
                              ));
                        },
                        child: AppText.appText(
                            filteredSubCategories[i].title.toString(),
                            fontSize: 16),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
