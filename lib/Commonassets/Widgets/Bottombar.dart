import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Pages/Setting/Setting.dart';
import 'package:gpgroup/Pages/Workshop/Sites.dart';
import 'package:gpgroup/Providers/BotttomNavigationProvider.dart';


import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

Widget CustomButtomBar(BuildContext context,int pageindex,BottomNavigationProvider provider){
  return BottomNavigationBar(
    onTap: (val){
    provider.setTab(val: val);
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