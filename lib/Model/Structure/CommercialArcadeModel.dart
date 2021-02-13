import 'package:flutter/cupertino.dart';

class CommercialArcadeModel{
  int totalFloor;
  //List<int> shops;
  int differentialValue;
  int staring;
  int shops;
  Map<String, dynamic> toMap() {
    return {
      'TotalFloor': totalFloor, // floor number
      'Length': shops,// length = number of shop
      'DifferentialValue':differentialValue,
      'Staring':staring
    };}
CommercialArcadeModel({@required this.totalFloor,@required this.shops, @required this.differentialValue, @required  this.staring});
}