import 'package:flutter/cupertino.dart';

class  ProjectNameList{
   String projectName;
  String address;
  String landmark;
  String description;
  String typeofBuilding;
  List<String> englishRules;
  List<String> gujaratiRules;
  List<String> hindiRules;
  List<String> reference;
  List<Map<String,dynamic>> Structure;
  List<String> imagesUrl;


  ProjectNameList({
    @required  this.projectName,
   @required  this.address,
    @required this.landmark,
    @required this.description,
    @required  this.typeofBuilding,
    @required  this.englishRules,
    @required this.gujaratiRules,
    @required this.hindiRules,
    @required this.reference,
    @required this.Structure,
    @required this.imagesUrl

  });
}