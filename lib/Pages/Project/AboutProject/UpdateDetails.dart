import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UpdateProjectDetails extends StatefulWidget {
  String projectName;
  UpdateProjectDetails({@required this.projectName});
  @override
  _UpdateProjectDetailsState createState() => _UpdateProjectDetailsState();
}

class _UpdateProjectDetailsState extends State<UpdateProjectDetails> {
  final _formkey = GlobalKey<FormState>();

  File _image;
  List<File> _imagefilelist = List();
  int showFileImageIndex = -1;
  int showNetworkImageIndex = -1;
  String landmark;
  String address;
  String description;
  bool isNetworkImage = false;
  bool loading = false;
  getimage(ImageSource source) async {
    PickedFile pickfile = await ImagePicker().getImage(source: source);
    setState(() {
      showFileImageIndex = -1;
      isNetworkImage = false;
      _image = File(pickfile.path);
      _imagefilelist.add(_image);
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    final size =MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: StreamBuilder<ProjectNameList>(
        stream: projectProvider.SINGLEPROJECT,
        builder: (context,singleProjectInfoSnapshot){
          if(singleProjectInfoSnapshot.hasData){
              return loading?CircularLoading(): SingleChildScrollView(
              child: Padding(
                 padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        initialValue: singleProjectInfoSnapshot.data.landmark.toString(),
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
                        initialValue: singleProjectInfoSnapshot.data.address.toString(),
                        onChanged: (val)=> address= val,
                        maxLines: 2,
                        validator: (val) =>  val.isEmpty ?AppLocalizations.of(context).translate('EnterTheAddress'):null,

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
                        initialValue: singleProjectInfoSnapshot.data.description.toString(),
                        onChanged: (val)=> description= val,

                        validator: (val) =>  val.isEmpty ?AppLocalizations.of(context).translate('EnterTheDescription'):null,

                        decoration: commoninputdecoration.copyWith(
                            labelText: AppLocalizations.of(context).translate('Description')),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        height: size.height * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                    child:
                                    !isNetworkImage?
                                    showFileImageIndex == -1
                                        ? _image == null
                                        ? Center(
                                      child: Text(AppLocalizations.of(context).translate('SelectImage')),
                                    )
                                        : Image.file(_image)
                                        : Image.file(_imagefilelist[showFileImageIndex])
                                        :Image.network(singleProjectInfoSnapshot.data.imagesUrl[showNetworkImageIndex]),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      shape: StadiumBorder(),
                                      color: CommonAssets.boxBorderColors,
                                      onPressed: () {
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
                                      onPressed: () {
                                        getimage(ImageSource.gallery);
                                      },
                                      child: Icon(
                                        Icons.folder,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),

                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CommonAssets.boxBorderColors,
                                      width: 0.5)),
                              width: size.width * 0.2,
                              child: ListView.builder(
                                  itemCount: singleProjectInfoSnapshot.data.imagesUrl.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isNetworkImage = true;
                                          showNetworkImageIndex = index;
                                        });
                                      },
                                      onLongPress: () async{
                                        String url = singleProjectInfoSnapshot.data.imagesUrl[index];
                                        if(singleProjectInfoSnapshot.data.imagesUrl.length >1)
                                          {
                                            setState(() {
                                              projectProvider.imageDeleteOfProject(url);

                                            });
                                          }
                                        else{
                                          Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context).translate('MinimumImageShouldBeOne'),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Theme.of(context).primaryColor,
                                              textColor: CommonAssets.AppbarTextColor,
                                              fontSize: size.height *0.02
                                          );
                                        }
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: CommonAssets.boxBorderColors,
                                                width: 0.5)),
                                        child: Image.network(
                                          singleProjectInfoSnapshot.data.imagesUrl[index],
                                          height: size.height * 0.1,
                                          width: size.width * 0.18,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        height: size.width * 0.15,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonAssets.boxBorderColors,
                                width: 0.5)),
                       // width: size.width * 0.2,
                        child: ListView.builder(
                            itemCount: _imagefilelist.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNetworkImage = false;
                                    showFileImageIndex = index;
                                  });
                                },
                                onLongPress: () {
                                  setState(() {
                                    print('ss');
                                    showFileImageIndex = -1;
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
                                    height: size.height * 0.1,
                                    width: size.width * 0.18,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: size.height *0.01,
                      ),
                      RaisedButton(
                        color: CommonAssets.iconBackGroundColor,
                        shape: StadiumBorder(),
                        child: Text(
                            AppLocalizations.of(context).translate('Update'),
                          style: TextStyle(
                            color: CommonAssets.iconcolor,
                          ),
                        ),
                        onPressed: ()async{
                          setState(() {
                            loading = true;
                          });
                         await    projectProvider.UpdataProjectData(
                                landmark ?? singleProjectInfoSnapshot.data.landmark,
                                address?? singleProjectInfoSnapshot.data.address,
                                description?? singleProjectInfoSnapshot.data.description,
                                _imagefilelist
                            );
                         setState(() {
                           loading = false;
                         });
                         Navigator.pop(context);
                        },
                      ),


                    ],
                  ),
                ),
              ),
            );
          }
          else if(singleProjectInfoSnapshot.hasError){
            return Container(
              child: Center(
                child: Text(CommonAssets.snapshoterror),
              ),
            );
          }
          else{
            return CircularLoading();
          }
          }
      )


    );
  }
}
