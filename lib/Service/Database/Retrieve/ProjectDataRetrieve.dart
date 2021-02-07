import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';

import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:rxdart/subjects.dart';

class ProjectRetrieve{

String  ProjectName ='d';


  setProjectName(String val){
    this.ProjectName  = val;

  }
    List<ProjectNameList> _projectnamelist(QuerySnapshot snapshot){
     return snapshot.docs.map((e) {
       return ProjectNameList(
           projectName: e.id,
            address: e.data()['Address'],
         landmark: e.data()['Landmark'],
         description: e.data()['Description'],
         typeofBuilding: e.data()['TypeofBuilding'],
         englishRules:List.from( e.data()['EnglishRules']),
         gujaratiRules: List.from( e.data()['GujaratiRules']),
         hindiRules: List.from( e.data()['HindiRules']),
         reference: List.from( e.data()['Reference']),

         imagesUrl : List.from(e.data()['ImageUrl']),



       );
     }).toList();
    }



 Stream<List<ProjectNameList>> get PROJECTNAMELIST{

   return FirebaseFirestore.instance.collection('Project').snapshots().map(_projectnamelist);
 }

    CollectionReference _collectionReference = FirebaseFirestore.instance.collection('Project');

    ProjectNameList _projectname(DocumentSnapshot e){

      return ProjectNameList(
        projectName: e.id,
        address: e.data()['Address'],
        landmark: e.data()['Landmark'],
        description: e.data()['Description'],
        typeofBuilding: e.data()['TypeofBuilding'],
        englishRules:List.from( e.data()['EnglishRules']),
        gujaratiRules: List.from( e.data()['GujaratiRules']),
        hindiRules: List.from( e.data()['HindiRules']),
        reference: List.from( e.data()['Reference']),

        imagesUrl : List.from(e.data()['ImageUrl']),



      );
    }



    Future UpdataProjectData(String landmark,String address,String description,List<File> ImageList)async{
      try{
        await _collectionReference.doc(ProjectName).update({
          "Landmark":landmark.toString(),
          "Address":address.toString(),
          "Description":description.toString(),
        });
        for(int i =0;i<ImageList.length;i++){
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
              .ref('/').child('/Images/$ProjectName/${ProjectName + i.toString()}') ;
          firebase_storage.UploadTask uploadTask = ref.putFile(ImageList[i]);
          firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
          taskSnapshot.ref.getDownloadURL().then(
                  (value)async{

                await  _collectionReference.doc(ProjectName).update({
                  "ImageUrl":FieldValue.arrayUnion([value])
                });

              }
          );
        }

      }
      catch(e){
        print("error in UpdataProjectData function +${e.toString()}");
      }
    }

    Future imageDeleteOfProject(String url )async{
      print(url);
      try{
        final firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().storage.refFromURL(url);
        await firebaseStorageRef.delete();

        await FirebaseFirestore.instance.collection('Project').doc(ProjectName)
            .update({
          "ImageUrl":FieldValue.arrayRemove([url])
        });
      }
      catch(e){
        print(e.toString());
      }
    }



    Stream<ProjectNameList> get SINGLEPROJECT{
      // setListners();
      print(this.ProjectName);
      return _collectionReference.doc(ProjectName).snapshots().map(_projectname);
    }



    StreamController<List<InnerData>> _streamController = BehaviorSubject<List<InnerData>>();
    Stream<List<InnerData>> get STRUCTURESTREAM  =>_streamController.stream;

    void setListners ()async{
      List<InnerData> _inner  = [];
      final doc = await _collectionReference.doc(ProjectName).get();
      List<String> refs = List.from(doc.data()['Reference']).map((e) => e.toString()).toList();
    //  List<String> commercialrefs = List.from(doc.data()['CommercialReference']).map((e) => e.toString()).toList();
      // print(refs.toString());
      // print(refs.length);

      for(int i = 0;i<refs.length;i++){
        final docdata=  await  _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).get();
        // InnerData data =InnerData.of(refs[i],docdata);
        // _inner.add(data);
        _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).snapshots().listen((event) {
          InnerData _innerdata = InnerData.of(refs[i],event);
          _inner.insert(i, _innerdata);
          _streamController.sink.add(_inner);
          //  print(event.docs[1].id+"    ///  "+i.toString());
          // _streamController.sink.add(_inner);

        });


      }
      // for(int j = 0;j<commercialrefs.length;j++){
      //   final docdata=  await  _collectionReference.doc(ProjectName).collection(commercialrefs[j]).orderBy("Number",descending: false).get();
      //   InnerData data =InnerData.of(commercialrefs[j],docdata);
      //   _inner.add(data);
      //   _collectionReference.doc(ProjectName).collection(commercialrefs[j]).orderBy("Number",descending: false).snapshots().listen((event) {
      //     InnerData _innerdata = InnerData.of(commercialrefs[j],event);
      //     _inner.insert(j, _innerdata);
      //     _streamController.sink.add(_inner);
      //     //  print(event.docs[1].id+"    ///  "+i.toString());
      //
      //
      //   });
      //
      //
      // }

      //_streamController.sink.add(_inner);


    }

}


//
// // // new class //
//

