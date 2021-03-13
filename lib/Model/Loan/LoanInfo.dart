import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
class SinglePropertiesLoanInfo{
  int emiId; // which emi
  Timestamp installmentDate;
  bool emiPending;
  String typeOfPaymentl;
  String ifsc;
  String  upiId;
  String bankAccountNumber;
  String payerName;
  String receiverName;
  String relation;
  int amount;


  SinglePropertiesLoanInfo({
    @required  this.emiId,
  @required this.installmentDate,
    @required this.emiPending,
    @required this.typeOfPaymentl,
    @required this.ifsc,
    @required this.upiId,
    @required  this.bankAccountNumber,
    @required  this.payerName,
    @required this.receiverName,
  @required this.relation,
    @required this.amount,

  });
  factory SinglePropertiesLoanInfo.of(DocumentSnapshot snapshot){
    print(snapshot['InstallmentDate']);
    return  SinglePropertiesLoanInfo(
      emiId: int.parse(snapshot.id),
      installmentDate: snapshot['InstallmentDate'],
      emiPending: snapshot['EMIPending'],
      typeOfPaymentl: snapshot['TypeOfPayment'],
      ifsc: snapshot['IFSC'],
      upiId: snapshot['UPIID'],
      bankAccountNumber: snapshot['BankAccountNumber'],
      payerName: snapshot['PayerName'],
      receiverName: snapshot['ReceiverName'],
      relation: snapshot['Relation'],
      amount: snapshot['Amount'],



    );
  }

}
// filed in database
// "InstallmentDate":_emi[i],
// "EMIPending":true,
// "TypeOfPayment":"",
// "IFSC":"",
// "UPIID":"",
// "BankAccountNumber":"",
// 'PayerName':"",
// "ReceiverName":"",
// "Relation":"",
// "Amount":0