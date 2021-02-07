
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';

import 'package:gpgroup/Model/Structure/HousingModel.dart';



import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/Service/Database/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatingProject extends StatefulWidget {
  CreatingProject() : super();

  final String title = "Stepper Demo";

  @override
  CreatingProjectState createState() => CreatingProjectState();
}

class CreatingProjectState extends State<CreatingProject> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  /*
  pageindex
  0 = mainscreen,
  1 = structure type
  3,4,5,6 = for  particular structure


     */

  final _formkey = GlobalKey<FormState>();
  final _houseFormkey = GlobalKey<FormState>();

  File _image;
  List<File> _imagefilelist = List();
  int showimageindex = -1;

  int pageIndex = 0;
  String projectname;
  String projectnNameError;
  String landmark;
  String address;
  String description;

  List<int> _selectedRulesIndex = List();
  bool isLoading = false;
  List<bool> _rulescheck;
  bool issrulescheck = false;
  bool errorrules = false;
  bool errorstructure = false;
  int selectedFormat;
  int showStructure = 0;
  List<String> _englishRules= List();
  List<String> _gujaratiRules= List();
  List<String> _hindiRules= List();

  // housing structures
  String part ;
  int house = 0;
  int selected_part ;
  int staringnumber = 1;
  int number = 0;
  List<String> _localpart = List();

  List<CreateHousingStrctureModel> _houseStructuure= List();


  // apartment variable
  final _apartmentformkey = GlobalKey<FormState>();
  final _apartmentformkey0 = GlobalKey<FormState>();

  String apartmentname;

  int floors = 0;
  int flats = 2;
  List<String> _buildingList=[];
  List<BuildingStructureNumberModel> _buildingModel = List();
  // commercial structure
  int commericalfloors = 0;
  int commericalShop_per_floor = 0;
  int commericalSelectdfloor ;
  int commericalStaringnumber = 1;
  int commericalDifferentialvalue = 1000;
  int commericalNumber = 0;
  List<CommercialArcadeModel> _commercialModel = List();
  // mixed-use

  int mixupCommericalfloors = 0;
  int mixupCommericalShop_per_floor = 0;
  int mixupCommericalSelectdfloor ;
  int mixupCommericalStaringnumber = 1;
  int mixupCommericalDifferentialvalue = 1000;
  int mixupCommericalNumber = 0;

  List<CommercialArcadeModel> _mixupcommercialModel = List();
  final _MixuseApartmentformkey = GlobalKey<FormState>();
  final _mixeduseApartmentformkey0 = GlobalKey<FormState>();
  // int nu =15;
  String mixeduseApartmentname;
  int mixuseFloors = 0;
  int mixuseFlats = 2;
  List<String> _mixedusedbuildingList=[];
  int selectedBuilldingindex =0;
  List<BuildingStructureNumberModel> _mixusebuildingModel = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  getimage(ImageSource source) async {
    PickedFile pickfile = await ImagePicker().getImage(source: source);
    setState(() {
      showimageindex = -1;
      _image = File(pickfile.path);
      _imagefilelist.add(_image);
    });

  }
  getModel(int _floor,int _flats){
    //print(_floor);

    _buildingModel.clear();
    for(int i = 0;i<_buildingList.length;i++){
      List<BuildingStructureModel> _floorlist =List();
      int staring = 100;
      for(int j= 0;j<_floor;j++){


        List<int> _flatsList =List();
        for(int k =0;k<flats;k++){

          _flatsList.add(staring + k+1);

        }

        _floorlist.add(BuildingStructureModel(floorNumber: j+1, flats: _flatsList));
        staring = staring +100;

      }

      _buildingModel.add(BuildingStructureNumberModel(buildingName: _buildingList[i],floorsandflats: _floorlist));

    }

    for(int i = 0;i<_buildingList.length;i++){
      print(_buildingModel[i].buildingName);
      for(int j= 0;j<_floor;j++){
        print(_buildingModel[i].floorsandflats[j].flats);


      }
    }
  }
  void allocationnumber(){
    if(commericalSelectdfloor != null){
      commericalNumber = (commericalSelectdfloor * commericalDifferentialvalue) +commericalStaringnumber;
    }
  }
  commericalGetModel(){


    _commercialModel.clear();
    for(int i  =0;i<commericalfloors;i++){
      int staring = (i * commericalDifferentialvalue) +commericalStaringnumber;
      List<int> _flatsList =List();
      for(int j =0;j<commericalShop_per_floor;j++){

        _flatsList.add(staring + j);


      }

      _commercialModel.add(CommercialArcadeModel(floorNumber: i, shops:  _flatsList));
      staring = staring +100;
      // print(_commercialModel[i].floorNumber);
      // print(_commercialModel[i].shops);
    }

  }
  void mixupAllocationnumber(){
    if(mixupCommericalSelectdfloor != null){
      mixupCommericalNumber = (mixupCommericalSelectdfloor * mixupCommericalDifferentialvalue) +mixupCommericalStaringnumber;
    }
  }
  mixupCommericalGetModel(){


    _mixupcommercialModel.clear();
    for(int i  =0;i<mixupCommericalfloors;i++){
      int staring = (i * mixupCommericalDifferentialvalue) +mixupCommericalStaringnumber;
      List<int> _flatsList =List();
      for(int j =0;j<mixupCommericalShop_per_floor;j++){

        _flatsList.add(staring + j);


      }

      _mixupcommercialModel.add(CommercialArcadeModel(floorNumber: i, shops:  _flatsList));
      staring = staring +100;

    }

  }
  MixuseGetModel(int _floor,int _flats){


    _mixusebuildingModel.clear();
    for(int i = 0;i<_mixedusedbuildingList.length;i++){
      List<BuildingStructureModel> _floorlist =List();
      int staring = 100;
      for(int j= 0;j<_floor;j++){


        List<int> _flatsList =List();
        for(int k =0;k<_flats;k++){

          _flatsList.add(staring + k+1);

        }

        _floorlist.add(BuildingStructureModel(floorNumber: j+1, flats: _flatsList));
        staring = staring +100;

      }

      _mixusebuildingModel.add(BuildingStructureNumberModel(buildingName: _mixedusedbuildingList[i],floorsandflats: _floorlist));

    }

    for(int i = 0;i<_mixusebuildingModel.length;i++){
      print(_mixusebuildingModel[i].buildingName);
      for(int j= 0;j<_floor;j++){
        print(_mixusebuildingModel[i].floorsandflats[j].flats);


      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String projectName ="Abhay";
    // String ProjectNameUpper =  projectName.substring(0,1).toUpperCase() + projectName.substring(1);
    // print(ProjectNameUpper);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        return   showDialog(
          context: context,
        builder: (context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('AreYouSure')),
            content: Text(

            AppLocalizations.of(context).translate('YouWantLeaveThisPage')
            ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pageIndex != 0
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: () {
                        setState(() {
                          if (pageIndex == 3 || pageIndex == 4 || pageIndex == 5 || pageIndex == 6) {
                            pageIndex = 2;
                          } else if (pageIndex == 7 || pageIndex == 8) {
                            pageIndex = 6;
                          }
                          else if (pageIndex ==9) {
                            pageIndex = 4;
                          }
                          else if (pageIndex ==10) {
                            pageIndex = 8;
                          }
                          else if (pageIndex > 0) {
                            pageIndex = pageIndex - 1;
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
          pageIndex== 0 || pageIndex == 1|| pageIndex == 4 || pageIndex == 8? Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: () async{
                  if(pageIndex == 0){
                    if(_formkey.currentState.validate()){
                      final userexist = await ProjectsDatabaseService().projectExist(projectname);

                      if(userexist== null){
                        if(_imagefilelist.length  <=0){
                          setState(() {
                            projectnNameError =AppLocalizations.of(context).translate('SelectTheImage');
                            print(projectnNameError);
                          });
                        }
                        else{
                          setState(() {
                            pageIndex = pageIndex + 1;
                          });
                        }

                      }
                      else{

                        setState(() {
                            projectnNameError =AppLocalizations.of(context).translate('ThisProjectNameisexist');
                           print(projectnNameError);
                        });
                      }



                    }

                  }
                  else if(pageIndex == 1){
                   if(_englishRules.length  >0)
                     {
                       setState(() {
                         pageIndex = pageIndex + 1;
                       });
                     }
                  }
                  else if(pageIndex == 4){
                    if(_buildingList.length>0){
                      setState(() {
                        pageIndex = 9;
                      });
                    }

                  }
                  else if(pageIndex == 8){

                    if(_mixedusedbuildingList.length>0){
                      setState(() {
                        pageIndex = 10;
                      });
                    }

                  }
                  else{
                    setState(() {
                      pageIndex = pageIndex + 1;
                    });
                  }
                },
                child: Icon(
                  Icons.navigate_next_outlined,
                  color: CommonAssets.AppbarTextColor,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ):Container()
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
   // print(pageIndex);
    final size = MediaQuery.of(context).size;
    if (pageIndex == 0) {
      return mainScreen();
    } else if (pageIndex == 1) {
      return pageviewRules(_rulesModelGet);

    }
    else if (pageIndex == 2) {
      return structureType(size);
    }
    else if (pageIndex == 3) {

      return housingStructure(size);
    }
    else if (pageIndex == 4) {
      //  pageindex  = 9 is link with this page
      return apartmentName(size);
    }
    else if (pageIndex == 5) {
      return commercialStructure(size);
    }
    else if (pageIndex == 6) {
      return mixeduse(size);
    }
    else if (pageIndex == 7) {
      return mixeduseShop(size);
    }
    else if (pageIndex == 8) {
      // link with page index  10
      return mixeduseApartmentName(size);
    }
    else if (pageIndex == 9) {
      // link with page index  4
      return apartmentStrucutre(size);
    }
    else if (pageIndex == 10) {
      // link with page index  8
      return mixeduseFlats(size);
    }
    else {
      return Center(child: Container(child: Text('Page index ${pageIndex}')));
    }
  }

  Widget mainScreen() {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                projectnNameError==null?Container():Center(
                  child: Text(
                    projectnNameError,
                    style: TextStyle(
                      color: CommonAssets.errorColor,
                    ),),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  autofocus: false,
                  initialValue: projectname ==  null?'': projectname.toString(),
                  onChanged: (val){
                    setState(() {

                      projectname  = val;
                      projectnNameError = null;
                    });
                  },

                  validator: (val) =>  nameValidator(val),

                  decoration: commoninputdecoration.copyWith(
                      labelText:
                          AppLocalizations.of(context).translate('ProjectName')),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  autofocus: false,
                  initialValue: landmark ==  null?'': landmark.toString(),
                  onChanged: (val)=> landmark= val,

                  validator: (val) =>  val.isEmpty ?AppLocalizations.of(context).translate('EnterTheLandmark'):null,

                  decoration: commoninputdecoration.copyWith(
                      labelText:
                      AppLocalizations.of(context).translate('Landmark')),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  autofocus: false,
                  initialValue: address ==  null?'': address.toString(),
                  onChanged: (val)=> address= val,

                  validator: (val) =>  val.isEmpty ?AppLocalizations.of(context).translate('EnterTheAddress'):null,
                  maxLines: 2,
                  decoration: commoninputdecoration.copyWith(
                      labelText:
                      AppLocalizations.of(context).translate('Address')),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                   maxLines: 4,
                  autofocus: false,
                  initialValue: description ==  null?'': description.toString(),
                  onChanged: (val)=> description= val,

                  validator: (val) =>  val.isEmpty ?AppLocalizations.of(context).translate('EnterTheDescription'):null,

                  decoration: commoninputdecoration.copyWith(
                      labelText: AppLocalizations.of(context).translate('Description')),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
             // height: size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.7,
                    height: size.height * 0.32,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: CommonAssets.boxBorderColors,
                              width: 0.5)),
                      child: showimageindex == -1
                          ? _image == null
                              ? Center(
                                  child: Text('Select Image'),
                                )
                              : Image.file(_image)
                          : Image.file(_imagefilelist[showimageindex]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        shape: StadiumBorder(),
                        color: CommonAssets.boxBorderColors,
                        onPressed: () async{


                            getimage(ImageSource.camera);


                        },
                        child: Icon(
                          Icons.camera,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      RaisedButton(
                        shape: StadiumBorder(),
                        color: CommonAssets.boxBorderColors,
                        onPressed: ()async {
                          var permission = await Permission.storage.status;
                          if(permission.isDenied  || permission.isUndetermined){

                            await Permission.storage.request();
                          }
                          else if(permission.isPermanentlyDenied)
                          {
                            return openAppSettings();
                          }
                          else if(permission.isGranted ){
                            getimage(ImageSource.gallery);
                          }
                          else {
                            return openAppSettings();
                          }

                        },
                        child: Icon(
                          Icons.folder,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height *0.01,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: CommonAssets.boxBorderColors,
                            width: 0.5)),
                   // width: size.width * 0.2,
                    height: size.height *0.08,

                    child: ListView.builder(

                        itemCount: _imagefilelist.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                showimageindex = index;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                print('ss');
                                showimageindex = -1;
                                _imagefilelist.removeAt(index);
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: CommonAssets.boxBorderColors,
                                      width: 0.5)),
                              child: Image.file(
                                _imagefilelist[index],
                                height: size.height * 0.8,
                                width: size.width * 0.18,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),

            // Divider(
            //   color: Theme.of(context).primaryColor,
            //   thickness: 2,
            // ),
          ],
        ),
      ),
    ]));
  }
  //
 // // rules
  //

  Widget pageviewRules(RulesModel _rulesmodel_main){
    PageController _pageController = PageController(initialPage: 0);
    return
      PageView(
        controller: _pageController,
        children: [
          rulesWidget(_rulesmodel_main.english,_rulesmodel_main),
          rulesWidget(_rulesmodel_main.gujarati,_rulesmodel_main),
          rulesWidget(_rulesmodel_main.hindi,_rulesmodel_main),

        ],
      );
  }
  Widget rulesWidget(List<String> _rules,RulesModel _rulesModel) {
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
                  //_selectedRulesIndex.add(index);
                  _englishRules.add(_rulesModel.english[index]);
                  _hindiRules.add(_rulesModel.hindi[index]);
                  _gujaratiRules.add(_rulesModel.gujarati[index]);

                } else {
                //  _selectedRulesIndex.remove(index);
                  _englishRules.remove(_rulesModel.english[index]);
                  _hindiRules.remove(_rulesModel.hindi[index]);
                  _gujaratiRules.remove(_rulesModel.gujarati[index]);

                }
                print("Selected rules ${_englishRules}");
                print("_hindiRules rules ${_hindiRules}");
                print("_gujaratiRules rules ${_gujaratiRules}");
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
                pageIndex =  3+index;
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

  //
  // // // Housing Structure
  //

  Widget housingStructure(Size size){
print(pageIndex);
    return Container(

        child:Column(

          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
              child: Container(
                //color: Colors.white,
                height: size.height  *0.1,
                child: Form(
                  key: _houseFormkey,
                  child: Row(
                    children: [
                      Expanded(child: TextFormField(

                        validator: Stringvalidation,
                        // keyboardType: TextInputType.text,
                        maxLength: 1,
                        onChanged: (val)=> part = val.toUpperCase(),
                        decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Part')),
                      )),
                      SizedBox(width: size.width *0.01,),
                      Expanded(child: TextFormField(
                        initialValue: house.toString(),
                        validator: numbervalidtion,
                        keyboardType: TextInputType.phone,
                        maxLength: 3,
                        onChanged: (val)=> house = int.parse(val),
                        decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('House')),
                      )),
                      SizedBox(width: size.width *0.01,),
                      Container(
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.add),

                            color: Colors.black,
                            iconSize: size.height *0.04,
                            onPressed: (){
                              if(_houseFormkey.currentState.validate()){
                                if(!_localpart.contains(part)){
                                  setState(() {
                                    _localpart.add(part);
                                    _houseStructuure.add(CreateHousingStrctureModel(name: part,totalhouse: house));
                                  });
                                }


                              }

                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height *0.1,
              // child: Text(AppLocalizations.of(context).translate('Floors')),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding:  EdgeInsets.only(left: size.width *0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('Part'),
                            style: TextStyle(
                                fontSize: size.height *0.03,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                              padding:   EdgeInsets.only(right: size.width *0.02),
                              child: selected_part !=  null ? Text(
                                _houseStructuure[selected_part].name .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height *0.02
                                ),
                              ):Container()
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _houseStructuure.length,
                        itemBuilder: (context,partindex){

                          return GestureDetector(
                            onLongPress: (){
                              setState(() {
                                _localpart.removeAt(partindex);
                                _houseStructuure.removeAt(partindex);
                                selected_part = null;
                              });
                            },
                            onTap: (){
                              setState(() {
                                selected_part = partindex;

                                print(number);
                                // print(selected_part.toString());
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: partindex == selected_part ?Theme.of(context).primaryColor :Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: partindex == selected_part ?Colors.white :Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      _houseStructuure[partindex].name.toString(),
                                      style: TextStyle(
                                        fontSize: size.height *0.02,
                                        color: partindex == selected_part ?Colors.white:CommonAssets.standardtextcolor,
                                      ),),
                                  ),
                                )
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            selected_part == null?Expanded(child: Container()):Expanded(
              child: GridView.builder(

                  itemCount: _houseStructuure[selected_part].totalhouse,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: (size.height /size.height *1.8)

                  ) ,

                  itemBuilder: (context,shopindex){
                    //  building.add([shopindex]);


                    int localshopnumber = shopindex +1;

                    return Container(

                        width: size.width /2 ,
                        height: size.height *0.1,
                        // color: selected_part%2 ==0?Colors.lightBlue:Colors.brown,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                              localshopnumber.toString(),
                              style: TextStyle(
                                  fontSize: size.height *0.02
                              ),),
                          ),
                        )
                    );
                  }),
            ),
            _houseStructuure.length >0?   Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  onPressed: () async{
                    // TODO : ADD data in localization;s file
                    print(_houseStructuure.length);
                   List<List<String>> rules=  [_englishRules,_gujaratiRules,_hindiRules];
                   setState(() {
                isLoading = true;
                   });
                  await ProjectsDatabaseService().createHousingStructure(_houseStructuure, projectname.toLowerCase(), rules,landmark,address,description,_imagefilelist);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);

                  },
                  child: Text(
                    AppLocalizations.of(context).translate("Add"),
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ):Container()
          ],
        )
    );
  }
  //
  // // // apartment structure //
  //

  Widget apartmentName(Size size){
    return Column(

      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
          child: Container(
            //color: Colors.white,
            height: size.height  *0.1,
            child: Form(
              key: _apartmentformkey0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: TextFormField(

                    validator: StringvalidationForAparment,
                    // keyboardType: TextInputType.text,
                    maxLength: 2,
                    onChanged: (val)=>apartmentname = val.toUpperCase(),
                    decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('ApartmentName')),
                  )),

                  Container(
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add),

                        color: Colors.black,
                        iconSize: size.height *0.04,
                        onPressed: (){
                          print(_buildingList);
                          if(_apartmentformkey0.currentState.validate()){

                            if(!_buildingList.contains(apartmentname)){
                              setState(() {
                                _buildingList.add(apartmentname);
                                getModel(floors,flats);

                              });
                            }


                          }

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(

              itemCount: _buildingList.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: (size.height /size.height *1.8)

              ) ,

              itemBuilder: (context,apartmentIndex){
                //  building.add([shopindex]);




                return GestureDetector(
                  onLongPress:(){
                    setState(() {
                      _buildingList.removeAt(apartmentIndex);
                    });
                  },
                  child: Container(

                      width: size.width /2 ,
                      height: size.height *0.1,
                      // color: selected_part%2 ==0?Colors.lightBlue:Colors.brown,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child: Text(
                            _buildingList[apartmentIndex].toString(),
                            style: TextStyle(
                                fontSize: size.height *0.02
                            ),),
                        ),
                      )
                  ),
                );
              }),
        ),
      ],
    );

  }
  Widget apartmentStrucutre(Size size){

    return Container(
        width: size.width,
        height:size.height,
        child: Column(
          children: [
            Container(
              height: size.height *0.08,
              child: Form(
                key: _apartmentformkey,
                child: Row(

                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: floors.toString(),
                          keyboardType: TextInputType.phone,
                          maxLength: 2,
                          decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Floors'),counterText: ""),
                          // validator: (val) => val.isEmpty ?'Enter The Number':null,
                          onChanged: (val){
                            setState(() {
                              floors =int.parse(val);
                              print(floors);

                            });
                            getModel(floors,flats);
                          }
                      ),
                    ),
                    SizedBox(width: 10,),

                    Expanded(
                      child: TextFormField(
                        initialValue: flats.toString(),
                        maxLength: 1,
                        keyboardType: TextInputType.phone,
                        decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Flats'),counterText: ""),
                        // validator: (val) => val.isEmpty ?'Enter The Number':null,
                        onChanged: (val){

                          //flats =int.parse(val)
                          setState(() {

                            if(int.parse(val) == 2 ||int.parse(val) == 4 || int.parse(val) == 6||int.parse(val) == 8){
                              flats =int.parse(val);

                            }
                            else{
                              // print('ss');
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate('numberofflatsare246'),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  textColor: CommonAssets.AppbarTextColor,
                                  fontSize: size.height *0.02
                              );
                            }

                          });
                          getModel(floors,flats);
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.black,),
                      left: BorderSide(color: Colors.black,),
                      top: BorderSide(color: Colors.black,),
                      bottom: BorderSide(color: Colors.black,),

                    )
                ),
                child: ListView.builder(
                    itemCount:floors ,
                    itemBuilder: (context,index){
                      return ModelStructure(index);
                    }
                ),
              ),

            ),
            _buildingModel.length > 0 ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  onPressed: () async{
                    List<List<String>> rules = [_englishRules,_gujaratiRules,_hindiRules];
                    setState(() {
                      isLoading = true;

                    });

                   await ProjectsDatabaseService().createApartmentStructure(_buildingModel, projectname.toLowerCase(), rules,landmark,address,description,_imagefilelist);
                    Navigator.pop(context);

                  },

                  child: Text(

                    AppLocalizations.of(context).translate("Add"),
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ):Container(),
          ],
        )
    );
  }

  //
  // //  //

  Widget ModelStructure(int index){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
// print(floor.toString());
    int floornumber = index +1;
    int staring =100 * (index+1);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            //  foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).primaryColor,
            child:Text(floornumber.toString(),style: TextStyle(
              color: Colors.white,
              fontSize: height *0.02,
            ),) ,
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width ,
                height: height * 0.06 ,

                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount:flats,itemBuilder: (context,index){
                  int newflat = staring  + index +1;

                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal:width * 0.003),
                    child: Container(
                        width: width* 0.75 / flats ,

                        height: height / floornumber,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Center(child: Text(
                          newflat.toString(),style: TextStyle(
                            fontSize: height * 0.015,
                            fontWeight:FontWeight.bold
                        ),))
                    ),
                  );
                }),
              ),
            ),
          ),
        )
      ],
    );
  } //
  //  // //  Commercial Structure
  //
  Widget commercialStructure(Size size){
    allocationnumber();
    commericalGetModel();
   return Container(

        child:Column(

          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
              child: Container(
                //color: Colors.white,

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: TextFormField(
                            initialValue: commericalfloors.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 1,
                            onChanged: (val)=> commericalfloors = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Floors')),
                          )),
                          SizedBox(width: size.width *0.01,),
                          Expanded(child: TextFormField(
                            initialValue: commericalShop_per_floor.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 3,
                            onChanged: (val)=> commericalShop_per_floor = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Shops')),
                          )),


                        ],
                      ),
                      SizedBox(height: size.width *0.01,),
                      Row(
                        children: [

                          Expanded(child: TextFormField(
                            initialValue: commericalStaringnumber.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 4,
                            onChanged: (val)=> commericalStaringnumber = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('StartingNumber')),
                          )),
                          SizedBox(width: size.width *0.01,),
                          Expanded(child: TextFormField(
                            initialValue: commericalDifferentialvalue.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 4,
                            onChanged: (val)=> commericalDifferentialvalue = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('NumberGap')),
                          )),
                        ],
                      ),
                    ],
                  )
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height *0.1,
              // child: Text(AppLocalizations.of(context).translate('Floors')),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding:  EdgeInsets.only(left: size.width *0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('Floors'),
                            style: TextStyle(
                                fontSize: size.height *0.03,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                              padding:   EdgeInsets.only(right: size.width *0.02),
                              child: commericalSelectdfloor !=  null ? Text(
                                commericalSelectdfloor.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height *0.02
                                ),
                              ):Container()
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: commericalfloors,
                        itemBuilder: (context,floorindex){

                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                commericalSelectdfloor = floorindex;

                                print(commericalNumber);
                                // print(selectdfloor.toString());
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: floorindex == commericalSelectdfloor ?Theme.of(context).primaryColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: floorindex == commericalSelectdfloor ?Colors.white:Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      floorindex.toString(),
                                      style: TextStyle(
                                        fontSize: size.height *0.02,
                                        color: floorindex == commericalSelectdfloor ?Colors.white:CommonAssets.standardtextcolor,
                                      ),),
                                  ),
                                )
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            commericalSelectdfloor == null?Expanded(child: Container()):Expanded(
              child: GridView.builder(

                  itemCount: commericalShop_per_floor,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: (size.height /size.height *1.8)

                  ) ,

                  itemBuilder: (context,shopindex){
                    //  building.add([shopindex]);


                    int localshopnumber = commericalNumber +shopindex;

                    return Container(

                        width: size.width /2 ,
                        height: size.height *0.1,
                        // color: selectdfloor%2 ==0?Colors.lightBlue:Colors.brown,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                              localshopnumber.toString(),
                              style: TextStyle(
                                  fontSize: size.height *0.02
                              ),),
                          ),
                        )
                    );
                  }),
            ),
            _commercialModel.length >0?  Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  onPressed: ()async {
                    List<List<String>>  rules= [_englishRules,_gujaratiRules,_hindiRules];
                  setState(() {
                    isLoading = true;
                  });
                  await ProjectsDatabaseService().createCommercialStructure(_commercialModel, projectname.toLowerCase(), rules,landmark,address,description,_imagefilelist);
              return Navigator.pop(context);
                  },


                  child: Text(

                    AppLocalizations.of(context).translate("Add"),
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ):Container(),
          ],
        )
    );
  }

  Widget mixeduse(Size size){

      List<Map> _typeofsttuctur = [
        {
          'type':AppLocalizations.of(context).translate("Shops"),
          'detail':AppLocalizations.of(context).translate("Shops"),
          'image':'assets/shop.jpg',
        },
        {
          'type':AppLocalizations.of(context).translate("Flats"),
          'detail':AppLocalizations.of(context).translate("Flats"),
          'image':'assets/apartment.png',
        },


      ];
      return Column(
        children: [
      Expanded(
        child: ListView.builder(
        itemCount: _typeofsttuctur.length,
          itemBuilder: (context,index){
            return Container(
              height: size.height *0.2,

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex =  7+index;
                    //print(pageIndex);
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
        ),

      ),
          _mixusebuildingModel.length >0 && _mixupcommercialModel.length >0 ?Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.01, vertical: size.height * 0.005),
            child: Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3,
                    vertical: size.height * 0.015),
                shape: StadiumBorder(),
                color: Theme.of(context).buttonColor,
                onPressed: () async{
                  List<List<String>> rules =[_englishRules,_gujaratiRules,_hindiRules];
                  setState(() {
                  isLoading = true;
                  });
                  await ProjectsDatabaseService().createMixeduseStructure(_mixupcommercialModel, _mixusebuildingModel, projectname.toLowerCase(), rules,landmark,address,description,_imagefilelist);
                  Navigator.pop(context);
                },

                child: Text(

                  AppLocalizations.of(context).translate("Add"),
                  style: TextStyle(
                      color: CommonAssets.AppbarTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: size.height * 0.020),
                ),
              ),
            ),
          ):Container()
        ],
      );

  }


  Widget mixeduseShop(Size size) {
    mixupAllocationnumber();
    mixupCommericalGetModel();
    return Container(

        child:Column(

          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
              child: Container(
                //color: Colors.white,

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: TextFormField(
                            initialValue: mixupCommericalfloors.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 1,
                            onChanged: (val)=> mixupCommericalfloors = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Floors')),
                          )),
                          SizedBox(width: size.width *0.01,),
                          Expanded(child: TextFormField(
                            initialValue: mixupCommericalShop_per_floor.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 3,
                            onChanged: (val)=> mixupCommericalShop_per_floor = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Shops')),
                          )),


                        ],
                      ),
                      SizedBox(height: size.width *0.01,),
                      Row(
                        children: [

                          Expanded(child: TextFormField(
                            initialValue: mixupCommericalStaringnumber.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 4,
                            onChanged: (val)=> mixupCommericalStaringnumber = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('StartingNumber')),
                          )),
                          SizedBox(width: size.width *0.01,),
                          Expanded(child: TextFormField(
                            initialValue: mixupCommericalDifferentialvalue.toString(),
                            keyboardType: TextInputType.phone,
                            maxLength: 4,
                            onChanged: (val)=> mixupCommericalDifferentialvalue = int.parse(val),
                            decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('NumberGap')),
                          )),
                        ],
                      ),
                    ],
                  )
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height *0.1,
              // child: Text(AppLocalizations.of(context).translate('Floors')),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding:  EdgeInsets.only(left: size.width *0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('Floors'),
                            style: TextStyle(
                                fontSize: size.height *0.03,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                              padding:   EdgeInsets.only(right: size.width *0.02),
                              child: mixupCommericalSelectdfloor !=  null ? Text(
                                mixupCommericalSelectdfloor.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height *0.02
                                ),
                              ):Container()
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mixupCommericalfloors,
                        itemBuilder: (context,floorindex){

                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                mixupCommericalSelectdfloor = floorindex;

                                print(mixupCommericalNumber);
                                // print(selectdfloor.toString());
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: floorindex == mixupCommericalSelectdfloor ?Colors.black.withOpacity(0.5):Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      floorindex.toString(),
                                      style: TextStyle(
                                        fontSize: size.height *0.02,
                                        color: floorindex == mixupCommericalSelectdfloor ?Colors.white:CommonAssets.standardtextcolor,
                                      ),),
                                  ),
                                )
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            mixupCommericalSelectdfloor == null?Expanded(child: Container()):Expanded(
              child: GridView.builder(

                  itemCount: mixupCommericalShop_per_floor,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: (size.height /size.height *1.8)

                  ) ,

                  itemBuilder: (context,shopindex){
                    //  building.add([shopindex]);


                    int localshopnumber = mixupCommericalNumber +shopindex;

                    return Container(

                        width: size.width /2 ,
                        height: size.height *0.1,
                        // color: selectdfloor%2 ==0?Colors.lightBlue:Colors.brown,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                              localshopnumber.toString(),
                              style: TextStyle(
                                  fontSize: size.height *0.02
                              ),),
                          ),
                        )
                    );
                  }),
            ),
            _mixupcommercialModel.length >0?  Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    setState(() {
                      pageIndex =6;
                    });
                  },

                  child: Text(

                    AppLocalizations.of(context).translate("Add"),
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ):Container(),
          ],
        )
    );
  }
  //
  // // // mixeduse apartment name
  //
  Widget mixeduseApartmentName(Size size) {
    return Column(

      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
          child: Container(
            //color: Colors.white,
            height: size.height  *0.1,
            child: Form(
              key: _mixeduseApartmentformkey0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: TextFormField(

                    validator: StringvalidationForAparment,
                    // keyboardType: TextInputType.text,
                    maxLength: 2,
                    onChanged: (val)=>mixeduseApartmentname = val.toUpperCase(),
                    decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('ApartmentName')),
                  )),

                  Container(
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add),

                        color: Colors.black,
                        iconSize: size.height *0.04,
                        onPressed: (){

                          if(_mixeduseApartmentformkey0.currentState.validate()){

                            if(!_mixedusedbuildingList.contains(mixeduseApartmentname)){
                              setState(() {
                                _mixedusedbuildingList.add(mixeduseApartmentname);
                                MixuseGetModel(mixuseFloors,mixuseFlats);
                                print( "list of part of ${_mixedusedbuildingList}");
                              });
                            }


                          }

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(

              itemCount: _mixedusedbuildingList.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: (size.height /size.height *1.8)

              ) ,

              itemBuilder: (context,apartmentIndex){
                //  building.add([shopindex]);




                return GestureDetector(
                  onLongPress:(){
                    setState(() {
                      _mixedusedbuildingList.removeAt(apartmentIndex);
                    });
                  },
                  child: Container(

                      width: size.width /2 ,
                      height: size.height *0.1,
                      // color: selected_part%2 ==0?Colors.lightBlue:Colors.brown,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child: Text(
                            _mixedusedbuildingList[apartmentIndex].toString(),
                            style: TextStyle(
                                fontSize: size.height *0.02
                            ),),
                        ),
                      )
                  ),
                );
              }),
        ),
      ],
    );
  }
  Widget mixeduseFlats(Size size) {

    return Container(
        width: size.width,
        height:size.height,
        child: Column(
          children: [
            Container(
              height: size.height *0.08,
              child: Form(
                key: _MixuseApartmentformkey,
                child: Row(

                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: mixuseFloors.toString(),
                          keyboardType: TextInputType.phone,
                          maxLength: 2,
                          decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Floors'),counterText: ""),
                          // validator: (val) => val.isEmpty ?'Enter The Number':null,
                          onChanged: (val){
                            setState(() {
                              mixuseFloors =int.parse(val);
                              MixuseGetModel(mixuseFloors,mixuseFlats);
                            });
                          }
                      ),
                    ),
                    SizedBox(width: 10,),

                    Expanded(
                      child: TextFormField(
                        initialValue: mixuseFlats.toString(),
                        maxLength: 1,
                        keyboardType: TextInputType.phone,
                        decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Flats'),counterText: ""),
                        // validator: (val) => val.isEmpty ?'Enter The Number':null,
                        onChanged: (val){

                          //flats =int.parse(val)
                          setState(() {

                            if(int.parse(val) == 2 ||int.parse(val) == 4 || int.parse(val) == 6||int.parse(val) == 8){
                              mixuseFlats =int.parse(val);
                              MixuseGetModel(mixuseFloors,mixuseFlats);
                            }
                            else{
                              // print('ss');
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate('numberofflatsare246'),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  textColor: CommonAssets.AppbarTextColor,
                                  fontSize: size.height *0.02
                              );
                            }

                          });
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height *0.1,
              // child: Text(AppLocalizations.of(context).translate('Floors')),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding:  EdgeInsets.only(left: size.width *0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('Apartments'),
                            style: TextStyle(
                                fontSize: size.height *0.03,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                              padding:   EdgeInsets.only(right: size.width *0.02),
                              child: selectedBuilldingindex !=  null ? Text(
                                _mixedusedbuildingList[selectedBuilldingindex].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height *0.02
                                ),
                              ):Container()
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mixedusedbuildingList.length,
                        itemBuilder: (context,partindex){

                          return GestureDetector(
                            onLongPress: (){
                              setState(() {

                              });
                            },
                            onTap: (){
                              setState(() {
                                selectedBuilldingindex = partindex;
                                print("selectedBuilldingindex = ${selectedBuilldingindex}");
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: partindex == selectedBuilldingindex ?Theme.of(context).primaryColor:CommonAssets.unselectedpart,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: partindex == selectedBuilldingindex ?   CommonAssets.AppbarTextColor:CommonAssets.standardtextcolor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      _mixedusedbuildingList[partindex].toString(),
                                      style: TextStyle(
                                        fontSize: size.height *0.02,
                                        color: partindex == selectedBuilldingindex ?   CommonAssets.AppbarTextColor:CommonAssets.standardtextcolor,
                                      ),),
                                  ),
                                )
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),

    Divider(color: CommonAssets.dividercolor,),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.black,),
                      left: BorderSide(color: Colors.black,),
                      top: BorderSide(color: Colors.black,),
                      bottom: BorderSide(color: Colors.black,),

                    )
                ),
                child:  ListView.builder(
                  //_mixusebuildingModel[selectedBuilldingindex].floorsandflats.length
                    itemCount:   mixuseFloors,
                    itemBuilder: (context,index){

                      return MixUseModelStructure(index,_mixusebuildingModel[selectedBuilldingindex].floorsandflats[index].flats.length);
                    }
                ),
              ),

            ),
            _mixusebuildingModel.length > 0 ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01, vertical: size.height * 0.005),
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: size.height * 0.015),
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                   setState(() {
                     pageIndex= 6;
                   });
                  },

                  child: Text(

                    AppLocalizations.of(context).translate("Add"),
                    style: TextStyle(
                        color: CommonAssets.AppbarTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.020),
                  ),
                ),
              ),
            ):Container(),
          ],
        )
    );
  }


  Widget MixUseModelStructure(int _floor,int _flats){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    int floornumber = _floor +1;


    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            //  foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).primaryColor,
            child:Text(floornumber.toString(),style: TextStyle(
              color: Colors.white,
              fontSize: height *0.02,
            ),) ,
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width ,
                height: height * 0.06 ,

                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: _mixusebuildingModel[selectedBuilldingindex].floorsandflats[_floor].flats.length
                    ,itemBuilder: (context,indexflat){


                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _mixusebuildingModel[selectedBuilldingindex].floorsandflats[_floor].flats.removeAt(indexflat);
                      });
                    },
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal:width * 0.003),
                      child: Container(
                          width: width* 0.75 / _flats ,

                          height: height / floornumber,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                          ),
                          child: Center(child: Text(
                            _mixusebuildingModel[selectedBuilldingindex].floorsandflats[_floor].flats[indexflat].toString()
                          ,style: TextStyle(

                              fontSize: height * 0.015,
                              fontWeight:FontWeight.bold
                          ),))
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        )
      ],
    );
  }

  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The Number Only';
    }
    else if(value.length >3){
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }
  String Stringvalidation(String value){
    Pattern pattern = '^[a-zA-Z]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The character Only';
    }
    else if(value.length >1){
      return "Character Is Grater Than One";
    }
    else {
      return null;
    }
  }
  String StringvalidationForAparment(String value){
    Pattern pattern = '^[a-zA-Z]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The character Only';
    }
    else if(value.length >2){
      return "Character Is Grater Than One";
    }
    else {
      return null;
    }
  }

   nameValidator(String val) {
    final res =  ProjectsDatabaseService().projectExist(val);
    if(val.isEmpty){
      return AppLocalizations.of(context).translate('EnterTheProjectName');;
    }

    else{

      return null;
    }
  }


}
