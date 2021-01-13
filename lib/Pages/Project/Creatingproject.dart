import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';

import 'package:gpgroup/Pages/Project/Workshop/Structure/CommercialArcade.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/HousingStructure.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/buildingstructure.dart';
import 'package:gpgroup/Pages/Project/showrules.dart';
import 'package:gpgroup/Pages/Setting/SettingsScreens/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

class CreatingProject extends StatefulWidget {
  CreatingProject() : super();

  final String title = "Stepper Demo";

  @override
  CreatingProjectState createState() => CreatingProjectState();
}

class CreatingProjectState extends State<CreatingProject> {
  final _formkey = GlobalKey<FormState>();
  String projectname;
  List<String> _rules= List();
 
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      // Appbar
      appBar: CommonAppbar(Container()),
      body:SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width *0.01),
          child: Column(

            children: [
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(

                      onChanged: (val)=> projectname  = val,
                      validator: (val)=> val.isEmpty ? "Enter The Project Name":null,
                      decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('ProjectName')),
                    ),
                    SizedBox(height: size.height *0.01,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width *0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      width: size.width,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('Rules'),
                            style: TextStyle(
                                fontSize: size.height *0.02,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height:  size.height  *0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // Text(
                              // AppLocalizations.of(context).translate('Rules'),
                              //
                              // style: TextStyle(
                              //   fontSize: size.height* 0.02,
                              //   fontWeight: FontWeight.w700
                              // ),),
                              RaisedButton.icon(
                              shape: StadiumBorder(),
                                color: Theme.of(context).primaryColor,
                                  label: Text(
                                    AppLocalizations.of(context).translate('AddRules'),
                                    style:   TextStyle(
                                      color: CommonAssets.AppbarTextColor,
                                      fontSize: size.height *0.02
                                  ), ),
                                  icon: Icon(Icons.add,color: CommonAssets.AppbarTextColor,),
                                  onPressed: () async {
                                dynamic res = await Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (_,__,___)=>Rules(isshowAddRulesButton: false,),
                                    transitionDuration: Duration(seconds: 0)

                                ));
                            if(mounted) setState((){

                               if(res!= null){
                                 _rules = res;
                                 print(_rules);
                               }

                             });
                              }),
                              RaisedButton.icon(
                                  shape: StadiumBorder(),
                                  color: Theme.of(context).primaryColor,
                                  icon: Icon(Icons.remove_red_eye_sharp, color: CommonAssets.AppbarTextColor,),
                                  label: Text(
                                    'Preview',
                                    style:   TextStyle(
                                        color: CommonAssets.AppbarTextColor,
                                        fontSize: size.height *0.02
                                    ),
                                  ),
                                  onPressed: () async {
                                    dynamic res = await Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (_,__,___)=>PreviewRules(rules: _rules,),
                                        transitionDuration: Duration(seconds: 0)

                                    ));
                                    if(mounted) setState((){

                                      if(res!= null){
                                        _rules = res;
                                        print(_rules);
                                      }

                                    });
                                  }),

                            ],
                          ),
                          Center(
                            child: RaisedButton.icon(
                                shape: StadiumBorder(),
                                color: Theme.of(context).primaryColor,
                                icon: Icon(Icons.remove_red_eye_sharp, color: CommonAssets.AppbarTextColor,),
                                label: Text(
                                  'Delete Rules',
                                  style:   TextStyle(
                                      color: CommonAssets.AppbarTextColor,
                                      fontSize: size.height *0.02
                                  ),
                                ),
                                onPressed: () {
                                  _rules.clear();
                                }),
                          ),




                        ],
                      ),

                    ),
                    SizedBox(height: size.height* 0.01,),
                    Text(
                        AppLocalizations.of(context).translate('Structure'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height *0.03
                      ),
                    ),
                    Container(

                      padding: EdgeInsets.symmetric(vertical: size.height *0.02,horizontal: size.width *0.01),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> HousingStructure(),
                                transitionDuration: Duration(milliseconds: 1),
                              ));
                            },
                            child: CircleAvatar(
                              radius: size.height *0.04,
                              child: Icon(
                                  Icons.house,
                              color: CommonAssets.AppbarTextColor,
                                size: size.height *0.05,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> BuildingStructure(),
                                transitionDuration: Duration(milliseconds: 1),
                              ));
                            },
                            child: CircleAvatar(
                              radius: size.height *0.04,
                              child: Icon(

                                Icons.apartment,
                                color: CommonAssets.AppbarTextColor,
                                size: size.height *0.05,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> CommercialArcade(),
                                transitionDuration: Duration(milliseconds: 1),
                              ));
                            },
                            child: CircleAvatar(
                              radius: size.height *0.04,
                              child: Icon(

                                Icons.storefront,
                                color: CommonAssets.AppbarTextColor,
                                size: size.height *0.05,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height *0.02,),
                    Center(
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: size.height *0.02,horizontal: size.width *0.05),
                          shape: StadiumBorder(),
                          onPressed: (){
                        if(_formkey.currentState.validate()){

                        }
                      },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            AppLocalizations.of(context).translate('AddProject'),
                          style: TextStyle(
                            color: CommonAssets.AppbarTextColor,
                            fontSize: size.height *0.02
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
