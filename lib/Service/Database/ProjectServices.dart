import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProjectsDatabaseService{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Project');
  Future projectExist(String val)async{

    try{
      final doc = await collectionReference.doc(val.toLowerCase()).get();
      if(doc.data().length>0){
        return "Name Exist";
      }
      else{
        return null;
      }
    }
    catch(e){
      print(e.toString());
    }

  }

  Future CreateProject(String projectName,List<List<String>> rules,String typeofBuilding,String landmark,String address,String description,List<File> ImageList)async{
    await  collectionReference.doc(projectName).set({
      'EnglishRules':FieldValue.arrayUnion(rules[0]),
      'GujaratiRules':FieldValue.arrayUnion(rules[1]),
      'HindiRules':FieldValue.arrayUnion(rules[2]),
      'Reference':FieldValue.arrayUnion([]),
      'TypeofBuilding':typeofBuilding,
      "Landmark":landmark.toString(),
      "Address":address.toString(),
      "Description":description.toString(),

    });
    for(int i =0;i<ImageList.length;i++){
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/').child('/Images/$projectName/${projectName + i.toString()}') ;
      firebase_storage.UploadTask uploadTask = ref.putFile(ImageList[i]);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (value)async{

                await  collectionReference.doc(projectName).update({
                  "ImageUrl":FieldValue.arrayUnion([value])
                });

          }
      );
    }
  }

  Future customerAndStructureDetails(String projectName,String  innerCollection,String innerDocument,)async{
      try{
        await    collectionReference.doc(projectName).collection(innerCollection).doc(innerDocument.toString()).set({
          "Number":int.parse(innerDocument),// house or shop number
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
      catch(e)
    {
      print('function name is customerAndStructureDetails ');
      print(e.toString());
    }
  }

  Future createHousingStructure(List<CreateHousingStrctureModel> structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
  await CreateProject(projectName, rules,'Society',landmark,address,description,ImageList);
  List<String> res = [];
  for(int i = 0;i<structure.length;i++){
    res.add(structure[i].name);
  }
  res.sort((a,b)=>a.compareTo(b));
  for(int i=0;i<res.length;i++){
    await  collectionReference.doc(projectName).update({

      'Reference':FieldValue.arrayUnion([res[i]]),
    });
  }
  for(int i =0;i <structure.length;i++ ){
    // await  collectionReference.doc(projectName).update({
    //
    //   'Reference':FieldValue.arrayUnion([structure[i].name]),
    // });
    for(int j= 0 ;j<structure[i].totalhouse;j++){
      int housenumber = j+1;
      customerAndStructureDetails(projectName, structure[i].name, housenumber.toString());
  // await    collectionReference.doc(projectName).collection(structure[i].name).doc(housenumber.toString()).set({
  //       'Number':housenumber.toString()
  //     });
    }

  }
  }

  Future createApartmentStructure(List<BuildingStructureNumberModel> structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
    await CreateProject(projectName, rules,'Apartment',landmark,address,description,ImageList);
    List<String> res = [];
    for(int i = 0;i<structure.length;i++){
      res.add(structure[i].buildingName);
    }
    res.sort((a,b)=>a.compareTo(b));
    for(int i=0;i<res.length;i++){
      await  collectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([res[i]]),
      });
    }
    for(int i =0;i <structure.length;i++ ){

      // await collectionReference.doc(projectName).update({
      //   'Reference':FieldValue.arrayUnion([structure[i].buildingName])
      // });
      for(int j=0;j<structure[i].floorsandflats.length;j++){
        for(int k=0;k<structure[i].floorsandflats[j].flats.length;k++){
          // String docName = structure[i].buildingName+structure[i].floorsandflats[j].flats[k].toString();
          String docName = structure[i].floorsandflats[j].flats[k].toString();
          customerAndStructureDetails(projectName, structure[i].buildingName, docName.toString());
          // await    collectionReference.doc(projectName).collection(structure[i].buildingName).doc(docName).set({
          //   'Number':docName
          // });
        }
      }


    }
  }

  Future createCommercialStructure(List<CommercialArcadeModel> structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
    await CreateProject(projectName, rules,'CommercialArcade',landmark,address,description,ImageList);
    for(int i =0;i <structure.length;i++ ){
      await  collectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([structure[i].floorNumber.toString()]),
      });
      for(int j= 0 ;j<structure[i].shops.length;j++){
        customerAndStructureDetails(projectName, structure[i].floorNumber.toString(), structure[i].shops[j].toString());
        // await    collectionReference.doc(projectName).collection(structure[i].floorNumber.toString()).doc(structure[i].shops[j].toString()).set({
        //   'FlatNumber':structure[i].shops[j].toString()
        // });
      }

    }
  }

  Future createMixeduseStructure(List<CommercialArcadeModel> commercialStructure, List<BuildingStructureNumberModel> buildingStructure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async {
    await CreateProject(projectName, rules, 'Mixed-Use',landmark,address,description,ImageList);

   List<String> res = [];
  for(int i=0;i<commercialStructure.length;i++){
    res.add(commercialStructure[i].floorNumber.toString());
  }
    for(int i=0;i<buildingStructure.length;i++){
      res.add(buildingStructure[i].buildingName.toUpperCase().toString());
    }
      res.sort((a,b)=>a.compareTo(b));
    print(res);

    // store reference   in alphabetical order
for(int i = 0;i<res.length;i++){
  await collectionReference.doc(projectName).update({

    'Reference': FieldValue.arrayUnion(
        [res[i]]),
  });
}


    for (int i = 0; i < commercialStructure.length; i++) {
      String docname = commercialStructure[i].floorNumber.toString();
      // await collectionReference.doc(projectName).update({
      //
      //   'Reference': FieldValue.arrayUnion(
      //       [docname]),
      // });
      for (int j = 0; j < commercialStructure[i].shops.length; j++) {
        String docname = commercialStructure[i].floorNumber.toString();
        customerAndStructureDetails(projectName, docname, commercialStructure[i].shops[j].toString());
        
      }

      for(int i =0;i <buildingStructure.length;i++ ){

        // await collectionReference.doc(projectName).update({
        //   'Reference':FieldValue.arrayUnion([buildingStructure[i].buildingName])
        // });
        for(int j=0;j<buildingStructure[i].floorsandflats.length;j++){
          for(int k=0;k<buildingStructure[i].floorsandflats[j].flats.length;k++){
            String docName = buildingStructure[i].floorsandflats[j].flats[k].toString();
            customerAndStructureDetails(projectName, buildingStructure[i].buildingName, docName);
            // await    collectionReference.doc(projectName).collection(buildingStructure[i].buildingName).doc(docName).set({
            //   'Number':docName
            // });
          }
        }
    }
  }}



}
