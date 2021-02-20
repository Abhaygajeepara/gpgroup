import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class AddBroker extends StatefulWidget {
  @override
  _AddBrokerState createState() => _AddBrokerState();
}

class _AddBrokerState extends State<AddBroker> {
  final _formkey = GlobalKey<FormState>();
  File _image;
  String name;
  String uid;
  int phoneNumber;
  bool loading = false;
  String error ;
  getImage(ImageSource source)async{
    PickedFile _pick = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(_pick.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final space = size.height *0.01;
    return Scaffold(
      appBar: CommonAppbar(Container()),

      body: loading ? CircularLoading(): SingleChildScrollView(
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
                          child: Text('Select Image'),
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
                  decoration: commoninputdecoration.copyWith(labelText: 'Id'),
                  onChanged: (val)=>uid = val,
                  validator: (val)=>val.isEmpty ? AppLocalizations.of(context).translate("ThisFieldIsMandatory"):null,
                ),
              SizedBox(height: space),
                TextFormField(
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Name')),
                  onChanged: (val)=>name = val,
                  validator: (val)=>val.isEmpty ? AppLocalizations.of(context).translate("ThisFieldIsMandatory"):null,
                ),
                SizedBox(height: space),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('MobileNumber')),
                  onChanged: (val)=>phoneNumber = int.parse(val),
                  validator:  numbervalidtion,
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
                        final result =  await ProjectsDatabaseService().brokerExist(uid);
                        print(result);
                       if(_image == null){
                         setState(() {
                           error = AppLocalizations.of(context).translate("SelectTheImage");
                         });
                       }
                       else if(result == true){
                         setState(() {
                           error = AppLocalizations.of(context).translate("BrokerExist");
                         });
                       }
                       else{
                         setState(() {
                           loading = true;
                         });
                         await ProjectsDatabaseService().brokerData(uid, name, phoneNumber, _image);
                         Navigator.pop(context);
                       }
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

  String uidValidation(String val){
    if(val.isEmpty){
      return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
    }
    else if(val.length < 3){
      return AppLocalizations.of(context).translate("MinimumCharactersIs3");
    }
  }
}
