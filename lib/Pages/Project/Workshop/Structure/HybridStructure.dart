import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/HousingStructure.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/buildingstructure.dart';

class HybridStrcture extends StatefulWidget {
  @override
  _HybridStrctureState createState() => _HybridStrctureState();
}

class _HybridStrctureState extends State<HybridStrcture> {
  int pageindex =0;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('pageindex=' + pageindex.toString());
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body:getBody(size)
    );
  }
  Widget getBody(Size size){

      if (pageindex == 1){
          return HousingStructure();
    }
      else if(pageindex == 2){
        BuildingStructure();
      }
      else{
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  pageindex = 1;
                });
              },
              child: CircleAvatar(
                radius: size.height *0.04,
                child: Icon(

                  Icons.home,
                  color: CommonAssets.iconcolor,
                  size: size.height *0.05,
                ),
                backgroundColor: CommonAssets.iconBackGroundColor,
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  pageindex = 2;
                });
              },
              child: CircleAvatar(
                radius: size.height *0.04,
                child: Icon(

                  Icons.apartment,
                  color: CommonAssets.iconcolor,
                  size: size.height *0.05,
                ),
                backgroundColor: CommonAssets.iconBackGroundColor,
              ),
            ),
          ],
        ),
      );
    }


  }
}

