import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gpgroup/Model/Users/BrokerData.dart';

class ProjectsDatabaseService{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Project');
  final CollectionReference brokerReference = FirebaseFirestore.instance.collection('Broker');
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
    await collectionReference.doc(projectName).collection(res[i]).doc("demo").set({});



  }
  for(int i =0;i <structure.length;i++ ){
    structure[i].toMap();
    print(structure[i].toMap());
    await  collectionReference.doc(projectName).update({

      'Structure':FieldValue.arrayUnion([structure[i].toMap()]),
    });
    // for(int j= 0 ;j<structure[i].totalhouse;j++){
    //   int housenumber = j+1;
    //   customerAndStructureDetails(projectName, structure[i].name, housenumber.toString());
    //
    // }

  }
  }

  Future createApartmentStructure(BuildingStructureNumberModel structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
    await CreateProject(projectName, rules,'Apartment',landmark,address,description,ImageList);
    List<String> res = [];

    for(int i = 0;i<structure.floorsandflats['ListOfBuilding'].length;i++){
      res.add(structure.floorsandflats['ListOfBuilding'][i]);
    }
    res.sort((a,b)=>a.compareTo(b));
    await  collectionReference.doc(projectName).update({

      'Structure':FieldValue.arrayUnion([structure.floorsandflats]),
    });
    for(int i=0;i<res.length;i++){
      await  collectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([res[i]]),
      });
      await collectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
    }

  }

  Future createCommercialStructure(CommercialArcadeModel structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
    await CreateProject(projectName, rules,'CommercialArcade',landmark,address,description,ImageList);
    List<String> res = [];
    for(int i=0;i<structure.totalFloor;i++){
      res.add(i.toString());
    }
    for(int i = 0;i<res.length;i++){
      await collectionReference.doc(projectName).update({

        'Reference': FieldValue.arrayUnion(
            [res[i]]),
      });
      await collectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
    }

    await collectionReference.doc(projectName).update({

      'Structure': FieldValue.arrayUnion(
          [ structure.toMap()]),
    });

  }

  Future createMixeduseStructure(CommercialArcadeModel commercialStructure, List<BuildingStructureNumberModel> buildingStructure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async {
    await CreateProject(projectName, rules, 'Mixed-Use',landmark,address,description,ImageList);

   List<String> res = [];
  for(int i=0;i<commercialStructure.totalFloor;i++){
    await collectionReference.doc(projectName).update({

      'Structure': FieldValue.arrayUnion(
          [  commercialStructure.toMap()]),
    });
    res.add(i.toString());
  }

    for(int i=0;i<buildingStructure.length;i++){

      res.add(buildingStructure[i].floorsandflats['BuildingName']);
    }
      res.sort((a,b)=>a.compareTo(b));
    print(res);

    // store reference   in alphabetical order
for(int i = 0;i<res.length;i++){
  await collectionReference.doc(projectName).update({

    'Reference': FieldValue.arrayUnion(
        [res[i]]),
  });
  await collectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
}



   for(int k=0;k<buildingStructure.length;k++){

     await collectionReference.doc(projectName).update({

       'Structure': FieldValue.arrayUnion(
           [  buildingStructure[k].floorsandflats]),
     });
   }

  //   for (int i = 0; i < commercialStructure.length; i++) {
  //     String docname = commercialStructure[i].totalFloor.toString();
  //     // await collectionReference.doc(projectName).update({
  //     //
  //     //   'Reference': FieldValue.arrayUnion(
  //     //       [docname]),
  //     // });
  //     // for (int j = 0; j < commercialStructure[i].shops.length; j++) {
  //     //   String docname = commercialStructure[i].floorNumber.toString();
  //     //   customerAndStructureDetails(projectName, docname, commercialStructure[i].shops[j].toString());
  //     //
  //     // }
  //
  //     for(int i =0;i <buildingStructure.length;i++ ){
  //
  //       // await collectionReference.doc(projectName).update({
  //       //   'Reference':FieldValue.arrayUnion([buildingStructure[i].buildingName])
  //       // });
  //       for(int j=0;j<buildingStructure[i].floorsandflats.length;j++){
  //         for(int k=0;k<buildingStructure[i].floorsandflats[j].flats.length;k++){
  //           String docName = buildingStructure[i].floorsandflats[j].flats[k].toString();
  //           //customerAndStructureDetails(projectName, buildingStructure[i].buildingName, docName);
  //           // await    collectionReference.doc(projectName).collection(buildingStructure[i].buildingName).doc(docName).set({
  //           //   'Number':docName
  //           // });
  //         }
  //       }
  //   }
  // }
  }


  /////////////// new topics //////////////
  // Broker //
    Future brokerData (String uid ,String name ,int number,File image)async{

      try{
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref('/').child('/Broker/$uid') ;
        firebase_storage.UploadTask uploadTask = ref.putFile(image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value)async{
                  brokerReference.doc(uid).set({
                    "Id":uid.toString(),
                    "Name":name.toString(),
                    "PhoneNumber":number,
                    "ProfileUrl":value,
                    "IsActive":true,
                    "Password":"",

                  });


            }
        );

      }
      catch(e){
        print("Method name =  brokerData()");
        print(e.toString());
      }
    }

    Future<bool> brokerExist(String uid)async{
      try{
       final doc =  await brokerReference.doc(uid).get();
       if(doc.exists){
        return true;
       }
       else{
         print('fas;e');
         return false;
       }
      }
      catch(e){
        print(e.toString());
      }
    }



}
