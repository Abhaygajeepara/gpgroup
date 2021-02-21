import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';

import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:rxdart/subjects.dart';

class ProjectRetrieve{

String  ProjectName ;
String typeOfProject;

  setProjectName(String val,String projectType){
    this.ProjectName  = val;
    this.typeOfProject = projectType;

  }
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Project");
final CollectionReference brokerReference = FirebaseFirestore.instance.collection('Broker');
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
          Structure: List.from(e.data()['Structure']),
         imagesUrl : List.from(e.data()['ImageUrl']),



       );
     }).toList();
    }



 Stream<List<ProjectNameList>> get PROJECTNAMELIST{

   return FirebaseFirestore.instance.collection('Project').snapshots().map(_projectnamelist);
 }

    //CollectionReference _collectionReference = FirebaseFirestore.instance.collection('Project');

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
        Structure: List.from(e.data()['Structure']),
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


      for(int i = 0;i<refs.length;i++){

        final  _storeData =  await _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).get();
          InnerData _innerData = InnerData.of(refs[i], _storeData);
          _inner.add(_innerData);


      }



      for(int i = 0;i<refs.length;i++){

        // final docdata=  await  _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).get();

        _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).snapshots().listen((event) {

          InnerData _innerData = InnerData.of(refs[i], event);
          _inner.removeAt(i);
          _inner.insert(i, _innerData);
          _streamController.sink.add(_inner);

        });

        // for(int j = 0;j<refs.length;j++){
        //   print(_inner[j].name);
        // }
      }

    }

Future customerUploadData(String _collection,int _documents)async{

  try{
  final docDelete =  await _collectionReference.doc(ProjectName).collection(_collection).doc('demo').get();
  if(docDelete.exists)
    {
      await _collectionReference.doc(ProjectName).collection(_collection).doc('demo').delete();
    }
    final doc =   await _collectionReference.doc(ProjectName).collection(_collection).doc(_documents.toString()).get();

    if(!doc.exists){
    print(ProjectName);
    print(_collection);
    print(_documents);
    await _collectionReference.doc(ProjectName).collection(_collection).doc(_documents.toString()).set({
      "Number":_documents,// house or shop number
      "CustomerName":"",
      "PhoneNumber":0,
      "SquareFeet":0,
      "PricePerSquareFeet":0,
      "BookingDate":"0",
      "Reference":"0",
      "EMIDuration":0, // duration of emi
      "PerMonthEMI":0, // payable amount of properties per month
      "LoanReferenceCollection":"0", // reference of collection of loan
      'IsLoanOn':false
    });
    }
  }
  catch (e){
    print(e.toString());
  }
}

List<BrokerModel> _brokerModel(QuerySnapshot snapshot){
  return snapshot.docs.map((e) {
   return BrokerModel(
         id: e.data()['Id'],
       name: e.data()['Name'],
      number: e.data()['PhoneNumber'],
     image: e.data()['ProfileUrl'],
     isActiveUser: e.data()['IsActive'],
     password: e.data()['Password']
  );
  }).toList();
}

Stream<List<BrokerModel>> get BROKERDATA{
  return  brokerReference.orderBy('IsActive',descending: false).snapshots().map(_brokerModel);
  }



}



























//
// // // new class //
//

// StreamController<List<ApartMentInnerData>> _apartmemtController = BehaviorSubject<List<ApartMentInnerData>>();
// Stream<List<ApartMentInnerData>> get APARTMENTESTREAM  =>_apartmemtController.stream;
// void apartMentSetListners ()async{
//
//   List<ApartMentInnerData> _apartment  = [];
//   final doc = await _collectionReference.doc(ProjectName).get();
//   List<String> refs = List.from(doc.data()['Reference']).map((e) => e.toString()).toList();
//
//
//   for(int i = 0;i<refs.length;i++){
//     final docdata=  await  _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).get();
//     // InnerData data =InnerData.of(refs[i],docdata);
//     // _inner.add(data);
//     _collectionReference.doc(ProjectName).collection(refs[i]).orderBy("Number",descending: false).snapshots().listen((event) {
//       ApartMentInnerData _innerdata = ApartMentInnerData.of(refs[i],event);
//       _apartment.insert(i, _innerdata);
//       _apartmemtController.sink.add(_apartment);
//       //  print(event.docs[1].id+"    ///  "+i.toString());
//       // _streamController.sink.add(_inner);
//
//     });
//
//
//   }
//
//
// }
// StreamController<MixedUseStrcuture> _mixUsedStreamController = BehaviorSubject<MixedUseStrcuture>();
// Stream<MixedUseStrcuture> get MIXUSEDESTREAM  =>_mixUsedStreamController.stream;
// void MixedUse()async{
//   final doc = await _collectionReference.doc(ProjectName).get();
//   List<String> refs = List.from(doc.data()['Reference']).map((e) => e.toString()).toList();
//   refs.sort((a,b)=>a.toString().compareTo(b.toString()));
//   List<String> commercialList =List();
//   List<String> buildingList = List();
//   List<ApartMentInnerData> _apartment  = [];
//   List<InnerData> _inner  = [];
//   //int lastFloor ; // store value of last floor of commercial Structure
//   for(int i =0;i<refs.length;i++){
//     if(int.tryParse(refs[i]) != null){
//
//       commercialList.add(refs[i]);
//
//     }
//     else{
//       buildingList.add(refs[i]);
//     }
//   }
//
//   for(int i =0;i<commercialList.length;i++){
//
//     _collectionReference.doc(ProjectName).collection(commercialList[i]).orderBy("Number",descending: false).snapshots().listen((event) {
//       InnerData _innerdata = InnerData.of(refs[i],event);
//       _inner.insert(i, _innerdata);
//       _streamController.sink.add(_inner);
//     });
//   }
//   for(int j=0;j<buildingList.length;j++){
//     _collectionReference.doc(ProjectName).collection(buildingList[j]).orderBy("Number",descending: false).snapshots().listen((event) async{
//       ApartMentInnerData _innerdata = ApartMentInnerData.of(refs[j],event);
//       _apartment.insert(j, _innerdata);
//       _apartmemtController.sink.add(_apartment);
//     });
//   }
//
//
//
//   // MixedUseStrcuture mix =  MixedUseStrcuture.of(commercialList, buildingList);
//   //  _mixUsedStreamController.sink.add(mix);
//
//
//   // int predictedFloor =0;
//   // List<List<String>> _floor = [];
//   // List<String> flats = List();
//   // for(int k =lastFloor+1;k<refs.length;k++){
//   //   final docData = await _collectionReference.doc(ProjectName).collection(refs[k]).orderBy("Number",descending: false).get();
//   //     for(int i =0;i<docData.docs.length;i++){
//   //         int _predictedFloors = (int.parse(docData.docs[i].id)/100).round();
//   //         if(_predictedFloors != predictedFloor){
//   //
//   //           flats=[];
//   //         }
//   //           if(_predictedFloors == predictedFloor){
//   //
//   //             flats.add(docData.docs[i].id);
//   //           }
//   //           else{
//   //             predictedFloor = _predictedFloors;
//   //             _floor.add(flats);
//   //
//   //             flats.add(docData.docs[i].id);
//   //
//   //           }
//   //
//   //     }
//   //   print(_floor);
//   //
//   // }
//
// }
