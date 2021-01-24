import 'package:flutter/cupertino.dart';

 class BuildingStructureNumberModel{
   String buildingName;
   List<BuildingStructureModel> floorsandflats;
   BuildingStructureNumberModel({this.buildingName,this.floorsandflats});

 }
class BuildingStructureModel{
  int floorNumber;
  List<int> flats;
  BuildingStructureModel({@required this.floorNumber,@required this.flats});

}
