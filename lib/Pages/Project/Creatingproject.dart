

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';

import 'package:gpgroup/Pages/Project/Workshop/Structure/CommercialArcade.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/HousingStructure.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/HybridStructure.dart';
import 'package:gpgroup/Pages/Project/Workshop/Structure/buildingstructure.dart';
import 'package:gpgroup/Pages/Project/RulesPreview.dart';
import 'package:gpgroup/Pages/Setting/SettingsScreens/Rules.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/Service/Database/Rules.dart';
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
  List<String> _englishRules= List();
  List<String> _gujaratiRules= List();
  List<String> _hindiRules= List();
  bool isLoading = false;

  bool errorrules = false;
  bool errorstructure =false;
  List<CreateHousingStrctureModel> _partslist= List(); // for house
  List<BuildingStructureModel> _buildingList = List(); // fro bulidings
  List<CommercialArcadeModel> _commercialList= List();
  int selectedFormat ;
  int showStructure =0;
  @override
  Widget build(BuildContext context) {

    final size= MediaQuery.of(context).size;
    return  Scaffold(
      // Appbar
      appBar: CommonAppbar(Container()),
      body:isLoading ?CircularLoading() :StreamBuilder<RulesModel>(
        stream: CompanyRules().RULESDATA,
        builder: (context,rulesSnapshot){
          if(rulesSnapshot.hasData)
            {
              RulesModel data = rulesSnapshot.data;
              return SingleChildScrollView(
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
                                                _selectedRulesIndex = res; // selected rules for all rules

                                                errorrules =false;
                                                _englishRules.clear();
                                                _hindiRules.clear();
                                                _gujaratiRules.clear();
                                                for(int i =0;i<_selectedRulesIndex.length;i++){
                                                  _englishRules.add(data.english[_selectedRulesIndex[i]]);
                                                  _hindiRules.add(data.hindi[_selectedRulesIndex[i]]);
                                                  _gujaratiRules.add(data.gujarati[_selectedRulesIndex[i]]);

                                                }

                                              }


                                            });
                                          }),

                                      IconButton(


                                          icon: Icon(Icons.remove_red_eye_sharp, color: CommonAssets.iconBackGroundColor,),

                                          onPressed: () async {

                                            dynamic res = await Navigator.push(context, PageRouteBuilder(
                                                pageBuilder: (_,__,___)=>RulesPreview(english: _englishRules,gujarati: _gujaratiRules,hindi: _hindiRules, ),
                                                transitionDuration: Duration(seconds: 0)

                                            ));
                                            if(mounted) setState((){

                                              if(res!= null){
                                                _selectedRulesIndex = res;
                                                errorrules = false;

                                              }

                                            });
                                          }),
                                      IconButton(

                                        //color: Theme.of(context).primaryColor,
                                          icon: Icon(Icons.delete, color:CommonAssets.iconBackGroundColor),

                                          onPressed: () {
                                            setState(() {
                                              _selectedRulesIndex.clear();
                                              _englishRules.clear();
                                              _hindiRules.clear();
                                              _gujaratiRules.clear();

                                            });
                                          }),

                                    ],
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
                                  border: Border.all(color: errorstructure? CommonAssets.errorColor:CommonAssets.boxBorderColors)
                              ),
                              width: size.width,
                              child:showStructure == 0? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,

                                children: [
                                  // three button of Structure filed in ui
                                  HosingButton(size),
                                  BuildingButton(size),
                                  CommercialShopButton(size),
                                  hybridStructure(size),


                                ],
                              ):Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(showStructure == 1)
                                      HosingButton(size),
                                    if(showStructure == 2)
                                      BuildingButton(size),
                                    if(showStructure == 3)
                                      CommercialShopButton(size),
                                   
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: (){
                                        setState(() {
                                          showStructure = 0;
                                          _commercialList.clear();
                                          _partslist.clear();
                                          _buildingList.clear();
                                        });
                                      },
                                    )

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: size.height *0.02,),

                            Center(
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: size.height *0.02,horizontal: size.width *0.05),
                                shape: StadiumBorder(),
                                onPressed: ()async{
                                  if(_formkey.currentState.validate()){
                                    if(_selectedRulesIndex.length <=0  ){
                                      setState(() {
                                        errorrules = true;
                                      });
                                    }

                                    else if (showStructure == 0){
                                      if(_partslist.length <=0  || _buildingList.length <=0|| _commercialList.length <= 0 ){

                                        setState(() {
                                          errorstructure = true;
                                        });
                                      }
                                    }
                                    else{
                                      List<List<String>> rules =[_englishRules,_gujaratiRules,_hindiRules];
                                      setState(() {
                                      isLoading = true;
                                      });
                                      if(showStructure == 1){
                                      await  ProjectsDatabaseService().createHousingStructure(_partslist, projectname, rules);

                                      }
                                      else if(showStructure == 2)
                                      {
                                      await  ProjectsDatabaseService().createBuildingStructure(_buildingList, projectname, rules);
                                      }
                                      else if(showStructure == 3){

                                      await  ProjectsDatabaseService().createCommercialStructure(_commercialList, projectname, rules);
                                      }
                                      else{
                                      //  print("showStructure either 0  or ");
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });

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
              );
            }
          else{
            return CircularLoading();
          }
        },

      )
    );
  }
  Widget HosingButton(Size size){
    return GestureDetector(
      onTap: ()async{
        dynamic res =  await Navigator.push(context, PageRouteBuilder(
          //    pageBuilder: (_,__,____) => BuildingStructure(),
          pageBuilder: (_,__,___)=> HousingStructure(),
          transitionDuration: Duration(milliseconds: 1),
        ));

        if(mounted) setState(() {
          if(res != null)
          {
            _partslist  = res;
            errorstructure = false;
            showStructure = 1;
          }
          else{
            showStructure = 0;
          }

        });




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
    );
  }

  Widget BuildingButton(Size size){
    return GestureDetector(
      onTap: ()async{
        dynamic res = await Navigator.push(context, PageRouteBuilder(
          //    pageBuilder: (_,__,____) => BuildingStructure(),
          pageBuilder: (_,__,___)=> BuildingStructure(),
          transitionDuration: Duration(milliseconds: 0),
        ));
       // print('return ');
        if(mounted) setState(() {
          if(res != null){
            _buildingList = res;
          //  print(_buildingList.length);
            showStructure = 2;
            errorstructure = false;
          }
          else{
            showStructure = 0;
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
    );
  }
  Widget CommercialShopButton(Size size){
    return GestureDetector(
      onTap: ()async{
        dynamic res = await Navigator.push(context, PageRouteBuilder(
          //    pageBuilder: (_,__,____) => BuildingStructure(),
          pageBuilder: (_,__,___)=> CommercialArcade(),
          transitionDuration: Duration(milliseconds: 0),
        ));
        if(mounted) setState(() {
          if(res != null){
            _commercialList = res;
            // print(_commercialModel[0].shops);
            showStructure = 3;
            errorstructure = false;
          }
          else{
            showStructure = 0;
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
    );
  }

  Widget hybridStructure(Size size){
    return GestureDetector(
      onTap: ()async{
        dynamic res = await Navigator.push(context, PageRouteBuilder(
          //    pageBuilder: (_,__,____) => BuildingStructure(),
          pageBuilder: (_,__,___)=> HybridStrcture(),
          transitionDuration: Duration(milliseconds: 0),
        ));
        // if(mounted) setState(() {
        //   if(res != null){
        //     _commercialList = res;
        //     // print(_commercialModel[0].shops);
        //     showStructure = 3;
        //     errorstructure = false;
        //   }
        //   else{
        //     showStructure = 0;
        //   }
        // });

      },
      child: CircleAvatar(
        radius: size.height *0.04,
        child: Icon(
          
          Icons.business_sharp,
          color: CommonAssets.iconcolor,
          size: size.height *0.05,
        ),
        backgroundColor: CommonAssets.iconBackGroundColor,
      ),
    );
  }
}
