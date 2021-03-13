import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
class LoanInfo extends StatefulWidget {
  CustomerData customerData;
  LoanInfo({@required this.customerData});
  @override
  _LoanInfoState createState() => _LoanInfoState();
}

class _LoanInfoState extends State<LoanInfo> {
  final  _formKey = GlobalKey<FormState>();
  bool emiPage = false;
  @override
  Widget build(BuildContext context) {
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);

    final size = MediaQuery.of(context).size;
    final titileSize = size.height /size.width  *8 ;
    final mainTitileSize = size.height /size.width *16 ;
    final normatTextSize = size.height /size.width  *7;
    final fontWeight =FontWeight.bold;
    final  verticalSizeBox = size.height *0.05;
    final  expanedTileSpace =size.height *0.012;

    print(projectRetrieve.loanRef);
    return Scaffold(

      appBar: CommonAppbar(Container()),
      body:StreamBuilder<List<SinglePropertiesLoanInfo>>(
        stream: projectRetrieve.LOANINFO,
        builder: (context,snapshot){
          if(snapshot.hasData)
            {
              print('SinglePropertiesLoanInfo lengtyh = ${snapshot.data.length}');
                 return !emiPage? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                            widget.customerData.id.toString(),
                            style: TextStyle(
                                fontSize: mainTitileSize,
                                fontWeight: fontWeight
                            ),
                          )
                      ),
                      Divider(color: Theme.of(context).primaryColor,thickness:2 ,),
                      // customer information
                      ExpansionTile(
                        //childrenPadding: EdgeInsets.all(8),
                        //childrenPadding: EdgeInsets.all(8),
                        title: Text(
                          AppLocalizations.of(context).translate('CustomerInformation'),
                          style: TextStyle(
                              fontSize: titileSize,
                              fontWeight: fontWeight
                          ),
                        ),
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
                                width: size.width *0.65,
                                child: new SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,//.horizontal
                                  child: new Text(
                                    widget.customerData.customerName,
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

                                widget.customerData.customerId,

                                style: TextStyle(
                                  fontSize: normatTextSize,

                                ),
                              )
                            ],
                          ),
                          SizedBox(height: expanedTileSpace,),
                        ],
                      ),
                      // SizedBox(height: verticalSizeBox,),
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(8),
                        title: Text(
                          AppLocalizations.of(context).translate('BrokerInformation'),
                          style: TextStyle(
                              fontSize: titileSize,
                              fontWeight: fontWeight
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('BrokerID'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: size.width *0.65,
                                child: new SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,//.horizontal
                                  child: new Text(
                                    widget.customerData.brokerReference,
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
                                AppLocalizations.of(context).translate('BrokerCommission'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.brokerCommission.toString(),
                                style: TextStyle(
                                  fontSize: normatTextSize,

                                ),
                              )
                            ],
                          ),
                          SizedBox(height: expanedTileSpace,),
                        ],
                      ),
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(8),
                        title: Text(
                          AppLocalizations.of(context).translate('PropertyInformation'),
                          style: TextStyle(
                              fontSize: titileSize,
                              fontWeight: fontWeight
                          ),
                        ),

                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('SquareFeet'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.squareFeet.toString(),
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
                                AppLocalizations.of(context).translate('PricePerSqFt'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.pricePerSquareFeet.toString(),
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
                                AppLocalizations.of(context).translate('BookingDate'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.cusBookingDate.toDate().toString().substring(0,19),
                                style: TextStyle(
                                  fontSize: normatTextSize,

                                ),
                              )
                            ],
                          ),
                          SizedBox(height: expanedTileSpace,),
                        ],
                      ),
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(8),
                        title: Text(
                          AppLocalizations.of(context).translate('LoanInformation'),
                          style: TextStyle(
                              fontSize: titileSize,
                              fontWeight: fontWeight
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('LoanId'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.loanReferenceCollectionName,
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
                                AppLocalizations.of(context).translate('MonthlyEMI'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.perMonthEMI.toString(),
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
                                AppLocalizations.of(context).translate('TotalEMI'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.totalEMI.toString(),
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
                                AppLocalizations.of(context).translate('StartingDateOfLoan'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.loanStartingDate.toDate().toString().substring(0,10),
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
                                AppLocalizations.of(context).translate('EndingDateOfLoan'),
                                style: TextStyle(
                                    fontSize: titileSize,
                                    fontWeight: fontWeight
                                ),
                              ),
                              Text(
                                widget.customerData.loanStartingDate.toDate().toString().substring(0,10),
                                style: TextStyle(
                                  fontSize: normatTextSize,

                                ),
                              )
                            ],
                          ),
                          SizedBox(height: expanedTileSpace,),

                        ],
                      ),
                    ],
                  ),
                ),
              ):


                 Padding(
                   padding: EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width *0.01),
                 child: ListView.builder(
                   itemCount: snapshot.data.length,
                     itemBuilder: (context,emiIndex){
                     return Card(
                       shape: RoundedRectangleBorder(
                         side: BorderSide(
                           color: CommonAssets.boxBorderColors
                         )
                       ),
                      color: snapshot.data[emiIndex].emiPending ? CommonAssets.paidEmiCardColor:Colors.white,
                       child: ListTile(
                          title: Text(snapshot.data[emiIndex].emiId.toString(),style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                         subtitle: Text(snapshot.data[emiIndex].installmentDate.toDate().toString().substring(0,10)),
                       ),
                     );
                     }
                     ),
                 );

            }
          else if(snapshot.hasError) {
            return Container(
              child: Center(
                child: Text(
                //snapshot.error.toString(),
                 CommonAssets.snapshoterror,
                  style: TextStyle(
                      color: CommonAssets.errorColor
                  ),
                ),
              ),
            );
          }
          else{
            return CircularLoading();
          }
        }
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:  RaisedButton(
          shape: StadiumBorder(),
          onPressed: (){
            setState(() {
              emiPage = !emiPage;
              print(emiPage);
            });
          },
          child: Text(emiPage ?
          AppLocalizations.of(context).translate('LoanInformation')
              :AppLocalizations.of(context).translate('PropertyInformation'),
            style: TextStyle(
                color: CommonAssets.buttonTextColor
            ),
          ),
        )
    );
  }
}
