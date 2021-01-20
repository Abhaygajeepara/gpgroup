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

  /*
  pageindex
  0 = mainscreen,
  1 = structure type
  3,4,5,6 = for  particular structure


     */
  final _formkey = GlobalKey<FormState>();

  int pageInedx = 0;
  String projectname;
  List<int> _selectedRulesIndex = List();
  bool isLoading = false;
  List<bool> _rulescheck;
  bool issrulescheck = false;
  bool errorrules = false;
  bool errorstructure = false;
  int selectedFormat;
  int showStructure = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        return   showDialog(
          context: context,
        builder: (context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('AreYouSure')),
            content: Text(
                'You Want Leave This Page'),
            actions: [
              FlatButton(onPressed: (){

                 Navigator.pop(context);
              }, child: Text(
                  AppLocalizations.of(context).translate('Cancel'),
                style: TextStyle(
                  color: Theme.of(context).errorColor
                ),
              )),
              FlatButton(onPressed: (){
                Navigator.pop(context);
               return Navigator.pop(context);
              }, child: Text('Yes',
                style: TextStyle(
                    color: Theme.of(context).primaryColor
                ),),
              ),

            ],
          );
        }
        );
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            pageInedx != 0
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: () {
                        setState(() {
                          if(pageInedx == 3 ||pageInedx == 4 || pageInedx == 5 ||pageInedx == 6){
                            setState(() {
                              pageInedx = 1;
                            });
                          }
                      else  if (pageInedx > 0)
                      {
                          setState(() {
                            pageInedx = pageInedx - 1;
                          });
                          }
                        });
                      },
                      child: Icon(
                        Icons.navigate_before_outlined,
                        color: CommonAssets.AppbarTextColor,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: () {
                  if(pageInedx == 0){
                    if(_formkey.currentState.validate()){
                      setState(() {
                        pageInedx = pageInedx + 1;
                      });
                    }
                  }
                },
                child: Icon(
                  Icons.navigate_next_outlined,
                  color: CommonAssets.AppbarTextColor,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        appBar: CommonAppbar(Container()),
        body: isLoading
            ? CircularLoading()
            : Padding(
              padding:  EdgeInsets.symmetric(horizontal: size.width *0.01,vertical: size.height *0.01),
              child: StreamBuilder<RulesModel>(
                  stream: CompanyRules().RULESDATA,
                  builder: (context, rulesSnapshot) {
                    if (rulesSnapshot.hasData) {
                      if (issrulescheck == false) {
                        _rulescheck = List<bool>.filled(
                            rulesSnapshot.data.english.length, false);
                      }
                      RulesModel data = rulesSnapshot.data;
                      return getbody(data);
                    } else {
                      return CircularLoading();
                    }
                  },
                ),
            ),
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.transparent,
        //   child: Text('bottom screen widget'),
        //   elevation: 0,
        // ),
      ),
    );
  }

  Widget getbody(RulesModel _rulesModelGet) {
    final size = MediaQuery.of(context).size;
    if (pageInedx == 0) {
      return mainScreen(_rulesModelGet);
    } else if (pageInedx == 1) {
      return structureType(size);
    } else {
      return Center(child: Container(child: Text('Page index ${pageInedx}')));
    }
  }

  Widget mainScreen(RulesModel _rulesmodel_main) {
    final size = MediaQuery.of(context).size;
    PageController _pageController = PageController(initialPage: 0);
    return Column(
      children: [
        Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: projectname ==  null?'': projectname.toString(),
                onChanged: (val) => projectname = val,
                validator: (val) =>
                    val.isEmpty ? "Enter The Project Name" : null,
                decoration: commoninputdecoration.copyWith(
                    labelText:
                        AppLocalizations.of(context).translate('ProjectName')),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          thickness: 2,
        ),
        Expanded(
            child: PageView(
          controller: _pageController,
          children: [
            rulesWidget(_rulesmodel_main.english),
            rulesWidget(_rulesmodel_main.gujarati),
            rulesWidget(_rulesmodel_main.hindi),

          ],
        ))
      ],
    );
  }

  Widget rulesWidget(List<String> _rules) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: _rules.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            activeColor: Theme.of(context).primaryColor,
            value: _rulescheck[index],
            onChanged: (val) {
              setState(() {
                if (issrulescheck == false) {
                  issrulescheck = true;
                }
                _rulescheck[index] = val;
                if (val) {
                  _selectedRulesIndex.add(index);

                } else {
                  _selectedRulesIndex.remove(index);

                }
                print("Selected rules ${_selectedRulesIndex}");
              });
            },
            title: Text(
              _rules[index].toString(),
              style: TextStyle(fontSize: size.height * 0.02),
            ),
          );
        });
  }
  Widget structureType(Size size){
    List<Map> _typeofsttuctur = [
      {
        'type':AppLocalizations.of(context).translate("Houses"),
        'detail':AppLocalizations.of(context).translate("Houses"),
        'image':'assets/house.jpg',
      },
      {
        'type':AppLocalizations.of(context).translate("Apartments"),
        'detail':AppLocalizations.of(context).translate("Apartments"),
      'image':'assets/apartment.png',
      },
      {
        'type':AppLocalizations.of(context).translate("CommercialBuilding"),
        'detail':AppLocalizations.of(context).translate("CommercialBuilding"),
      'image':'assets/Commercial.jpg',
      },
      {
        'type':AppLocalizations.of(context).translate("MixedUse"),
        'detail':AppLocalizations.of(context).translate("MixedUse"),
        'image':'assets/mixed-use.png',
      }

    ];
    return ListView.builder(
      itemCount: _typeofsttuctur.length,
      itemBuilder: (context,index){
        return Container(
          height: size.height *0.2,

          child: GestureDetector(
            onTap: () {
              setState(() {
                pageInedx =  2+index;
              });
            },
            child: Card(
            child:
            index.isEven?
            Row(
              children: [
                Image.asset(
                  _typeofsttuctur[index]['image'],
                  width: size.width *0.35,
                  fit: BoxFit.fitWidth,
                ),
                VerticalDivider(
                  color:Theme.of(context).primaryColor,
                ),
                Expanded(child: Text(_typeofsttuctur[index]['detail'])),
              ],
            ):Row(
              children: [

                Expanded(child: Text(_typeofsttuctur[index]['detail'])),
                VerticalDivider(
                  color:Theme.of(context).primaryColor,
                ),
                Image.asset(
                  _typeofsttuctur[index]['image'],
                  width: size.width *0.35,
                  fit: BoxFit.fitWidth,
                ),


              ],
            ),
            ),
          ),
        );
      },
    );
  }
}
