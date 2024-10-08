import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:radish_app/input/category_input_screen.dart';
import 'package:radish_app/input/input_screen.dart';
import 'package:radish_app/screen/home_screen.dart';
import 'package:radish_app/screen/item/item_detail_screen.dart';
import 'package:radish_app/states/category_notifier.dart';
import 'package:radish_app/states/select_image_notifier.dart';

const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';


class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey(LOCATION_HOME))];
  }

  @override
  List get pathBlueprints => ['/'];
}

class InputLocation extends BeamLocation{
  @override
  Widget builder(BuildContext context, Widget navigator){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: categoryNotifier),
        ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
      ],
      child: super.builder(context, navigator)
    );
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathBlueprintSegments.contains(LOCATION_INPUT))
      BeamPage(
        child: InputScreen(), 
        key: ValueKey(LOCATION_INPUT)
      ),
      if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_INPUT))
      BeamPage(
        child: CategoryInputScreen(),
        key: ValueKey(LOCATION_CATEGORY_INPUT)  
      )
    ];
  }

  @override
  List get pathBlueprints => ['/$LOCATION_INPUT','/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT'];
}

class ItemLocation extends BeamLocation {

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathParameters.containsKey(LOCATION_ITEM_ID))
        BeamPage(
          child: ItemDetailScreen(state.pathParameters[LOCATION_ITEM_ID]??""),
          key: ValueKey(LOCATION_ITEM_ID)
          )
    ];
  }

  List get pathBlueprints =>['/$LOCATION_ITEM/:$LOCATION_ITEM_ID'];

}
