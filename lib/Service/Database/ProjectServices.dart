import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsDatabaseService{


  final CollectionReference collectionCollectionReference = FirebaseFirestore.instance.collection('Project');
  final CollectionReference customerCollectionReference = FirebaseFirestore.instance.collection('Customer');
  final CollectionReference brokerCollectionReference = FirebaseFirestore.instance.collection('Broker');
  Future projectExist(String val)async{

    try{
      final doc = await collectionCollectionReference.doc(val.toLowerCase()).get();
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
    await  collectionCollectionReference.doc(projectName).set({
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

                await  collectionCollectionReference.doc(projectName).update({
                  "ImageUrl":FieldValue.arrayUnion([value])
                });

          }
      );
    }

  }

  Future<DocumentSnapshot> customerExist(String number)async{
    // number is id of customer
    final doc = await customerCollectionReference.doc(number).get();
    return doc;
    // if(doc.exists){
    //   return true;
    // }
    // else{
    //   return false;
    // }

  }
  Future addNewCustomer(String projectName,String  innerCollection,String allocatedNumber,
      String customerName,int cusPhoneNumber,int squareFeet,int pricePerSquareFeet,
      Timestamp bookingDate,Timestamp  startingDateOfLoan,String brokerReference,int emiDuration,int perMonthEMI,List<Timestamp> _emi,int brokerCommission
      )async{
    String loanId="(000)$projectName-$innerCollection-$allocatedNumber";
    // String propertiesId= "$projectName/$innerCollection/$allocatedNumber";
    // allocatedNumber = flats or shop or house number
      try{
        final docDelete =  await collectionCollectionReference.doc(projectName).collection(innerCollection).doc('demo').get();
        if(docDelete.exists)
        {
          await collectionCollectionReference.doc(projectName).collection(innerCollection).doc('demo').delete();
        }
        await customerCollectionReference.doc(cusPhoneNumber.toString()).set({
          "CustomerName":customerName,
          "cusPhoneNumber":cusPhoneNumber,
          "Properties":FieldValue.arrayUnion(['${projectName}/${innerCollection}/${allocatedNumber}'])
        });




        addPropertiesData(projectName, innerCollection, allocatedNumber, customerName, cusPhoneNumber, squareFeet, pricePerSquareFeet, bookingDate, startingDateOfLoan, brokerReference, emiDuration, perMonthEMI, _emi, loanId,brokerCommission);
        emiCount(projectName, innerCollection, allocatedNumber, cusPhoneNumber, squareFeet, pricePerSquareFeet, bookingDate, startingDateOfLoan, brokerReference, emiDuration, perMonthEMI, _emi, loanId,brokerCommission);
        addCommissionDetails(projectName, innerCollection, allocatedNumber, cusPhoneNumber, brokerReference, brokerCommission, loanId);
      }
      catch(e)
    {
      print('function name is customerAndStructureDetails ');
      print(e.toString());
    }
  }


  Future existingCustomer(String projectName,String  innerCollection,String allocatedNumber,
      int cusPhoneNumber,int squareFeet,int pricePerSquareFeet,
      Timestamp bookingDate,Timestamp startingDateOfLoan,String brokerReference,int emiDuration,int perMonthEMI,List<Timestamp> _emi
      ,int brokerCommission
      )async{
    String loanId="(000)$projectName-$innerCollection-$allocatedNumber";

    // allocatedNumber = flats or shop or house number
    try{



      final docDelete =  await collectionCollectionReference.doc(projectName).collection(innerCollection).doc('demo').get();
      if(docDelete.exists)
      {
        await collectionCollectionReference.doc(projectName).collection(innerCollection).doc('demo').delete();
      }
      await customerCollectionReference.doc(cusPhoneNumber.toString()).update({

        "Properties":FieldValue.arrayUnion(['${projectName}/${innerCollection}/${allocatedNumber}'])
      });

      final cusIno = await customerCollectionReference.doc(cusPhoneNumber.toString()).get();
      String customerName =  cusIno['CustomerName'];

      addPropertiesData(projectName, innerCollection, allocatedNumber, customerName, cusPhoneNumber, squareFeet, pricePerSquareFeet, bookingDate, startingDateOfLoan, brokerReference, emiDuration, perMonthEMI, _emi, loanId,brokerCommission);
     emiCount(projectName, innerCollection, allocatedNumber, cusPhoneNumber, squareFeet, pricePerSquareFeet, bookingDate, startingDateOfLoan, brokerReference, emiDuration, perMonthEMI, _emi, loanId,brokerCommission);
    addCommissionDetails(projectName, innerCollection, allocatedNumber, cusPhoneNumber, brokerReference, brokerCommission, loanId);
    }
    catch(e)
    {
      print('function name is customerAndStructureDetails ');
      print(e.toString());
    }
  }



  Future emiCount (
      String projectName,String  innerCollection,String allocatedNumber,
      int cusPhoneNumber,int squareFeet,int pricePerSquareFeet,
      Timestamp bookingDate,Timestamp startingDateOfLoan,String brokerReference,
      int emiDuration,int perMonthEMI,List<Timestamp> _emi,
      String loanId,int brokerCommission
      )async{


    String propertiesId=  "$projectName/$innerCollection/$allocatedNumber";
 final _projectDocInLaon =    await FirebaseFirestore.instance.collection("Loan").doc(projectName).get();
 if(_projectDocInLaon.exists){
   await FirebaseFirestore.instance.collection("Loan").doc(projectName).update({
     "CollectionData":FieldValue.arrayUnion([loanId])
   });
 }
 else{
   await FirebaseFirestore.instance.collection("Loan").doc(projectName).set({
     "CollectionData":FieldValue.arrayUnion([loanId])
   });
 }
    await FirebaseFirestore.instance.collection("Loan").doc(projectName).collection(loanId).doc('BasicDetails').set({
      "SquareFeet":squareFeet,
      "PricePerSquareFeet":pricePerSquareFeet,
      "LoanStartingDate":startingDateOfLoan,
      'LoanEndingDate':_emi.last,
      "BookingDate":bookingDate,
      "BrokerReference":brokerReference,
      "CustomerId":cusPhoneNumber,
      "BrokerCommission":brokerCommission,
      "EMIDuration":emiDuration, // duration of emi
      "PerMonthEMI":perMonthEMI,
      "ProjectName":propertiesId,
      'CompletedEMI':FieldValue.arrayUnion([]),
      "RemainingEMI":_emi


    });

    for(int i=0;i<_emi.length;i++){
      await FirebaseFirestore.instance.collection("Loan").doc(projectName).collection(loanId).doc((i+1).toString()).set({

        "InstallmentDate":_emi[i],
        "EMIPending":true,
        "TypeOfPayment":"",
        "IFSC":"",
        "UPIID":"",
        "BankAccountNumber":"",
        'PayerName':"",
        "ReceiverName":"",
        "Relation":"",
        "Amount":0,
       // "IsEMI":true

      });
    }

  }

  Future addPropertiesData(String projectName,String  innerCollection,String allocatedNumber,
      String customerName,
      int cusPhoneNumber,int squareFeet,int pricePerSquareFeet,
      Timestamp bookingDate,Timestamp startingDateOfLoan,String brokerReference,
      int emiDuration,int perMonthEMI,List<Timestamp> _emi,
      String loanId,int brokerCommission )async{
    Map<String,dynamic> _customerData = {};
         _customerData =  {"CustomerId":cusPhoneNumber.toString(),"LoanId":loanId};
         print(_customerData);
    await    collectionCollectionReference.doc(projectName).collection(innerCollection).doc(allocatedNumber.toString()).set({
      "Number":int.parse(allocatedNumber),// house or shop number
      "SquareFeet":squareFeet,
      "PricePerSquareFeet":pricePerSquareFeet,
      "BookingDate":bookingDate,
      "StartDate":startingDateOfLoan,
      'LoanEndingDate':_emi.last,
      "BrokerReference":brokerReference,
      "BrokerCommission":brokerCommission,
      "EMIDuration":emiDuration, //
      "PerMonthEMI":perMonthEMI,
      'CustomerId':cusPhoneNumber.toString(),
      "CustomerName":customerName,
      "LoanReferenceCollection":loanId, // reference of collection of loan
      'IsLoanOn':true,
      "AllCustomer":FieldValue.arrayUnion([_customerData])
    });
  }

  Future addCommissionDetails(String projectName,String  innerCollection,String allocatedNumber,
     int cusPhoneNumber, String brokerReference,int brokerCommission,String loanId){
    try{
      if(brokerReference != null ||brokerReference != ''){
        brokerCollectionReference.doc(brokerReference).collection('Commission').doc(loanId).set({
          "LoanId":loanId,
          "Property":"${projectName}/${innerCollection}/${allocatedNumber}",
          "Commission":brokerCommission,
          "CustomerId":cusPhoneNumber,



        });
      }
    }
    catch (e){
      print("Erro in addCommissionDetails");
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
    await  collectionCollectionReference.doc(projectName).update({

      'Reference':FieldValue.arrayUnion([res[i]]),
    });
    await collectionCollectionReference.doc(projectName).collection(res[i]).doc("demo").set({});



  }
  for(int i =0;i <structure.length;i++ ){
    structure[i].toMap();
    print(structure[i].toMap());
    await  collectionCollectionReference.doc(projectName).update({

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
    await  collectionCollectionReference.doc(projectName).update({

      'Structure':FieldValue.arrayUnion([structure.floorsandflats]),
    });
    for(int i=0;i<res.length;i++){
      await  collectionCollectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([res[i]]),
      });
      await collectionCollectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
    }

  }

  Future createCommercialStructure(CommercialArcadeModel structure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async{
    await CreateProject(projectName, rules,'CommercialArcade',landmark,address,description,ImageList);
    List<String> res = [];
    for(int i=0;i<structure.totalFloor;i++){
      res.add(i.toString());
    }
    for(int i = 0;i<res.length;i++){
      await collectionCollectionReference.doc(projectName).update({

        'Reference': FieldValue.arrayUnion(
            [res[i]]),
      });
      await collectionCollectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
    }

    await collectionCollectionReference.doc(projectName).update({

      'Structure': FieldValue.arrayUnion(
          [ structure.toMap()]),
    });

  }

  Future createMixeduseStructure(CommercialArcadeModel commercialStructure, List<BuildingStructureNumberModel> buildingStructure,String projectName,List<List<String>> rules,String landmark,String address,String description,List<File> ImageList)async {
    await CreateProject(projectName, rules, 'Mixed-Use',landmark,address,description,ImageList);

   List<String> res = [];
  for(int i=0;i<commercialStructure.totalFloor;i++){
    await collectionCollectionReference.doc(projectName).update({

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
  await collectionCollectionReference.doc(projectName).update({

    'Reference': FieldValue.arrayUnion(
        [res[i]]),
  });
  await collectionCollectionReference.doc(projectName).collection(res[i]).doc("demo").set({});
}



   for(int k=0;k<buildingStructure.length;k++){

     await collectionCollectionReference.doc(projectName).update({

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
    Future addBrokerData (String uid ,String name ,int number,int alertNativeNumber,File image,String password)async{

      try{
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref('/').child('/Broker/$uid') ;
        firebase_storage.UploadTask uploadTask = ref.putFile(image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value)async{
                  brokerCollectionReference.doc(uid).set({
                    "Id":uid.toString(),
                    "Name":name.toString(),
                    "PhoneNumber":number,
                    "AlterNativeNumber":alertNativeNumber,
                    "ProfileUrl":value,
                    "IsActive":true,
                    "Password":password,
                    "RemainingEMI":FieldValue.arrayUnion([])

                  });


            }
        );

      }
      catch(e){
        print("Method name =  brokerData()");
        print(e.toString());
      }
    }
  Future updateBrokerData (String uid ,String name ,int number,int alterNativeNumber,File image,String password,bool isActive,String imageUrl)async{

    try{
      if(image == ""||image == null){
        brokerCollectionReference.doc(uid).update({

          "Name":name.toString(),
          "PhoneNumber":number,
          "AlterNativeNumber":alterNativeNumber,
          "ProfileUrl":imageUrl,
          "IsActive":isActive,
          "Password":password,


        });
      }
      else{
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref('/').child('/Broker/$uid') ;
        firebase_storage.UploadTask uploadTask = ref.putFile(image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value)async{
              brokerCollectionReference.doc(uid).update({

                "Name":name.toString(),
                "PhoneNumber":number,
                "ProfileUrl":value,
                "IsActive":true,
                "Password":password,


              });


            }
        );
      }

    }
    catch(e){
      print("Method name =  brokerData()");
      print(e.toString());
    }
  }

    Future<bool> brokerExist(String uid)async{
      try{
       final doc =  await brokerCollectionReference.doc(uid).get();
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

Future calculateLoan(){}

}
