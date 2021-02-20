import 'package:flutter/cupertino.dart';

class  BrokerModel{
  String id;
  String name;
  int number;
  String image;
  bool isActiveUser;
  String password;
  BrokerModel({
    @required this.id,
    @required this.name,
  @required this.number,
    @required  this.image,
    @required this.password,
    @required  this.isActiveUser});
}