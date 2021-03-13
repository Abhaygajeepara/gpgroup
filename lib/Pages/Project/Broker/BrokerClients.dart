import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Broker/MonthlyBrokerIncome.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class BrokerClients extends StatefulWidget {

  @override
  _BrokerClientsState createState() => _BrokerClientsState();
}

class _BrokerClientsState extends State<BrokerClients> {
  DateTime now = DateTime.now();
  List<BrokerSaleDetails> _data =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void findCurrentMonth(List<BrokerSaleDetails> querySnapshot){

    _data =querySnapshot;
    // _data.sort((a,b)=>a.emiMonthTimestamp.toString().compareTo(b.emiMonthTimestamp.toString()));
    String currentMonth  ="${now.month}-${now.year}";
    int _index = querySnapshot.indexWhere((element) => element.month == currentMonth);
    print(_data[1].month);

  if( _index != -1){

    _data.insert(0, _data[_index]);
    _data.removeAt(_index);
    print(_data[0].month);
  }

  }
  @override
  Widget build(BuildContext context) {
     final _projectRetrieve  =  Provider.of<ProjectRetrieve>(context);
     _projectRetrieve.setBroker("Theerror");
     final size = MediaQuery.of(context).size;
     final titileSize = size.height /size.width  *8 ;
     final mainTitileSize = size.height /size.width *16 ;
     final normatTextSize = size.height /size.width  *7;
     final fontWeight =FontWeight.bold;
     final  verticalSizeBox = size.height *0.05;
     final  expanedTileSpace =size.height *0.012;

    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: StreamBuilder<List<BrokerSaleDetails>>(
        stream: _projectRetrieve.BROKERSALESDETAILS,
        builder: (context,snapshot){
          if(snapshot.hasData){
            findCurrentMonth(snapshot.data);
            return ListView.builder(
              itemCount: _data.length,
                itemBuilder: (context,index){
                return Padding(
                  padding:  EdgeInsets.symmetric(vertical:index == 0?size.height *0.01:0.0 ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: index == 0?Theme.of(context).primaryColor:CommonAssets.boxBorderColors,
                        width: index == 0?4:0,
                      )
                    ),
                    child: ListTile(
                      onTap: ()async{
                        Navigator.push(context, PageRouteBuilder(
                          //    pageBuilder: (_,__,____) => BuildingStructure(),
                          pageBuilder: (_,__,___)=>
                             MonthlyBrokerIncome(brokerSaleDetails: _data[index],),
                          transitionDuration: Duration(milliseconds: 0),
                        ));
                      },
                      title: Text(_data[index].month.toString()),
                    ),
                  ),
                );
                });
          }
          else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text(
                  CommonAssets.snapshoterror,
                  style: TextStyle(
                  color: CommonAssets.errorColor
                ),),
              ),
            );
          }
          else {
            return CircularLoading();
          }
        },
      ),
    );
  }
}
