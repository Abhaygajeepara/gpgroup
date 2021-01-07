
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

// Widget CommonAppbarForHome(BuildContext context){
//   return AppBar(
//     title : Text(CommonAssets.apptitle,style: TextStyle(color: Colors.white),),
//     backgroundColor: CommonAssets.AppbarColor,
//
//   );
// }
Widget CommonAppbar(Widget appwidget){
  return AppBar(
    title : Text(CommonAssets.apptitle,style: TextStyle(color: Colors.white),),

    actions: [
      appwidget
    ],
  );
}