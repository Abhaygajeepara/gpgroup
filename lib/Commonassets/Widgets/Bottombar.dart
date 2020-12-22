import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Pages/Setting/Setting.dart';
import 'package:gpgroup/Pages/Workshop/Sites.dart';

import 'file:///E:/Work/Flutter/gpgroup/lib/Pages/Workshop/Structure/buildingstructure.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';

Widget CustomButtomBar(BuildContext context,int pageindex){
  return BottomNavigationBar(
    onTap: (val){
      if(val==0){
        return Navigator.pushReplacement(context,  PageRouteBuilder(
          pageBuilder: (_,__,____) => HomeScreen(),
          transitionDuration: Duration(milliseconds: 0),
        ));
      }
      else if(val==1){
        return Navigator.pushReplacement(context,  PageRouteBuilder(
          pageBuilder: (_,__,____) => Sites(),
          transitionDuration: Duration(milliseconds: 0),
        ));
      }
      else if(val==2){
        return Navigator.pushReplacement(context,  PageRouteBuilder(
          pageBuilder: (_,__,____) => SettingScreen(),
          transitionDuration: Duration(milliseconds: 0),
        ));
      }

      else{
        print('Set Navigator');/**/
      }
    },
    currentIndex: pageindex,
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