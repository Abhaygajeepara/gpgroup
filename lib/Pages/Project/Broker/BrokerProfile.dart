import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Broker/BrokerClients.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
class BrokerProfile extends StatefulWidget {
  String brokerUid;
  BrokerProfile({@required this.brokerUid});
  @override
  _BrokerProfileState createState() => _BrokerProfileState();
}

class _BrokerProfileState extends State<BrokerProfile> {
  final _formkey = GlobalKey<FormState>();
  File _image;
  String name;

  int phoneNumber;
  int alterNativeNumber;
  bool loading = false;
  String error ;
  String password;
  bool isVisible = false;
  bool isActive ;
  bool isDetailsPage = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getImage(ImageSource source)async{
    PickedFile _pick = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(_pick.path);
    });
  }
  visible(){
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
     _projectRetrieve.setBroker(widget.brokerUid);
    final size = MediaQuery.of(context).size;
    final  labelWight = FontWeight.bold;
    final labelTextSize =  size.height *0.025;
    final normalTextSize =  size.height *0.02;
    final space = size.height *0.01;
    return Scaffold(
      appBar: CommonAppbar(Container()),

      body: StreamBuilder<BrokerModel>(
        stream: _projectRetrieve.SINGLEBROKERDATA,
        builder: (context,snapshot){
          if(snapshot.hasData){

            isActive = snapshot.data.isActiveUser;
              return loading ?CircularLoading():
              isDetailsPage ?
              detailsWidget(snapshot,context): updateWWidget(snapshot, context);
          } else if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                     // CommonAssets.snapshoterror,
                      style: TextStyle(color: CommonAssets.errorColor),
                    ),
                  ),
                );
              } else {
                return CircularLoading();
              }
            }
      ),
      bottomNavigationBar:  Theme(
        data: Theme.of(context).copyWith(
            primaryColor: CommonAssets.bottomBarActiveButtonColor
        ),
        child:

        isDetailsPage?Padding(
          padding:  EdgeInsets.all(8.0),
          child: RaisedButton.icon(
            shape: StadiumBorder(),
            // color: Theme.of(context).primaryColor,
            label: Text(
              AppLocalizations.of(context).translate('Clients'),
              style: TextStyle(
                  color: CommonAssets.buttonTextColor,
                  fontSize: size.height *0.03,
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed: (){
              setState(() {
                return    Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BrokerClients(),
                  transitionDuration: Duration(seconds: 0),
                ),);
              });
            },
            icon: Icon(
              Icons.construction,
              size: size.height *0.03,
              color: CommonAssets.buttonTextColor,
            ),
            //label: AppLocalizations.of(context).translate('Home'),
          ),
        ):Container(
          height: 0,
        ),
      ),
    );

  }


  detailsWidget(AsyncSnapshot<BrokerModel> snapshot, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final  labelWight = FontWeight.bold;
    final labelTextSize =  size.height *0.025;
    final normalTextSize =  size.height *0.02;
    final space = size.height *0.01;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(

                height: size.height *0.3,
                child: snapshot.data.image != null?Container(child: Center(
                  child: Image.network(snapshot.data.image),
                ),):Text(''),
              ),
            ),

            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                    value: isActive,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val)async{
                  print('after');
                  print(isActive);
                  setState(() {
                    isActive = !isActive;
                    print(isActive);
                  });
                  await ProjectsDatabaseService().updateBrokerData(
                      snapshot.data.id,
                      name??  snapshot.data.name,
                      phoneNumber ??snapshot.data.number,
                      alterNativeNumber ?? snapshot.data.alterNativeNumber,
                      _image,
                      password??snapshot.data.password,
                      isActive,
                      snapshot.data.image
                  );
                }),
                IconButton(
                    alignment: Alignment.bottomRight,
                    icon: Icon(Icons.edit),
                    color: CommonAssets.editIconColor,
                    onPressed: (){
                  setState(() {
                    isDetailsPage = false;
                  });
                }),
              ],
            ),
            Text(
              AppLocalizations.of(context).translate('BrokerID'),
              style: TextStyle(
                  fontSize: labelTextSize,
                  fontWeight: labelWight

              ),
            ),
            SizedBox(height: space,),
            Text(
              snapshot.data.id,
              style: TextStyle(
                fontSize: normalTextSize,

              ),
            ),
            SizedBox(height: space,),
            Text(
              AppLocalizations.of(context).translate('BrokerName'),
              style: TextStyle(
                  fontSize: labelTextSize,
                  fontWeight: labelWight

              ),
            ),
            SizedBox(height: space,),
            Text(
              snapshot.data.name,
              style: TextStyle(
                fontSize: normalTextSize,

              ),
            ),
            SizedBox(height: space,),
            Text(
              AppLocalizations.of(context).translate('MobileNumber'),
              style: TextStyle(
                  fontSize: labelTextSize,
                  fontWeight: labelWight

              ),
            ),

            SizedBox(height: space,),
            Text(
              snapshot.data.number.toString(),
              style: TextStyle(
                fontSize: normalTextSize,

              ),
            ),
            Text(
              snapshot.data.alterNativeNumber.toString(),
              style: TextStyle(
                fontSize: normalTextSize,

              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget updateWWidget(AsyncSnapshot<BrokerModel> snapshot, BuildContext context){
    final size = MediaQuery.of(context).size;
    final  labelWight = FontWeight.bold;
    final labelTextSize =  size.height *0.025;
    final normalTextSize =  size.height *0.02;
    final space = size.height *0.01;
  return   WillPopScope(
    onWillPop: (){
      setState(() {
        isDetailsPage = true;
        return null;
      });
    },
    child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('BrokersPhoto'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: CommonAssets.boxBorderColors,
                          width: 0.1)),
                  child: Center(
                    child: Container(
                      width: size.width *0.8,
                      height: size.height *0.3,
                      child: _image == null?Container(child: Center(
                        child: Image.network(snapshot.data.image),
                      ),):Image.file(_image),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    RaisedButton(
                      shape: StadiumBorder(),
                      color: CommonAssets.boxBorderColors,
                      onPressed: () async{


                        getImage(ImageSource.camera);


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
                          getImage(ImageSource.gallery);
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
                SizedBox(height: space),
                TextFormField(
                  readOnly: true,
                  initialValue: snapshot.data.id.toString(),
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('BrokerID')),


                ),
                SizedBox(height: space),
                TextFormField(
                  initialValue: snapshot.data.name.toString(),
                  maxLength: 35,
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Name')),
                  onChanged: (val)=>name = val,
                  validator: (val)=>val.isEmpty ? AppLocalizations.of(context).translate("ThisFieldIsMandatory"):null,
                ),
                SizedBox(height: space),
                TextFormField(
                  initialValue: snapshot.data.number.toString(),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('MobileNumber'),counterText: ""),
                  onChanged: (val)=>phoneNumber = int.parse(val),
                  validator:  numbervalidtion,
                ),
                SizedBox(height: space),
                TextFormField(
                  initialValue: snapshot.data.alterNativeNumber.toString(),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('AlterNativeNumber'),counterText: ""),
                  onChanged: (val)=>alterNativeNumber = int.parse(val),
                  validator:  numbervalidtion,
                ),
                SizedBox(height: space),
                TextFormField(
                  initialValue: snapshot.data.password.toString(),
                  maxLength: 16,
                  obscureText: isVisible,
                  decoration: commoninputdecoration.copyWith(
                      labelText: AppLocalizations.of(context).translate('Password'),
                      counterText: "",
                      suffixIcon: isVisible?
                      IconButton(icon: Icon(Icons.visibility_off), onPressed: (){visible();}):
                      IconButton(icon: Icon(Icons.visibility), onPressed: (){visible();})
                  ),
                  onChanged: (val)=>password = val,
                  validator:  passwordValidation,
                ),

                SizedBox(height: space*2),
                error == null?Container():Center(
                  child: Text(error,style: TextStyle(
                      color: CommonAssets.errorColor
                  ),),
                ),
                Center(
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    onPressed: ()async{

                      if(_formkey.currentState.validate()){

                        await ProjectsDatabaseService().updateBrokerData(
                            snapshot.data.id,
                            name??  snapshot.data.name,
                            phoneNumber ??snapshot.data.number,
                            alterNativeNumber ?? snapshot.data.alterNativeNumber,
                            _image,
                            password??snapshot.data.password,
                            isActive,
                            snapshot.data.image
                        );
                       setState(() {
                         isDetailsPage = true;
                       });

                      }

                    },
                    child: Text(
                      AppLocalizations.of(context).translate('Add'),
                      style: TextStyle(
                          color: CommonAssets.buttonTextColor
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
  );
  }

  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    else if(value.length <10){
      return AppLocalizations.of(context).translate("NumberIsLessThan10");
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }
  String passwordValidation(String value){

    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
      return 'Enter The Number Only';
    }
    else if(value.length <8){
      return AppLocalizations.of(context).translate("NumberIsLessThan8");
      return "Digits Is Grater Than One";
    }
    else if(value.length >16){
      return AppLocalizations.of(context).translate("NumberIsLessThan16");
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }

  String uidValidation(String val){
    if(val.isEmpty){
      return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
    }
    else if(val.length < 3){
      return AppLocalizations.of(context).translate("MinimumCharactersIs3");
    }
  }
}
