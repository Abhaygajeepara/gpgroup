import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Widgets/Bottombar.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Workshop/Structure/buildingstructure.dart';
import 'package:gpgroup/Providers/BotttomNavigationProvider.dart';



import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

import '../Wrapper.dart';
import 'Setting/Setting.dart';
import 'Workshop/Sites.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final bottomTab = Provider.of<BottomNavigationProvider>(context).CurrentTab;
    print(bottomTab.toString());
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: HomeBody(bottomTab: bottomTab,),
      floatingActionButton: bottomTab == 1 ? FloatingActionButton(
        onPressed: (){
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_,__,____) => BuildingStructure(),
            transitionDuration: Duration(milliseconds: 1),
          ));
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.business),
      ) : Container(),
        // floatingActionButton: bottomTab == 1 ? FloatingActionButton(
        //       onPressed: (){
        //         Navigator.push(context, PageRouteBuilder(
        //           pageBuilder: (_,__,____) => BuildingStructure(),
        //           transitionDuration: Duration(milliseconds: 1),
        //         ));
        //       },
        //       backgroundColor: Colors.black,
        //       child: Icon(Icons.business),
        //     ) : Container(),
        bottomNavigationBar:CustomButtomBar(context,bottomTab,Provider.of<BottomNavigationProvider>(context,listen: false)),
    );
  }
}

class HomeBody extends StatelessWidget {
  int bottomTab;

  HomeBody({this.bottomTab});
  @override
  Widget build(BuildContext context) {
    switch(bottomTab){
      case 0 : {
        return  Column(
          children: [
            Text(
              AppLocalizations.of(context).translate('second_string'),
            ),
            Text(
              AppLocalizations.of(context).translate('Sites'),
            ),
            RaisedButton(
              onPressed: ()async{

                LogInAndSignIn().signouts();

              },
            ),
          ],
        );

      }
      case 1:
        return Sites();
      case 2:
        return SettingScreen();
    }
    return Container();
  }
}

