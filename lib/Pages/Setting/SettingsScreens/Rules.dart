import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Pages/Setting/SettingsScreens/Rules/RulesLanguage/RulesLanguage.dart';
import 'package:gpgroup/Service/Rules/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

class Rules extends StatefulWidget {
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  final _pageContoller = PageController(initialPage: 0);
  final _fomrkey = GlobalKey<FormState>();
  String english;
  String gujarati;
  String hindi;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CommonAppbar(Container()
            //     PopupMenuButton(itemBuilder: (BuildContext contex){
            //   return {'Logout', 'Settings'}.map((String choice) {
            //     return PopupMenuItem<String>(
            //       value: choice,
            //       child: Text(choice),
            //     );
            //   }).toList();
            // })
            ),
        body: Column(
          children: [
            Expanded(
                child: Card(
              child: StreamBuilder<RulesModel>(
                  stream: CompanyRules().RULESDATA,
                builder: (context,snapshot){

                    if(snapshot.hasData)
                      {
                   return     PageView(
                          controller: _pageContoller,
                          children: [
                            RulesLanguage(rulesdata: snapshot.data.english,rulesModel: snapshot.data,),
                            RulesLanguage(rulesdata: snapshot.data.gujarati,rulesModel: snapshot.data,),
                            RulesLanguage(rulesdata: snapshot.data.hindi,rulesModel: snapshot.data,),
                          ],
                        );
                      }
                    else if(snapshot.hasError){

                      return Container(child: Center(child: Text(CommonAssets.snapshoterror)));
                    }
                    else{

                      return Container(child: Center(child: CircularLoading()));
                    }
                }
              )
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alerdialogbox(context);
                        });
                  },
                  child: Text(
                    'Add Rules',
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget alerdialogbox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _fomrkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate("Rules"),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.03),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ?  AppLocalizations.of(context).translate("EnterRuleInEnglish") : null,

                decoration:
                    commoninputdecoration.copyWith(labelText: 'English'),
                onChanged: (val) {
                  setState(() {
                    english = val.toString();
                  });
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ?  AppLocalizations.of(context).translate("EnterRuleInGujarati")  : null,
                decoration:
                    commoninputdecoration.copyWith(labelText: 'Gujarati'),
                onChanged: (val) {
                  setState(() {
                    gujarati = val.toString();
                  });
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ?   AppLocalizations.of(context).translate("EnterRuleInHindi") : null,
                decoration:
                    commoninputdecoration.copyWith(labelText: 'Hindi'),
                onChanged: (val) {
                  setState(() {
                    hindi = val.toString();
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
          shape: StadiumBorder(),
          color: Theme.of(context).primaryColor,
          onPressed: () async{
            if (_fomrkey.currentState.validate()) {
              dynamic result = await  CompanyRules().AddRules(english, gujarati, hindi);
              if(result == null)
                {
                return  Navigator.pop(context);
                }
              else{
                return print('sss');
              }
            }
          },
          child: Text(
            AppLocalizations.of(context).translate("AddRules"),
            style: TextStyle(color: CommonAssets.AppbarTextColor),
          ),
        )
      ],
    );
  }
}
