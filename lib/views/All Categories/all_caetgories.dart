import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/views/All%20Categories/catagory_container.dart';
import '../../utils/utils.dart';
import 'sub_categories_screen.dart';

class AllCategories extends StatefulWidget {

  bool isList;

  AllCategories({super.key, required this.isList});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  handler() async {
    await BlockedUserServices().getBlockedUser(context: context);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handler();
  }

  @override
  Widget build(BuildContext context) {
    // final apiProvider = Provider.of<ProductsApiProvider>(context);
    final apiProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "All Categories",
      ),
      body: ListView.builder(
        // itemCount: widget.data.length,
        itemCount: apiProvider.category.length,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   mainAxisSpacing: 30,
        //   crossAxisSpacing: 20,
        //   crossAxisCount: 4,
        // ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Color color = Color(
          //     int.parse(widget.data[index]["color"].replaceFirst('#', '0xFF')));
          return InkWell(
              onTap: () {
                // push(
                //     context,
                //     CatagoryProductScreen(
                //       // catId: apiProvider.catagoryData[index]["id"],
                //       catNAme: "${apiProvider.category[index].title}",
                //     ));

                push(
                    context,
                    SubCategoriesScreen(
                      title: apiProvider.category[index].title,
                      id: apiProvider.category[index].id,
                    ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 4)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                      child: Text(
                        'Others',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  CatagoryContainer(
                    color: apiProvider.category[index].color,
                    img: apiProvider.category[index].image,
                    txt: apiProvider.category[index].title,
                    isList: widget.isList,
                  ),
                ],
              ));
        },
      ),
    );
  }
}
