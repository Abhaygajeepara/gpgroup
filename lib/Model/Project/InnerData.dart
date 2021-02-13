import 'package:cloud_firestore/cloud_firestore.dart';

class InnerData{
  String name; // structure number
  List<CustomerData> cusList;

  InnerData({this.name,this.cusList});
  factory InnerData.of(String nameOfStructure,QuerySnapshot snapshot){
    List<CustomerData> cusLists = [];

      for(int i  =0;i<snapshot.docs.length;i++){
        //print(snapshot.docs[i].id);
         // CustomerData data= CustomerData.of(snapshot.docs[i].data());
          cusLists.add(CustomerData.of(snapshot.docs[i]));
      }
    return InnerData(
        name: nameOfStructure.toString(),
      cusList: cusLists
    );
  }
}

class CustomerData{
  String id;
  String cusBookingDate;//TODO change to Date
  String customerName;
  int emiDuration;
  bool isLoanOn;
  String loanReferenceCollectionName;
  int perMonthEmi;
  int phoneNumber;
  int pricePerSquareFeet;
  String reference;
  int squareFeet;



  CustomerData({
    this.id,
    this.cusBookingDate,
    this.customerName,
    this.emiDuration,
    this.isLoanOn,
    this.loanReferenceCollectionName,
    this.perMonthEmi,
    this.phoneNumber,
    this.pricePerSquareFeet,
    this.reference,
    this.squareFeet
  });
  factory  CustomerData.of(DocumentSnapshot snap){

      return  CustomerData(
        id: snap.id.toString(),
           cusBookingDate:snap['BookingDate'],
       customerName:snap['CustomerName'],
          emiDuration:snap['EMIDuration'],
       isLoanOn:snap['IsLoanOn'],
           loanReferenceCollectionName:snap['LoanReferenceCollection'],
           perMonthEmi:snap['PerMonthEMI'],
           phoneNumber:snap['PhoneNumber'],
           pricePerSquareFeet:snap['PricePerSquareFeet'],
       reference:snap['Reference'],
       squareFeet:snap['SquareFeet'],

      );
  }

}


class ApartMentInnerData{
  String name; // structure number
  List<FlatsPerFloor> numberOfFlats;

  ApartMentInnerData({this.name,this.numberOfFlats});
  factory ApartMentInnerData.of(String nameOfStructure,QuerySnapshot snapshot){
    List<List<DocumentSnapshot>> flatsList = [];
    List<FlatsPerFloor> flatsPerFloorList = [];

    int maxFloor = (int.parse(snapshot.docs.last.id)/100).round();
    for(int i=0;i<maxFloor;i++) {
      flatsList.add([]);
    }

    // List<List<String>> _floor =[];
    // List<String> _flats = List();


  // int predictedFloor =0;
  for(int i =0;i<snapshot.docs.length;i++){
    // print('i: $i, length: ${snapshot.docs.length}');
    int currentFloor = (int.parse(snapshot.docs[i].id)/100).round()-1;
    flatsList[currentFloor].add(snapshot.docs[i]);
      // if(currentFloor != predictedFloor){
      //
      //   print("change = ${i}");
      //
      //   _flats =[];
      //   flatsList=[];
      // }
      // if (predictedFloor ==  currentFloor){
      //   print("same = ${i}");
      //   _flats.add(snapshot.docs[i].id);
      //   flatsList.add(snapshot.docs[i]);
      //   print(flatsList);
      // }
      // else{
      //   // print("same = ${i}");
      //
      //   predictedFloor = currentFloor;
      //
      //   _floor.add(_flats);
      //
      //
      //   _flats.add(snapshot.docs[i].id);
      // }




  }

  for(int i=0;i<flatsList.length;i++) {
    flatsPerFloorList.add(FlatsPerFloor.of(flatsList[i]));
  }
 // print(_floor);

    // int flatPerFloor =int.parse(snapshot.docs.last.id.substring(snapshot.docs.last.id.length-1));
    // double predictedFloor = snapshot.docs.length / flatPerFloor;
    // int numberFlorr = predictedFloor.toInt();
    // // List<CustomerData> innerdata;
    // int start =0;
    // int end =flatPerFloor;
    // for( int i=0;i<numberFlorr;i++){
    //   flatsList =[];
    //   for(int j = start; j<end; j++){
    //     flatsList.add(snapshot.docs[j]);
    //   }
    //   start  = end;
    //   end =  end+flatPerFloor;
    //   flatsPerFloorList.add(FlatsPerFloor.of(flatsList));
    // }

    return ApartMentInnerData(
        name: nameOfStructure.toString(),
        numberOfFlats: flatsPerFloorList
    );
  }
}
class FlatsPerFloor{
  List<CustomerData> cusLists;
  FlatsPerFloor({this.cusLists});
  factory FlatsPerFloor.of(List<DocumentSnapshot> flats){
    List<CustomerData> cusLists = [];
    for(int i  =0;i<flats.length;i++){
      // CustomerData data= CustomerData.of(snapshot.docs[i].data());
      cusLists.add(CustomerData.of(flats[i]));
    }
    return FlatsPerFloor(
      cusLists: cusLists
    );
  }


}


class MixedUseStrcuture{
  List<InnerData> commercialList;
  List<MixedUsedApartment> mixapartmentList;
  MixedUseStrcuture({this.commercialList,this.mixapartmentList});
  factory MixedUseStrcuture.of(List<QuerySnapshot>  commercialRefs,List<QuerySnapshot> buildingRef){

    List<InnerData> _commercialList = List();
    List<MixedUsedApartment> _mixapartmentList=List();
    for(int i =0;i<commercialRefs.length;i++){
      _commercialList.add(InnerData.of('s', commercialRefs[i]));

    }
    print(buildingRef.length);
    for(int j=0;j<buildingRef.length ;j++){
      _mixapartmentList.add(MixedUsedApartment.of('s', buildingRef[j]));
    }
    return MixedUseStrcuture(
    commercialList: _commercialList,
      mixapartmentList: _mixapartmentList

    );
  }
}
class MixedUsedApartment{
  String apartmentName;
  List<FlatsPerFloor> flatsPerFloor;
  MixedUsedApartment({this.apartmentName,this.flatsPerFloor});
  MixedUsedApartment.of(String buildingName,QuerySnapshot snapshot){
      // print(buildingName);
      // print(snapshot.docs.first.id);
  }
}