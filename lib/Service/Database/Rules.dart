import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';

class CompanyRules{
  // Notes :: this class has functions and streams
  final CollectionReference _companyinfo = FirebaseFirestore.instance.collection('Info');


  // Future Function //
  // --Strat --//
  Future AddRules(String english,String gujarati,String hindi)async{
    try{
      final get = await _companyinfo.doc('Rules').get();
      if(get.exists){
        await _companyinfo.doc('Rules').update({
          'English':FieldValue.arrayUnion([english.toString()]),
          'Hindi':FieldValue.arrayUnion([hindi.toString()]),
          'Gujarati':FieldValue.arrayUnion([gujarati.toString()]),
        });
      }
      else{
        await _companyinfo.doc('Rules').set({
          'English':FieldValue.arrayUnion([english.toString()]),
          'Hindi':FieldValue.arrayUnion([hindi.toString()]),
          'Gujarati':FieldValue.arrayUnion([gujarati.toString()]),
        });
      }
    }
    on PlatformException catch (platformexception){
      print(platformexception.message.toString());
    }
    on FirebaseException catch(firebaseexception){
      print(firebaseexception.message.toString());
    }

  }


  // update rules

  // Future updateRules(String english,String gujarati,String hindi)async{
  //   try{
  //     final get = await _companyinfo.doc('Rules').get();
  //     await _companyinfo.doc('Rules').update({
  //       'English':FieldValue.arrayUnion([english.toString()]),
  //       'Hindi':FieldValue.arrayUnion([hindi.toString()]),
  //       'Gujarati':FieldValue.arrayUnion([gujarati.toString()]),
  //     });
  //   }
  //   on PlatformException catch (platformexception){
  //     print(platformexception.message.toString());
  //   }
  //   on FirebaseException catch(firebaseexception){
  //     print(firebaseexception.message.toString());
  //   }
  //
  // }

  Future deleteRules(String english,String hindi,String gujarati)async{
    try{
    await _companyinfo.doc('Rules').update({
      'English':FieldValue.arrayRemove([english.toString()]),
      'Hindi':FieldValue.arrayRemove([hindi.toString()]),
      'Gujarati':FieldValue.arrayRemove([gujarati.toString()]),
    });
    }on PlatformException catch (platformexception){
      print(platformexception.message.toString());
    }
    on FirebaseException catch(firebaseexception){
      print(firebaseexception.message.toString());
    }
  }
// --End --//
 // ---Model Class function -//
RulesModel _rulesModel(DocumentSnapshot snapshot){

  return  RulesModel(english: List.from(snapshot.data()['English']), hindi: List.from(snapshot.data()['Hindi']), gujarati: List.from(snapshot.data()['Gujarati']));
}

//--end  model class function--

  // Streams
  Stream<RulesModel> get RULESDATA{
    return _companyinfo.doc('Rules').snapshots().map(_rulesModel);
  }


}