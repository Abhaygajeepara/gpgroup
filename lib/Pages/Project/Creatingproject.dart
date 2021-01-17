

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';

import 'package:gpgroup/Pages/Project/Workshop/Structure/CommercialArcade.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/HousingStructure.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/buildingstructure.dart';
import 'package:gpgroup/Pages/Project/RulesPreview.dart';
import 'package:gpgroup/Pages/Setting/SettingsScreens/Rules.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
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
  List<int> _selectedRulesIndex= List();
  List<String> _allrules= List();
  List<String> _selectedRules= List();
  bool errorrules = false;
  bool errorstructure =false;
  List<CreateHousingStrctureModel> _partslist= List(); // for house
  List<BuildingStructureModel> _buildingList = List(); // fro bulidings
  List<CommercialArcadeModel> _commercialModel= List();
  int selectedFormat ;
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
                        border: Border.all(color: errorrules? CommonAssets.errorColor:CommonAssets.boxBorderColors),

                      
                      ),
                      width: size.width,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               AppLocalizations.of(context).translate('Rules'),
                               style: TextStyle(
                                   fontSize: size.height *0.02,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                             Text(
                               _selectedRulesIndex.length.toString() ,
                               style: TextStyle(
                                   fontSize: size.height *0.02,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                           ],
                         ),
                          SizedBox(height:  size.height  *0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                             IconButton(



                                  icon: Icon(Icons.add,color: CommonAssets.iconBackGroundColor),
                                  onPressed: () async {
                                dynamic res = await Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (_,__,___)=>Rules(isshowAddRulesButton: false,selectdRulesindex: _selectedRulesIndex,),
                                    transitionDuration: Duration(seconds: 0)

                                ));
                            if(mounted) setState((){

                               if(res!= null){
                                 _selectedRulesIndex = res[0]; // selected rules for all rules
                                 _allrules = res[1];// all rules of project
                                    errorrules =false;
                                 _selectedRules.clear();
                                    for(int i =0;i<_selectedRulesIndex.length;i++){
                                      _selectedRules.add(_allrules[_selectedRulesIndex[i]]);
                                      print(_selectedRules);
                                    }
                                // print(_allrules);
                               }

                             });
                              }),

                              IconButton(


                                  icon: Icon(Icons.remove_red_eye_sharp, color: CommonAssets.iconBackGroundColor,),

                                  onPressed: () async {
                                    
                                    dynamic res = await Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (_,__,___)=>RulesPreview(rules: _allrules,rulesindex:_selectedRulesIndex ),
                                        transitionDuration: Duration(seconds: 0)

                                    ));
                                    if(mounted) setState((){

                                      if(res!= null){
                                        _selectedRulesIndex = res;
                                        errorrules = false;
                                        print(_selectedRulesIndex);
                                      }

                                    });
                                  }),
                              IconButton(

                                //color: Theme.of(context).primaryColor,
                                  icon: Icon(Icons.delete, color:CommonAssets.iconBackGroundColor),

                                  onPressed: () {
                                    setState(() {
                                      _selectedRulesIndex.clear();
                                    });
                                  }),

                            ],
                          ),
                          // Center(
                          //   child: RaisedButton.icon(
                          //       shape: StadiumBorder(),
                          //       color: Theme.of(context).primaryColor,
                          //       icon: Icon(Icons.remove_red_eye_sharp, color: CommonAssets.AppbarTextColor,),
                          //       label: Text(
                          //         'Delete Rules',
                          //         style:   TextStyle(
                          //             color: CommonAssets.AppbarTextColor,
                          //             fontSize: size.height *0.02
                          //         ),
                          //       ),
                          //       onPressed: () {
                          //        setState(() {
                          //          _selectedRulesIndex.clear();
                          //        });
                          //       }),
                          // ),




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
                          border: Border.all(color: errorstructure? CommonAssets.errorColor:CommonAssets.boxBorderColors)
                      ),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          GestureDetector(
                            onTap: ()async{
                            dynamic res =  await Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> HousingStructure(),
                                transitionDuration: Duration(milliseconds: 1),
                              ));
                            if(res != null)
                              {
                                if(mounted) setState(() {
                                  _partslist  = res;
                                  errorstructure = false;

                                });

                              }


                            },
                            child: CircleAvatar(
                              radius: size.height *0.04,
                              child: Icon(
                                  Icons.house,
                              color: CommonAssets.iconcolor,
                                size: size.height *0.05,
                              ),
                              backgroundColor: CommonAssets.iconBackGroundColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              dynamic res = await Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> BuildingStructure(),
                                transitionDuration: Duration(milliseconds: 0),
                              ));
                              print('return ');
                              if(mounted) setState(() {
                               if(res != null){
                                 _buildingList = res;
                                 print(_buildingList.length);
                               }
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
                          GestureDetector(
                            onTap: ()async{
                             dynamic res = await Navigator.push(context, PageRouteBuilder(
                                //    pageBuilder: (_,__,____) => BuildingStructure(),
                                pageBuilder: (_,__,___)=> CommercialArcade(),
                                transitionDuration: Duration(milliseconds: 0),
                              ));
                             if(mounted) setState(() {
                                if(res != null){
                                  _commercialModel = res;
                                  print(_commercialModel[0].shops);
                                }
                             });
                            },
                            child: CircleAvatar(
                              radius: size.height *0.04,
                              child: Icon(

                                Icons.storefront,
                                color: CommonAssets.iconcolor,
                                size: size.height *0.05,
                              ),
                              backgroundColor: CommonAssets.iconBackGroundColor,
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
                            if(_selectedRulesIndex.length <=0  ){
                                setState(() {
                                  errorrules = true;
                                });
                            }

                            else if(_partslist.length <=0  || _buildingList.length <=0|| _commercialModel.length <= 0 ){
                              print('change code');
                              // TODO Add diffrent format data ;

                              setState(() {
                                errorstructure = true;
                              });
                            }
                            else{
                            //  ProjectsDatabaseService().createHousingStructure(_partslist, projectname, _selectedRules);
                            //  ProjectsDatabaseService().createBuildingStructure(_buildingList, projectname, _selectedRules);
                               ProjectsDatabaseService().createCommercialStructure(_commercialModel, projectname, _selectedRules);
                            }

                        }
                      },
                        color: Theme.of(context).buttonColor,
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
