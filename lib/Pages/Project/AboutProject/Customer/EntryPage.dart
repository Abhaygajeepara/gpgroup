import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:intl/intl.dart';

// Notes there are two class
 

class FirstTimeCustomerEntry extends StatefulWidget {
  String projectName;
  String innerCollection;// building or floor
  List<Map<String,String>> brokerList ;
  int allocatedNumber ;
  FirstTimeCustomerEntry({@required this.brokerList,@required this.projectName,@required this.innerCollection
  ,@required this.allocatedNumber
  });
  @override
  _FirstTimeCustomerEntryState createState() => _FirstTimeCustomerEntryState();
}

class _FirstTimeCustomerEntryState extends State<FirstTimeCustomerEntry> {
  final  _formKey = GlobalKey<FormState>();

  final _formkeyNew = GlobalKey<FormState>();
  String id;
  Timestamp cusBookingDate = Timestamp.now();
  Timestamp loanStaring  = Timestamp.now();
    int pageNumber =0;// for page
  String customerName;
  int emiDuration=0;
  bool isLoanOn;
  String loanReferenceCollectionName;
  double perMonthEmi;
  bool isCalculate = false;
  int phoneNumber;
  int pricePerSquareFeet=0;
  List<Timestamp> _EmiDate;
  List<int> commissionList=[];
 List<Map<String ,dynamic>> commissionPeriod =[];
  int squareFeet=0;
  String selectedBroker ;
  bool isExistUser =false; // for existing user
  bool isUser =true;// new user
  bool loading = false;
  // int firstEmiCommissionPercentage;
   int firstCommissionRupee;
  // bool firstCommissionPercentage = true;
  int averageCommissionRupee;
  int averageCommissionOfBroker = 0;
  int finalCommissionRupee;
  List<int> brokerageList =[];
  int remainingBrokerage = 0;
  // int middleEmiCommissionPercentage;
  // bool middleCommissionPercentage = false;
  //  int lastBrokerage=0;
  int commissionPercentage= 0;
  int commissionRupee = 0;
  int totalCommission = 0;
  bool isPercentage = true;
  List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  String  selectedCommissionType;
  List<String> commissionType = ["(%)","(₹)"];
  DocumentSnapshot customerData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  if(widget.brokerList.isEmpty){
    selectedBroker = "";

  }
  else{
     selectedBroker = widget.brokerList[0]['Id']; // give error when Broker collection is not available
  }
    selectedCommissionType = commissionType[0];
  }

  Future ISExistCustomer()async{
    final doc = await  ProjectsDatabaseService().customerExist(phoneNumber.toString());
    final result = doc.exists;

    if(result == true){
      setState(() {
        isUser = true;
        isExistUser = true;
        customerData = doc;
      });
    }
    else{
      setState(() {
        isUser  = false;
        isExistUser  = false;
        customerData = null;
      });
    }

  }

  Future<Timestamp> _selectDate(BuildContext context) async {

    DateTime _currentOnlyTime = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,

        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != cusBookingDate){
      DateTime _demo =DateTime(picked.year,picked.month,picked.day,_currentOnlyTime.hour,_currentOnlyTime.minute,_currentOnlyTime.second);
      Timestamp _local = Timestamp.fromDate(_demo);
      return _local;
    }
    return cusBookingDate;


      // setState(() {
      //   cusBookingDate = _local;
      // });
  }
  void calculate(){
    //print('herre');

    if(emiDuration > 0 && pricePerSquareFeet > 0 && squareFeet > 0 ){
      setState(() {
        isCalculate = true;
        perMonthEmi = (pricePerSquareFeet * squareFeet) /emiDuration;
        if(isPercentage){
         double _lastCommission= (((pricePerSquareFeet * squareFeet) *commissionPercentage) /100);
        totalCommission = _lastCommission.round();
        }
        else{
          totalCommission = commissionRupee;
        }
        //print( 'finalCommission = ${totalCommission}');
      });

    }
    else{
      setState(() {
        isCalculate = false;

      });
    }
  }
  void emiCalcute(){
    _EmiDate = [];
    var date = loanStaring.toDate();
      for(int i =0;i<emiDuration;i++){
        var _nextMonth = new DateTime(date.year, date.month+i, date.day);

        Timestamp.fromDate(_nextMonth);
        _EmiDate.add(Timestamp.fromDate(_nextMonth));

      }
      // //print('List ${_EmiDate}');
  }
  void calculateBrokerrage(){
    brokerageList.clear();
    remainingBrokerage = totalCommission - firstCommissionRupee;
    double _perMonthCommission = averageCommissionRupee / (emiDuration -2);

    averageCommissionOfBroker = _perMonthCommission.toInt();

    finalCommissionRupee = totalCommission - (firstCommissionRupee+(averageCommissionOfBroker *(emiDuration -2)));
    brokerageList.add(firstCommissionRupee);
    for(int i =0;i<(emiDuration -2);i++){
      brokerageList.add(averageCommissionOfBroker);
    }
    brokerageList.add(finalCommissionRupee);
    //print("lastbRokarage ${brokerageList}");

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spaceBetweenVertical = size.height *0.01;
    final spaceBetweenHorizontal = size.width *0.01;
    final fontSize = size.height *0.02;
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: loading ?CircularLoading(): SingleChildScrollView(
        child: screen(context)
      )
    );

  }
  Widget screen(BuildContext context){

print(emiDuration);
    if(pageNumber == 1){
    return ExistCustomer(context);
    }
    else if(pageNumber == 2){
      return newCustomer(context);
    }
    else {
      return mainScreen(context);
    }

  }
  Widget mainScreen(BuildContext context){
    final size = MediaQuery.of(context).size;
    final spaceBetweenVertical = size.height *0.01;
    final fontSize = size.height *0.02;
    return Container(
      height: size.height *0.8,

      width:size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: size.width *0.08),
              shape: StadiumBorder(),
                onPressed: (){
                  setState(() {
                    pageNumber = 1;
                  });
                },
                child: Text(AppLocalizations.of(context).translate('ExistingCustomer'),style: TextStyle(
                  fontSize: fontSize,

                    color: CommonAssets.buttonTextColor
                ),),
                )  ,
          SizedBox(
            height: spaceBetweenVertical*2,
          ),
          Container(
            
            child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: size.width *0.11),
              shape: StadiumBorder(),
              onPressed: (){
                setState(() {
                  pageNumber = 2;
                });
              },
              child: Text(AppLocalizations.of(context).translate('NewCustomer'),style: TextStyle(
                  fontSize: fontSize,

                 
                color: CommonAssets.buttonTextColor
              ),),
            ),
          )  ,
        ],
      ),
    );
  }


  Widget ExistCustomer(BuildContext context){
    final size = MediaQuery.of(context).size;
    final spaceBetweenVertical = size.height *0.01;
    final spaceBetweenHorizontal = size.width *0.01;
    final fontSize = size.height *0.02;
    // DateFormat format = new DateFormat("yyyy ,MMMM, dd");
    // var formattedDate = format.parse(cusBookingDate.toDate().toString());
    return WillPopScope(
      onWillPop: (){

        setState(() {
          pageNumber = 0;

        });
        return null;
      },
      child: Form(
      
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
          child: Column(
            children: [


              TextFormField(
                maxLength: 10,

                autofocus: false,
                keyboardType: TextInputType.phone,
                onChanged: (val){
                  setState(() {
                    phoneNumber =int.parse(val);
                   if(val.length ==10){
                     ISExistCustomer();
                   }
                   else{
                     isExistUser = false;
                   }
                  });
                },

                validator:phoneNumbervalidtion,

                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('MobileNumber'),
                    counterText: "",
                  suffixIcon: isExistUser ?Icon(Icons.verified_user_outlined,color: Theme.of(context).primaryColor,) : Icon(Icons.cancel_outlined,color: CommonAssets.errorColor,)
                ),
              ),
              customerData != null ?
              customerData.exists?
              SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container():Container(),
              customerData != null ?
              customerData.exists?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(

                        AppLocalizations.of(context).translate('CustomerName'),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(width: spaceBetweenHorizontal,),
                      Expanded(
                        child: AutoSizeText(
                          customerData.data()['CustomerName'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ):Container():Container(),
              customerData != null ?
              customerData.exists?
              SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container():Container(),
              SizedBox(height: spaceBetweenVertical,),
              Row(

                children: [
                  Expanded(child: TextFormField(
                    initialValue: squareFeet.toString(),
                    maxLength: 7,
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    onChanged: (val){
                      setState(() {
                        squareFeet =int.parse(val);
                        calculate();
                      });
                    },
                    validator: (val) => numbervalidtion(val),
                    decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('SquareFeet')),
                  ),),
                  SizedBox(width: spaceBetweenHorizontal,),
                  Expanded(
                    child: TextFormField(
                      initialValue: pricePerSquareFeet.toString(),
                      maxLength:9,
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      onChanged: (val){
                        setState(() {
                          pricePerSquareFeet =int.parse(val);
                          calculate();
                        });
                      },
                      validator: (val) => numbervalidtion(val),
                      decoration: commoninputdecoration.copyWith(
                          labelText: AppLocalizations.of(context)
                              .translate('PricePerSqFt')),
                    ),
                  ),

                ],
              ),
              SizedBox(height: spaceBetweenVertical,),
              TextFormField(
                initialValue: emiDuration.toString(),
                maxLength: 3,
                autofocus: false,
                keyboardType: TextInputType.phone,
                onChanged: (val){
                  setState(() {
                    emiDuration =int.parse(val);
                    calculate();
                    emiCalcute();
                    calculateBrokerrage();
                  });
                },
                validator: (val) => numbervalidtion(val),
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('EMIDuration')),
              ),
              // extra space


              // extra space

              DropdownButtonFormField(
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('Broker')),
                value: selectedBroker,
                onChanged: (val){
                  setState(() {
                    selectedBroker =val.toString();
                  });
                },
                items: widget.brokerList.map((e){
                  return DropdownMenuItem(
                      value: e['Id'],
                      child: Row(
                        children: [
                          Text("${e['Id']} (${e['Name']})")
                        ],

                      )
                  );
                }).toList(),
              ),

              SizedBox(
                height: spaceBetweenVertical,
              ),
              Row(
                children: [
                  Expanded(child: DropdownButtonFormField(
                    decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('CommissionType')),
                    // commission
                    value: selectedCommissionType,
                    onChanged: (val){
                      setState(() {
                        selectedCommissionType =val.toString();
                        isPercentage = !isPercentage;
                      });
                    },
                    items: commissionType.map((e){
                      return DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text("${e} ")
                            ],
                          )
                      );
                    }).toList(),
                  ),),
                  SizedBox(width:  size.width *0.01,),
                  Expanded(
                    child: isPercentage ? TextFormField(
                      initialValue: commissionPercentage.toString(),
                      maxLength: 2,

                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          commissionPercentage =int.parse(val);
                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator: (val) => numbervalidtion(val),
                      decoration: commoninputdecoration.copyWith(
                          labelText: AppLocalizations.of(context)
                              .translate('Commission'),
                          counterText: '',

                      ),

                    ):
                    TextFormField(
                      initialValue: commissionRupee.toString(),
                      maxLength: 7,

                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          commissionRupee =int.parse(val);
                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator: numbervalidtion,
                      decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('Commission'),
                        counterText: '',

                      ),

                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenVertical,
              ),
             Row(
               children: [
                 Expanded(
                   child: TextFormField(
                     autofocus: false,
                     keyboardType: TextInputType.number,
                     onChanged: (val){
                       setState(() {
                         firstCommissionRupee =int.parse(val);

                         calculate();
                         emiCalcute();
                         calculateBrokerrage();
                       });
                     },
                     validator:  commissionValidtion,
                     // validator: (val)=>int.parse(val)>200?"Enter The ":null,
                     decoration: commoninputdecoration.copyWith(
                       labelText: AppLocalizations.of(context)
                           .translate('FirstBrokerage'),
                       counterText: '',

                     ),

                   ),
                 ),
                 SizedBox(width: spaceBetweenHorizontal,),
                 Expanded(
                   child: TextFormField(



                     autofocus: false,
                     keyboardType: TextInputType.number,
                     onChanged: (val){
                       setState(() {
                         averageCommissionRupee =int.parse(val);

                         calculate();
                         emiCalcute();
                         calculateBrokerrage();
                       });
                     },
                     validator:  remainingCommissionValidation,
                     // validator: (val)=>int.parse(val)>200?"Enter The ":null,
                     decoration: commoninputdecoration.copyWith(
                       labelText: AppLocalizations.of(context)
                           .translate('AverageBrokerage'),
                       counterText: '',

                     ),

                   ),
                 ),
               ],
             ),


              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(

                        AppLocalizations.of(context).translate('TotalAmount'),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        (pricePerSquareFeet * squareFeet).toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: CommonAssets.standardtextcolor,

                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ):Container(),

              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(

                        AppLocalizations.of(context).translate('MonthlyEMI'),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        perMonthEmi.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: CommonAssets.standardtextcolor,

                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ):Container(),
              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(

                            AppLocalizations.of(context).translate('BrokerCommission'),
                            style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            totalCommission.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: CommonAssets.standardtextcolor,

                            ),
                            maxLines: 1,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(

                            AppLocalizations.of(context).translate('FirstBrokerage'),
                            style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            firstCommissionRupee.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: CommonAssets.standardtextcolor,

                            ),
                            maxLines: 1,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(

                            AppLocalizations.of(context).translate('AverageBrokerage'),
                            style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            averageCommissionOfBroker.toString()+"(${emiDuration -2})",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: CommonAssets.standardtextcolor,

                            ),
                            maxLines: 1,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(

                            AppLocalizations.of(context).translate('FinalBrokerage'),
                            style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            finalCommissionRupee.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: CommonAssets.standardtextcolor,

                            ),
                            maxLines: 1,
                          )
                        ],
                      ),
                    ],
                  )
                ),
              ):Container(),
              SizedBox(
                height: spaceBetweenVertical,
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).translate('BookingDate')),
                      Text(AppLocalizations.of(context).translate('StartingDateOfLoan')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [

                            Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor
                                  )
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  Timestamp _date = await _selectDate(context);
                                  setState(() {
                                    cusBookingDate = _date;
                                  });
                                },
                                child: Container(

                                  height: size.height *0.045,
                                  width: size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${cusBookingDate.toDate().day} ${months[cusBookingDate.toDate().month -1]}',
                                      style: TextStyle(
                                          fontSize:  fontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [

                            Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor
                                  )
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  Timestamp _date = await _selectDate(context);

                                  setState(() {
                                    loanStaring = _date;
                                  });
                                },
                                child: Container(

                                  height: size.height *0.045,
                                  width: size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${loanStaring.toDate().day} ${months[loanStaring.toDate().month -1]}',
                                      style: TextStyle(
                                          fontSize:  fontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenVertical*2,
              ),
              RaisedButton(
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context).translate('Add'),
                    style: TextStyle(
                  fontSize: fontSize,
                        color: CommonAssets.buttonTextColor
                    ),),
                  onPressed: ()async{

                    if(_formKey.currentState.validate()){
                      //if user is exist than other thing
                      if(isExistUser){
                        setState(() {
                          loading = true;
                        });
                        await  ProjectsDatabaseService().existingCustomer(widget.projectName, widget.innerCollection,
                            widget.allocatedNumber.toString(), phoneNumber, squareFeet, pricePerSquareFeet, cusBookingDate,loanStaring, selectedBroker, emiDuration, perMonthEmi.round(),_EmiDate,totalCommission,brokerageList);
                        Navigator.pop(context);
                      }

                    }
                  })

            ],
          ),
        ),
      ),
    );
  }



  Widget newCustomer(BuildContext context){
    final size = MediaQuery.of(context).size;
    final spaceBetweenVertical = size.height *0.01;
    final spaceBetweenHorizontal = size.width *0.01;
    final fontSize = size.height *0.02;
    return WillPopScope(
      onWillPop: (){
        setState(() {
          pageNumber =0;
        });
        return null;
      },
      child: Form(
        key: _formKey,
      
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
          child: Column(
            children: [
              // Todo change label
              TextFormField(
                maxLength: 35,
                autofocus: false,
                onChanged: (val)=>customerName =val,
                validator: (val) => Stringvalidation(val),
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('CustomerName')),
              ),
              SizedBox(height: spaceBetweenVertical,),
              TextFormField(
                maxLength: 10,

                autofocus: false,
                keyboardType: TextInputType.phone,

                onChanged: (val){
                  setState(() {
                  phoneNumber =int.parse(val);
                  if(val.length ==10){
                    ISExistCustomer();
                  }
                  else if(val.length < 10){
                    isUser = true;
                  }
                 else{
                    isUser = false;
                  }
                  });
                },
                // onEditingComplete: ()async{
                //
                //   FocusScope.of(context).unfocus();
                // },
                validator: phoneNumbervalidtion,
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('MobileNumber'),

                    counterText: "",
                    suffixIcon: isUser ? Icon(Icons.cancel_outlined,color: CommonAssets.errorColor,):Icon(Icons.verified_user_outlined,color: Theme.of(context).primaryColor,) ,
                ),
              ),

              SizedBox(height: spaceBetweenVertical,),
              Row(

                children: [
                  Expanded(child:
                  TextFormField(
                    initialValue: squareFeet.toString(),
                    maxLength: 7,
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    onChanged: (val){
                      setState(() {
                        squareFeet =int.parse(val);
                        calculate();
                      });
                    },
                    validator: (val) => numbervalidtion(val),
                    decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('SquareFeet')),
                  ),),
                  SizedBox(width: spaceBetweenHorizontal,),
                  Expanded(
                    child: TextFormField(
                      initialValue: pricePerSquareFeet.toString(),
                      maxLength:9,
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      onChanged: (val){
                        setState(() {
                          pricePerSquareFeet =int.parse(val);
                          calculate();
                        });
                      },
                      validator: (val) => numbervalidtion(val),
                      decoration: commoninputdecoration.copyWith(
                          labelText: AppLocalizations.of(context)
                              .translate('PricePerSqFt')),
                    ),
                  ),

                ],
              ),
              SizedBox(height: spaceBetweenVertical,),
              TextFormField(
                initialValue: emiDuration.toString(),
                maxLength: 3,
                autofocus: false,
                keyboardType: TextInputType.phone,
                onChanged: (val){
                  setState(() {
                    emiDuration =int.parse(val);
                    calculate();
                    emiCalcute();
                    calculateBrokerrage();
                  });
                },
                validator: numbervalidtion,
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('EMIDuration')),
              ),
              // extra space

              // // isCalculate  ?Card(
              // //   elevation: 10.0,
              // //   shadowColor: Colors.white,
              // //   shape: RoundedRectangleBorder(
              // //       side: BorderSide(
              // //         color: CommonAssets.boxBorderColors,
              // //
              // //       )
              // //
              // //   ),
              // //   child: Padding(
              // //     padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
              // //     child: Row(
              // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // //       children: [
              // //         AutoSizeText(
              // //
              // //           AppLocalizations.of(context).translate('MonthlyEMI'),
              // //           style: TextStyle(
              // //     fontSize: fontSize,
              // //               color: CommonAssets.standardtextcolor,
              // //
              // //               fontWeight: FontWeight.bold
              // //           ),
              // //           maxLines: 1,
              // //         ),
              // //         AutoSizeText(
              // //           perMonthEmi.toStringAsFixed(2),
              // //           style: TextStyle(
              // //     fontSize: fontSize,
              // //               color: CommonAssets.standardtextcolor,
              // //
              // //           ),
              // //           maxLines: 1,
              // //         )
              // //       ],
              // //     ),
              // //   ),
              // // ):Container(),
              // // extra space
              // isCalculate?SizedBox(
              //   height: spaceBetweenVertical*2,
              // )
              //     :Container(),
              DropdownButtonFormField(
                decoration: commoninputdecoration.copyWith(
                    labelText: AppLocalizations.of(context)
                        .translate('Broker')),
                value: selectedBroker,
                onChanged: (val){
                  setState(() {
                    selectedBroker =val.toString();
                  });
                },
                items: widget.brokerList.map((e){
                  return DropdownMenuItem(
                      value: e['Id'],
                      child: Row(
                        children: [
                          Text("${e['Id']} (${e['Name']})")
                        ],
                      )
                  );
                }).toList(),
              ),
              SizedBox(
                height: spaceBetweenVertical*2,
              ),
              Row(
                children: [
                  Expanded(child: DropdownButtonFormField(
                    decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('CommissionType')),
                    // commission
                    value: selectedCommissionType,
                    onChanged: (val){
                      setState(() {
                        selectedCommissionType =val.toString();
                        isPercentage = !isPercentage;
                      });
                    },
                    items: commissionType.map((e){
                      return DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text("${e} ")
                            ],
                          )
                      );
                    }).toList(),
                  ),),
                  SizedBox(width:  size.width *0.01,),
                  Expanded(
                    child: isPercentage ? TextFormField(
                      initialValue: commissionPercentage.toString(),
                      maxLength: 2,

                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          commissionPercentage =int.parse(val);
                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator: (val) => numbervalidtion(val),
                      decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('Commission'),
                        counterText: '',

                      ),

                    ):
                    TextFormField(
                      initialValue: commissionRupee.toString(),
                      maxLength: 7,

                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          commissionRupee =int.parse(val);
                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator: (val) => numbervalidtion(val),
                      decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('Commission'),
                        counterText: '',

                      ),

                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenVertical,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          firstCommissionRupee =int.parse(val);

                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator:  commissionValidtion,
                      // validator: (val)=>int.parse(val)>200?"Enter The ":null,
                      decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('FirstBrokerage'),
                        counterText: '',

                      ),

                    ),
                  ),
                  SizedBox(width: spaceBetweenHorizontal,),
                  Expanded(
                    child: TextFormField(



                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          averageCommissionRupee =int.parse(val);

                          calculate();
                          emiCalcute();
                          calculateBrokerrage();
                        });
                      },
                      validator:  remainingCommissionValidation,
                      // validator: (val)=>int.parse(val)>200?"Enter The ":null,
                      decoration: commoninputdecoration.copyWith(
                        labelText: AppLocalizations.of(context)
                            .translate('AverageBrokerage'),
                        counterText: '',

                      ),

                    ),
                  ),
                ],
              ),


              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(

                        AppLocalizations.of(context).translate('TotalAmount'),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        (pricePerSquareFeet * squareFeet).toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: CommonAssets.standardtextcolor,

                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ):Container(),

              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(

                        AppLocalizations.of(context).translate('MonthlyEMI'),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: CommonAssets.standardtextcolor,

                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        perMonthEmi.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: CommonAssets.standardtextcolor,

                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ):Container(),
              isCalculate ?SizedBox(
                height: spaceBetweenVertical*2,
              )
                  :Container(),
              isCalculate?Card(
                elevation: 10.0,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CommonAssets.boxBorderColors,

                    )

                ),
                child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.height*0.01),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(

                              AppLocalizations.of(context).translate('BrokerCommission'),
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: CommonAssets.standardtextcolor,

                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              totalCommission.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(

                              AppLocalizations.of(context).translate('FirstBrokerage'),
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: CommonAssets.standardtextcolor,

                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              firstCommissionRupee.toString(),
                              style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(

                              AppLocalizations.of(context).translate('AverageBrokerage'),
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: CommonAssets.standardtextcolor,

                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              averageCommissionOfBroker.toString()+"(${emiDuration -2})",
                              style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(

                              AppLocalizations.of(context).translate('FinalBrokerage'),
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: CommonAssets.standardtextcolor,

                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              finalCommissionRupee.toString(),
                              style: TextStyle(
                                fontSize: fontSize,
                                color: CommonAssets.standardtextcolor,

                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                      ],
                    )
                ),
              ):Container(),
              SizedBox(
                height: spaceBetweenVertical,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).translate('BookingDate')),
                      Text(AppLocalizations.of(context).translate('StartingDateOfLoan')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [

                            Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor
                                  )
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  Timestamp _date = await _selectDate(context);
                                  setState(() {
                                    cusBookingDate = _date;
                                  });
                                },
                                child: Container(

                                  height: size.height *0.045,
                                  width: size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${cusBookingDate.toDate().day} ${months[cusBookingDate.toDate().month -1]}',
                                      style: TextStyle(
                                          fontSize:  fontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [

                            Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor
                                  )
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  Timestamp _date = await _selectDate(context);

                                  setState(() {
                                    loanStaring = _date;
                                  });
                                },
                                child: Container(

                                  height: size.height *0.045,
                                  width: size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${loanStaring.toDate().day} ${months[loanStaring.toDate().month -1]}',
                                      style: TextStyle(
                                          fontSize:  fontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenVertical*2,
              ),
              RaisedButton(
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context).translate('Add'),
                    style: TextStyle(
                  fontSize: fontSize,
                        color: CommonAssets.buttonTextColor
                    ),),
                  onPressed: ()async{

                    if(_formKey.currentState.validate()){

                      // if user is exist not do than  other thing
                    if(!isUser){
                      setState(() {
                        loading = true;
                      });
                      await  ProjectsDatabaseService().addNewCustomer(widget.projectName, widget.innerCollection,
                          widget.allocatedNumber.toString(), customerName, phoneNumber, squareFeet, pricePerSquareFeet, cusBookingDate, loanStaring,selectedBroker, emiDuration, perMonthEmi.round(),_EmiDate,totalCommission,brokerageList);
                      Navigator.pop(context);
                    }
                    }
                  })

            ],
          ),
        ),
      ),
    );
  }
  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    else if(value==0.toString())
      {

        return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
      }
  else {
      return null;
    }
  }
  String commissionValidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    else if(value==0.toString())
    {

      return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
    }
    else  if (int.parse(value ) > totalCommission){
      return "< ${totalCommission.toString()}";
    }
    else {
      return null;
    }
  }
  String remainingCommissionValidation(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    print(value);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    // else if(value=="0")
    // {
    //
    //   return AppLocalizations.of(context).translate("ThisFieldIsMandatory");
    // }
    else  if (int.parse(value ) > remainingBrokerage){
      return "< ${remainingBrokerage.toString()}";
    }
    else {
      return null;
    }
  }

  String phoneNumbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    else if(value.length <10){
      return AppLocalizations.of(context).translate("NumberIsLessThan10");
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }
  String Stringvalidation(String value){
    Pattern pattern = '^[a-zA-Z]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("CharactersOnly");

    }

    else {
      return null;
    }
  }
}

