import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Widgets/Bottombar.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Workshop/Structure/buildingstructure.dart';
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppbar(),
        body:Container(
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),

                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.rule),
                  title: Text('Rules'),

                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),

                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:CustomButtomBar(context,2)
    );
  }
}
