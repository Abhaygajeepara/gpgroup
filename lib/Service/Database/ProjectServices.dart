import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';

class ProjectsDatabaseService{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Project');

  Future createProject(List<CreateHousingStrctureModel> Structure,String projectName,List<String> rules)async{
    await  collectionReference.doc(projectName).set({
      'Rules':FieldValue.arrayUnion(rules)
    });
  for(int i =0;i <Structure.length;i++ ){
    for(int j= 0 ;j<Structure[i].totalhouse;j++){
      int housenumber = j+1;
  await    collectionReference.doc(projectName).collection(Structure[i].name).doc(housenumber.toString()).set({
        'Number':housenumber.toString()
      });
    }

  }
  }
}
