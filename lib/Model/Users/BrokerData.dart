import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  BrokerModel{
  String id;
  String name;
  int number;
  int alterNativeNumber;
  String image;
  bool isActiveUser;
  String password;
  BrokerModel({
    @required this.id,
    @required this.name,
  @required this.number,
    @required this.alterNativeNumber,
    @required  this.image,
    @required this.password,
    @required  this.isActiveUser});

    factory BrokerModel.of(DocumentSnapshot snapshot ){
      return BrokerModel(
          id: snapshot.data()['Id'],
          name: snapshot.data()['Name'],
          number: snapshot.data()['PhoneNumber'],
          alterNativeNumber: snapshot.data()['AlterNativeNumber'],
          image: snapshot.data()['ProfileUrl'],
          isActiveUser: snapshot.data()['IsActive'],
          password: snapshot.data()['Password']
      );
    }
}
class BrokerSaleDetails{
  String month ;
  Timestamp emiMonthTimestamp;
  List<Map<String,dynamic>> clientData;
  BrokerSaleDetails({
    @required this.clientData,
    @required this.month,
    @required this.emiMonthTimestamp,
});
  factory BrokerSaleDetails.of(DocumentSnapshot snapshot){
    return BrokerSaleDetails(
       clientData: List.from(snapshot.data()['Commission']),
      month: snapshot.id,
      emiMonthTimestamp: snapshot.data()['MonthTimeStamp']
    );
  }
}
// fields of database
// "LoanId":loanId,
// "Property":"${projectName}/${innerCollection}/${allocatedNumber}",
// "Commission":brokerageList[i],
// "CustomerId":cusPhoneNumber,
// "BookingDate":bookingDate,
// "EMIDate":_emi[i],
// "CustomerName":customerName,
// "IsPay":false,