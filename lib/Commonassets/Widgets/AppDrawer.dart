
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Pages/Project/Broker/Broker.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            onTap: ()async{

              Navigator.pop(context);
              return   await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Broker(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.person),
                Text(AppLocalizations.of(context).translate('Broker'))
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
