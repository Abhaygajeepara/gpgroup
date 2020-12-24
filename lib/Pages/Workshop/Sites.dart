import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Widgets/Bottombar.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Workshop/Structure/buildingstructure.dart';
class Sites extends StatefulWidget {
  @override
  _SitesState createState() => _SitesState();
}

class _SitesState extends State<Sites> {
  @override
  Widget build(BuildContext context) {
    return Text('Display Number Available Sites');
    // return Scaffold(
    //     appBar: CommonAppbar(),
    //     body: Text('Display Number Available Sites'),
    //
    //
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: (){
    //         Navigator.push(context, PageRouteBuilder(
    //           pageBuilder: (_,__,____) => BuildingStructure(),
    //           transitionDuration: Duration(milliseconds: 1),
    //         ));
    //       },
    //       backgroundColor: Colors.black,
    //       child: Icon(Icons.business),
    //     ),
    //     bottomNavigationBar:CustomButtomBar(context,1)
    // );
  }
  }

