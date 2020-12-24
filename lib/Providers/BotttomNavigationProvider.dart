import 'package:flutter/material.dart';
class BottomNavigationProvider extends ChangeNotifier{
  int _currentTab  = 0;

   get CurrentTab => _currentTab;

   void setTab({int val}){
     this._currentTab = val;
     print(val);
     notifyListeners();
   }

}