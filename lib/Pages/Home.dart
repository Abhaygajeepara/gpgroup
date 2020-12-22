import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Widgets/Bottombar.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'file:///E:/Work/Flutter/gpgroup/lib/Pages/Workshop/Structure/buildingstructure.dart';


import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('second_string'),
          ),
          Text(
            AppLocalizations.of(context).translate('Sites'),
          ),
          RaisedButton(
            onPressed: ()async{
              return LogInAndSignIn().signouts();
            },
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_,__,____) => BuildingStructure(),
            transitionDuration: Duration(milliseconds: 1),
          ));
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.business),
      ),
      bottomNavigationBar:CustomButtomBar(context)
    );
  }
}
