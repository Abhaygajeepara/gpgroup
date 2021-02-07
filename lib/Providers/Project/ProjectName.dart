import 'package:flutter/cupertino.dart';

class ProjectNameProvider extends ChangeNotifier{
  String projectName;
  get Projectname => projectName;

  setProjectName(String projectNameVal){
    this.projectName = projectNameVal;
    notifyListeners();
  }
}