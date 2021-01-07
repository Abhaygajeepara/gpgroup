import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Widgets/Bottombar.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Setting/SettingsScreens/Rules.dart';
import 'package:gpgroup/Pages/Workshop/Structure/buildingstructure.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(AppLocalizations.of(context).translate('Profile')),

            ),
          ),
          Card(
            child: ListTile(
              onTap: (){
                return    Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Rules(),
                  transitionDuration: Duration(seconds: 0),
                ),);
                print('s');
              },
              leading: Icon(Icons.rule),
              title: Text(AppLocalizations.of(context).translate('Rules')),

            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text(AppLocalizations.of(context).translate('Language')),

            ),

          ),
          Card(
            child: ListTile(
              onTap: (){
                return LogInAndSignIn().signouts();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text(AppLocalizations.of(context).translate('LogOut')),

            ),

          ),
        ],
      ),
    );
  }
}
