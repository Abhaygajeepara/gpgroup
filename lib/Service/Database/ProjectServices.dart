import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';

class ProjectsDatabaseService{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Project');

  Future CreateProject(String projectName,List<List<String>> rules,String typeofBuilding)async{
    await  collectionReference.doc(projectName).set({
      'EnglishRules':FieldValue.arrayUnion(rules[0]),
      'GujaratiRules':FieldValue.arrayUnion(rules[1]),
      'HindiRules':FieldValue.arrayUnion(rules[2]),
      'Reference':FieldValue.arrayUnion([]),
      'TypeofBuilding':typeofBuilding
    });
  }

  Future createHousingStructure(List<CreateHousingStrctureModel> structure,String projectName,List<List<String>> rules)async{
  await CreateProject(projectName, rules,'Society');
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

  Future createApartmentStructure(List<BuildingStructureNumberModel> structure,String projectName,List<List<String>> rules)async{
    await CreateProject(projectName, rules,'Apartment');
    for(int i =0;i <structure.length;i++ ){

      await collectionReference.doc(projectName).update({
        'Reference':FieldValue.arrayUnion([structure[i].buildingName])
      });
      for(int j=0;j<structure[i].floorsandflats.length;j++){
        for(int k=0;k<structure[i].floorsandflats[j].flats.length;k++){
          String docName = structure[i].buildingName+structure[i].floorsandflats[j].flats[k].toString();
          await    collectionReference.doc(projectName).collection(structure[i].buildingName).doc(docName).set({
            'Number':docName
          });
        }
      }
      // await  collectionReference.doc(projectName).update({
      //
      //   'Reference':FieldValue.arrayUnion([structure[i].floorNumber]),
      // });
      // for(int j= 0 ;j<structure[i].flats.length;j++){
      //
      //   await    collectionReference.doc(projectName).collection(structure[i].floorNumber.toString()).doc(structure[i].flats[j].toString()).set({
      //     'FlatNumber':structure[i].flats[j].toString()
      //   });
      // }

    }
  }

  Future createCommercialStructure(List<CommercialArcadeModel> structure,String projectName,List<List<String>> rules)async{
    await CreateProject(projectName, rules,'CommercialArcade ');
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

  Future createMixeduseStructure(List<CommercialArcadeModel> commercialStructure, List<BuildingStructureNumberModel> buildingStructure,String projectName,List<List<String>> rules)async {
    await CreateProject(projectName, rules, 'Mixed-Use ');
    for (int i = 0; i < commercialStructure.length; i++) {
      String docname = "Commercial"+commercialStructure[i].floorNumber.toString();
      await collectionReference.doc(projectName).update({

        'Reference': FieldValue.arrayUnion(
            [docname]),
      });
      for (int j = 0; j < commercialStructure[i].shops.length; j++) {
        String docname = "Commercial"+commercialStructure[i].floorNumber.toString();
        await collectionReference.doc(projectName).collection(
            docname).doc(
            commercialStructure[i].shops[j].toString()).set({
          'FlatNumber': commercialStructure[i].shops[j].toString()
        });
      }
      for(int i =0;i <buildingStructure.length;i++ ){

        await collectionReference.doc(projectName).update({
          'Reference':FieldValue.arrayUnion([buildingStructure[i].buildingName])
        });
        for(int j=0;j<buildingStructure[i].floorsandflats.length;j++){
          for(int k=0;k<buildingStructure[i].floorsandflats[j].flats.length;k++){
            String docName = buildingStructure[i].buildingName+buildingStructure[i].floorsandflats[j].flats[k].toString();
            await    collectionReference.doc(projectName).collection(buildingStructure[i].buildingName).doc(docName).set({
              'Number':docName
            });
          }
        }
    }
  }}
}
