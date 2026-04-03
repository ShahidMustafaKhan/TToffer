import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/models/suggestion_model.dart';
import 'package:tt_offer/repository/suggestion_api/suggestion_repository.dart';

import '../../data/response/api_response.dart';
import '../product/product/product_viewmodel.dart';


class SuggestionViewModel with ChangeNotifier {

  SuggestionRepository suggestionRepository ;
  SuggestionViewModel({required this.suggestionRepository});


  bool _suggestionLoading = false ;
  bool get suggestionLoading => _suggestionLoading ;

  bool _blockApiCall = false ;
  bool get blockApiCall => _blockApiCall ;

  bool _hideSuggestions = false ;
  bool get hideSuggestions => _hideSuggestions ;

  String _searchText = '' ;
  String get searchText => _searchText ;

  Timer? debounce; // Timer to handle debounce
  String lastTypedValue = "";

  List<Map<String, String>> _suggestionList = [];
  List<Map<String, String>>  get suggestionList => _suggestionList ;


  ApiResponse<BidsModel> bidsList = ApiResponse.notStarted();

  TextEditingController searchEditingController = TextEditingController();

  setSearchText(String text){
    _searchText = text ;
    notifyListeners();
  }

  emptySearchText(){
    _searchText = '' ;
    notifyListeners();
  }

  setSuggestionLoading(bool value){
    _suggestionLoading = value ;
    notifyListeners();
  }

  setHideSuggestion(bool value){
    _hideSuggestions = value ;
    notifyListeners();
  }

  setSuggestionList(Map<String, String> value){
    _suggestionList.add(value) ;
    notifyListeners();
  }

  emptySuggestionList({bool notify = false}){
    _suggestionList=[];
    if(notify == true){
      notifyListeners();
    }
  }


  Future<List<Data>?> getSuggestion(String search) async {

    try {
      setSuggestionLoading(true);
      final response = await suggestionRepository.getSuggestionApi(search);
      setSuggestionLoading(false);
      return response.data;
    }catch(e){
      setSuggestionLoading(false);
      log("make offer api ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  searchSuggestion(String search, BuildContext context){
    // if(_blockApiCall == false) {
    //   _blockApiCall = true;
      getSuggestion(search).then((value){
       if(value?.isEmpty ?? true){
         emptySuggestionList(notify: true);
       }
       else{
         emptySuggestionList();
         value?.forEach((data) {
           if(data.name != null){
             Map<String, String> value= {
               'title' : data.name!,
             };
             setSuggestionList(value);
           }
         });
       }
      // _blockApiCall = false;
      }).onError((error, stackTrace){
        _blockApiCall = false;
    });
    // }
  }


  removeSearchScreen(BuildContext context){
    searchEditingController.text = '';
    if(suggestionList.isNotEmpty) {
      emptySuggestionList(notify: true);
    }
    if(searchText.isNotEmpty){
      emptySearchText();
    }
    Provider.of<ProductViewModel>(context, listen: false).resetSearchProducts();
  }






}