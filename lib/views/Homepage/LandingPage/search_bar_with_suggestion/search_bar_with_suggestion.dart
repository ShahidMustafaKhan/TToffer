import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/resources/res/app_theme.dart';
import '../../../../Utils/widgets/others/app_field.dart';
import '../../../../data/response/api_response.dart';
import '../../../../providers/notification_provider.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../../view_model/suggestion/suggestion_view_model.dart';
import '../../../Notification/notification_screen.dart';


class SearchBarWithSuggestions extends StatelessWidget {

  SearchBarWithSuggestions({
    Key? key,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {

    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    return Consumer<SuggestionViewModel>(
        builder: (context, suggestionViewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Stack(
            children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 46, left: 4),
                  child: Column(
                    children: [
                      Consumer<SuggestionViewModel>(
                        builder: (context, suggestionViewModel, child) {
                          if (suggestionViewModel.suggestionList.isNotEmpty && suggestionViewModel.hideSuggestions == false && suggestionViewModel.searchEditingController.text.isNotEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: suggestionViewModel.suggestionList.length > 7
                                    ? 7
                                    : suggestionViewModel.suggestionList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.history),
                                    title: Text(
                                      suggestionViewModel.suggestionList[index]['title'] ?? '',
                                      style: const TextStyle(color: Colors.black, fontSize: 14.0),
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      suggestionViewModel.setHideSuggestion(true);
                                      suggestionViewModel.setSearchText(suggestionViewModel.suggestionList[index]['title'] ?? '');
                                      suggestionViewModel.emptySuggestionList(notify: true);
                                      await productViewModel.searchAllProducts(search: suggestionViewModel.searchText);
                                      suggestionViewModel.emptySuggestionList(notify: true);
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: CustomAppFormField(
                      onChanged: (value) {
                        suggestionViewModel.setHideSuggestion(false);
                        if (value.isEmpty) {
                          suggestionViewModel.setHideSuggestion(true);
                          suggestionViewModel.emptySuggestionList(notify: true);
                          Provider.of<ProductViewModel>(context, listen: false).setSearchProduct(ApiResponse.notStarted());
                        }
                        else if(value.length < 3){
                          suggestionViewModel.emptySuggestionList(notify: true);
                        }
                        else{
                          _onTextChanged(value,context,suggestionViewModel);
                        }
                      },
                      onFieldSubmitted: (value) async {
                        suggestionViewModel.setHideSuggestion(true);
                        if (value.isNotEmpty) {
                          if (suggestionViewModel.debounce?.isActive ?? false) {
                            suggestionViewModel.debounce!.cancel();
                          }
                          suggestionViewModel.emptySuggestionList(notify: true);
                          await productViewModel.searchAllProducts(search: value);
                          suggestionViewModel.emptySuggestionList(notify: true);
                        }
                      },
                      radius: 15.0,
                      prefixIcon: Container(
                        child: Image.asset(
                          "assets/images/search-normal.png",
                          color: AppTheme.textColor,

                        ),
                      ),
                      texthint: "What are you looking for?",
                    controller: suggestionViewModel.searchEditingController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Consumer<NotificationProvider>(
                    builder: (context, apiProvider, child) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationScreen(),
                                ),
                              );
                            },
                            child: Image.asset(
                              "assets/images/notification.png",
                              height: 26,
                            ),
                          ),
                          if (apiProvider.unreadNotificationIndicator == true)
                            Positioned(
                              top: -3,
                              right: -3,
                              child: Container(
                                height: 19, // Adjust the size as needed
                                width: 19, // Adjust the size as needed
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${apiProvider.unreadNotificationCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  void _onTextChanged(String value, BuildContext context, SuggestionViewModel suggestionViewModel) {
    // Cancel the previous debounce timer if still running
    if (suggestionViewModel.debounce?.isActive ?? false) {
      suggestionViewModel.debounce!.cancel();
    }

    // Start a new debounce timer
    suggestionViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
      if (value != suggestionViewModel.lastTypedValue) {
        debugPrint("User stopped typing. Final value: $value");
        suggestionViewModel.lastTypedValue = value;
        suggestionViewModel.setSearchText(suggestionViewModel.lastTypedValue);
        if (suggestionViewModel.lastTypedValue.isNotEmpty && suggestionViewModel.lastTypedValue.length >= 3) {
          suggestionViewModel.searchSuggestion(suggestionViewModel.lastTypedValue, context);
        }

      }
    });
  }

}
