import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchPageLocation extends StatefulWidget {
  const SearchPageLocation({super.key});

  @override
  State<SearchPageLocation> createState() => _SearchPageLocationState();
}

class _SearchPageLocationState extends State<SearchPageLocation> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(

              textEditingController: controller,
              googleAPIKey: "AIzaSyBDcil7u2GKIEkezpxQay-DnCWpgve1m0s",
              inputDecoration: const InputDecoration(),


              getPlaceDetailWithLatLng: (Prediction prediction) {
                // this method will return latlng with place detail
                print("placeDetails${prediction.lng}");
              },
              // this callback is called when isLatLngRequired is true
              itemClick: (Prediction prediction) {
                controller.text = prediction.description!;
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length));
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(child: Text(prediction.description??""))
                    ],
                  ),
                );
              },
              // if we want to make custom list item builder

              // if you want to add seperator between list items
              seperatedBuilder: const Divider(),
              // want to show close icon
              isCrossBtnShown: true,
              // optional container padding
              containerHorizontalPadding: 10,
            )
          ],
        ),
      ),
    );
  }
}


