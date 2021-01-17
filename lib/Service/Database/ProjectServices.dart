import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';

class ProjectsDatabaseService{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Project');

  Future createHousingStructure(List<CreateHousingStrctureModel> structure,String projectName,List<String> rules)async{
    await  collectionReference.doc(projectName).set({
      'Rules':FieldValue.arrayUnion(rules),
      'Reference':FieldValue.arrayUnion([]),
    });
  for(int i =0;i <structure.length;i++ ){
    await  collectionReference.doc(projectName).update({

      'Reference':FieldValue.arrayUnion([structure[i].name]),
    });
    for(int j= 0 ;j<structure[i].totalhouse;j++){
      int housenumber = j+1;
  await    collectionReference.doc(projectName).collection(structure[i].name).doc(housenumber.toString()).set({
        'Number':housenumber.toString()
      });
    }

  }
  }

  Future createBuildingStructure(List<BuildingStructureModel> structure,String projectName,List<String> rules)async{
    await  collectionReference.doc(projectName).set({
      'Rules':FieldValue.arrayUnion(rules),
      'Reference':FieldValue.arrayUnion([]),
    });
    for(int i =0;i <structure.length;i++ ){
      await  collectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([structure[i].floorNumber]),
      });
      for(int j= 0 ;j<structure[i].flats.length;j++){

        await    collectionReference.doc(projectName).collection(structure[i].floorNumber.toString()).doc(structure[i].flats[j].toString()).set({
          'FlatNumber':structure[i].flats[j].toString()
        });
      }

    }
  }

  Future createCommercialStructure(List<CommercialArcadeModel> structure,String projectName,List<String> rules)async{
    await  collectionReference.doc(projectName).set({
      'Rules':FieldValue.arrayUnion(rules),
      'Reference':FieldValue.arrayUnion([]),
    });
    for(int i =0;i <structure.length;i++ ){
      await  collectionReference.doc(projectName).update({

        'Reference':FieldValue.arrayUnion([structure[i].floorNumber]),
      });
      for(int j= 0 ;j<structure[i].shops.length;j++){

        await    collectionReference.doc(projectName).collection(structure[i].floorNumber.toString()).doc(structure[i].shops[j].toString()).set({
          'FlatNumber':structure[i].shops[j].toString()
        });
      }

    }
  }

}
