import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Structure/BulidingStructureModel.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class BuildingStructure extends StatefulWidget {
  @override
  _BuildingStructureState createState() => _BuildingStructureState();
}

class _BuildingStructureState extends State<BuildingStructure> {
final _formkey = GlobalKey<FormState>();
  // int nu =15;
  int floors = 0;
int flats = 2;
List<BuildingStructureModel> _buildingModel = List();

  getModel(int _floor,int _flats){
    print('ch');
    int staring = 100;
    _buildingModel.clear();
   for(int i  =0;i<floors;i++){
     List<int> _flatsList =List();
     for(int j =0;j<_flats;j++){

        _flatsList.add(staring + j+1);


     }

     _buildingModel.add(BuildingStructureModel(floorNumber: i+1, flats: _flatsList));
     staring = staring +100;
     print(_buildingModel[i].floorNumber);
     print(_buildingModel[i].flats);
   }

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

  
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height:size.height,
          child: Column(
            children: [
            Container(
              height: size.height *0.08,
              child: Form(
                key: _formkey,
                child: Row(

                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLength: 2,
                        decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Floors'),counterText: ""),
                        // validator: (val) => val.isEmpty ?'Enter The Number':null,
                        onChanged: (val){
                          setState(() {
                            floors =int.parse(val);
                            getModel(floors,flats);
                          });
                        }
                      ),
                    ),
                    SizedBox(width: 10,),

                      Expanded(
                        child: TextFormField(
                          maxLength: 1,
                          keyboardType: TextInputType.phone,
                          decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Flats'),counterText: ""),
                         // validator: (val) => val.isEmpty ?'Enter The Number':null,
                          onChanged: (val){

                            //flats =int.parse(val)
                            setState(() {

                              if(int.parse(val) == 2 ||int.parse(val) == 4 || int.parse(val) == 6||int.parse(val) == 8){
                                flats =int.parse(val);
                                getModel(floors,flats);
                              }
                              else{
                               // print('ss');
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context).translate('numberofflatsare246'),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    textColor: CommonAssets.AppbarTextColor,
                                    fontSize: size.height *0.02
                                );
                              }

                            });
                          },
                        ),
                      ),

                  ],
                ),
              ),
            ),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.black,),
                      left: BorderSide(color: Colors.black,),
                      top: BorderSide(color: Colors.black,),
                      bottom: BorderSide(color: Colors.black,),

                    )
                  ),
                  child: ListView.builder(
                      itemCount: floors ,
                      itemBuilder: (context,index){
                        return ModelStructure(index,flats);
                      }
                  ),
                ),

              ),
             _buildingModel.length > 0 ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.01, vertical: size.height * 0.005),
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.3,
                        vertical: size.height * 0.015),
                    shape: StadiumBorder(),
                    color: Theme.of(context).buttonColor,
                    onPressed: () {
                      return Navigator.pop(context,_buildingModel);
                    },

                    child: Text(

                    AppLocalizations.of(context).translate("Add"),
                      style: TextStyle(
                          color: CommonAssets.AppbarTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: size.height * 0.020),
                    ),
                  ),
                ),
              ):Container(),
            ],
          )
        ),
      )

    );
  }

  Widget ModelStructure(int floor,int flat){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
// print(floor.toString());
  int floornumber = floor +1;
  int staring =100 * (floor+1);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
          //  foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).primaryColor,
            child:Text(floornumber.toString(),style: TextStyle(
      color: Colors.white,
      fontSize: height *0.02,
     ),) ,
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width ,
                height: height * 0.06 ,

                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: flat,itemBuilder: (context,index){
                      int newflat = staring  + index +1;

                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal:width * 0.003),
                    child: Container(
                      width: width* 0.75 / flat ,

                      height: height / floornumber,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text(
                        newflat.toString(),style: TextStyle(
                        fontSize: height * 0.015,
                        fontWeight:FontWeight.bold
                      ),))
                    ),
                  );
                }),
              ),
            ),
          ),
        )
      ],
    );
  }
}
