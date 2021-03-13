import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Broker/AddBroker.dart';
import 'package:gpgroup/Pages/Project/Broker/BrokerProfile.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:provider/provider.dart';
class Broker extends StatefulWidget {
  @override
  _BrokerState createState() => _BrokerState();
}

class _BrokerState extends State<Broker> {
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body:StreamBuilder<List<BrokerModel>>(
        stream: ProjectRetrieve().BROKERLISTDATA,
        builder: (context,snapshot){
          if(snapshot.hasData){

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                return Card(
                  
                  shape: RoundedRectangleBorder(

                side: BorderSide(
                color: CommonAssets.boxBorderColors,
                    width: 0.3)),
                  child: ListTile(
                    onTap: ()async{

                      _projectRetrieve.setBroker(snapshot.data[index].id);
                      return   await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => BrokerProfile(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    },
                      leading: CircleAvatar(

                                        backgroundImage: NetworkImage(
                                          snapshot.data[index].image,


                                        ),
                                      ),

                    title: Text(snapshot.data[index].name),
                  ),
                ) ;
              }

            );
          }
          else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text(
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
        },
      ),




      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).buttonColor,
        onPressed: (){
          Navigator.push(context, PageRouteBuilder(
            //    pageBuilder: (_,__,____) => BuildingStructure(),
            pageBuilder: (_,__,___)=> AddBroker(),
            transitionDuration: Duration(milliseconds: 0),
          ));
        },
        child: Icon(Icons.person_add_alt_1),
      ),
    );
  }
}
