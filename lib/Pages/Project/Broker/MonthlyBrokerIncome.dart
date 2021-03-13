import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:gpgroup/Pages/Project/AboutProject/Customer/ExistingCustomerData.dart';
import 'package:url_launcher/url_launcher.dart';
class MonthlyBrokerIncome extends StatefulWidget {
  BrokerSaleDetails brokerSaleDetails;
  MonthlyBrokerIncome({@required this.brokerSaleDetails});
  @override
  _MonthlyBrokerIncomeState createState() => _MonthlyBrokerIncomeState();
}

class _MonthlyBrokerIncomeState extends State<MonthlyBrokerIncome> {
  int receivedCommission = 0;
  int expectCommission = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculate();
  }
  void calculate(){
    for(int i=0;i<widget.brokerSaleDetails.clientData.length;i++){
      expectCommission =expectCommission + widget.brokerSaleDetails.clientData[i]['Commission'];
      print(expectCommission);
      if( widget.brokerSaleDetails.clientData[i]['IsPay']){
        receivedCommission =  receivedCommission+ widget.brokerSaleDetails.clientData[i]['Commission'];
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    final titileSize = size.height /size.width  *8 ;
    final mainTitileSize = size.height /size.width *16 ;
    final normatTextSize = size.height /size.width  *7;
    final fontWeight =FontWeight.bold;
    final  verticalSizeBox = size.height *0.05;
    final  expanedTileSpace =size.height *0.012;
    final fontSize = size.height *0.02;

    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01 ),
        child: ListView.builder(
          itemCount: widget.brokerSaleDetails.clientData.length,
            itemBuilder: (context,index){
            Timestamp _date =  widget.brokerSaleDetails.clientData[index]['EMIDate'];

            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: widget.brokerSaleDetails.clientData[index]['IsPay'] ? CommonAssets.boxBorderColors:CommonAssets.errorColor
                )
              ),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(8.0),
                title: Text("${widget.brokerSaleDetails.clientData[index]['CustomerName']}(${widget.brokerSaleDetails.clientData[index]['Property']})"),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('CustomerName'),
                        style: TextStyle(
                            fontSize: titileSize,
                            fontWeight: fontWeight
                        ),
                      ),
                      SizedBox(width: size.width *0.01,),
                      Container(
                        alignment: Alignment.centerRight,
                        width: size.width *0.6,
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.horizontal,//.horizontal
                          child: new Text(
                            widget.brokerSaleDetails.clientData[index]['CustomerId'].toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: titileSize,

                            ),
                          ),
                        ),
                      ),


                    ],
                  ), SizedBox(height: expanedTileSpace,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('CustomerId'),
                        style: TextStyle(
                            fontSize: titileSize,
                            fontWeight: fontWeight
                        ),
                      ),
                      AutoSizeText(

                        widget.brokerSaleDetails.clientData[index]['CustomerName'],

                        style: TextStyle(
                          fontSize: normatTextSize,

                        ),
                      )
                    ],
                  ),
                  SizedBox(height: expanedTileSpace,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('Commission'),
                        style: TextStyle(
                            fontSize: titileSize,
                            fontWeight: fontWeight
                        ),
                      ),
                      SizedBox(width: size.width *0.01,),
                      Container(
                        alignment: Alignment.centerRight,
                        width: size.width *0.6,
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.horizontal,//.horizontal
                          child: new Text(
                            widget.brokerSaleDetails.clientData[index]['Commission'].toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: titileSize,

                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                  SizedBox(height: expanedTileSpace,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('EMIDate'),
                        style: TextStyle(
                            fontSize: titileSize,
                            fontWeight: fontWeight
                        ),
                      ),
                      SizedBox(width: size.width *0.01,),
                      Container(
                        alignment: Alignment.centerRight,
                        width: size.width *0.6,
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.horizontal,//.horizontal
                          child: new Text(
                            _date.toDate().toString().substring(0,10),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: titileSize,

                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                  SizedBox(height: expanedTileSpace,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          return launch("tel:${widget.brokerSaleDetails.clientData[index]['CustomerId']}");
                        },
                        icon: Icon(Icons.phone),
                      ),
                      IconButton(
                        onPressed: ()async{
                        // await  _projectRetrieve.setProjectName(widget.brokerSaleDetails.clientData[index]['projectName'], '');
                        // await  _projectRetrieve.setProperties(widget.brokerSaleDetails.clientData[index]['LoanId']);


                        },
                        icon: Icon(Icons.book),
                      ),
                    ]
                  ),
                  SizedBox(height: expanedTileSpace,),
                ],
              ),
            );
            }),
      ),
      bottomNavigationBar:  Theme(
        data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).primaryColor,
        ),
        child:

        Padding(
          padding:  EdgeInsets.all(8.0),
          child: Container(
            
            decoration: BoxDecoration(
                color:  Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0),

            ),

            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Row(
                  mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('TotalAmount'),
                        style: TextStyle(
                            color: CommonAssets.AppbarTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize
                        ),
                      ),
                      Text(
                          AppLocalizations.of(context).translate('ReceivedAmount'),
                        style: TextStyle(
                            color: CommonAssets.AppbarTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: titileSize /2,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expectCommission.toString(),
                        style: TextStyle(
                            color: CommonAssets.AppbarTextColor,
                            fontSize: fontSize
                        ),
                      ),
                      Text(
                          receivedCommission.toString(),
                        style: TextStyle(
                          color: CommonAssets.AppbarTextColor,
                            fontSize: fontSize
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}
