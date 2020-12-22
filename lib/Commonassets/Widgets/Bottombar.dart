import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///E:/Work/Flutter/gpgroup/lib/Pages/Workshop/Structure/buildingstructure.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';

Widget CustomButtomBar(BuildContext context){
  return BottomNavigationBar(
    onTap: (val){
      
      if(val==1){
        return Navigator.pushReplacement(context,  PageRouteBuilder(
          pageBuilder: (_,__,____) => BuildingStructure(),
          transitionDuration: Duration(milliseconds: 0),
        ));
      }
      else{
        print('Set Navigator');/**/
      }
    },
    currentIndex: 0,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: AppLocalizations.of(context).translate('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.construction),
        label:  AppLocalizations.of(context).translate('Sites'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label:  AppLocalizations.of(context).translate('Setting'),
      ),


    ],
  );
}