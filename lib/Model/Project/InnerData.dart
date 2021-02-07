import 'package:cloud_firestore/cloud_firestore.dart';

class InnerData{
  String name; // structure number
  List<CustomerData> cusList;

  InnerData({this.name,this.cusList});
  factory InnerData.of(String nameOfStructure,QuerySnapshot snapshot){
    List<CustomerData> cusLists = [];

      for(int i  =0;i<snapshot.docs.length;i++){
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