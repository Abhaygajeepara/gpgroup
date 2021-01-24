import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Structure/CommercialArcadeModel.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CommercialArcade extends StatefulWidget {
  @override
  _CommercialArcadeState createState() => _CommercialArcadeState();
}

class _CommercialArcadeState extends State<CommercialArcade> {

  int mixupCommericalfloors = 0;
  int mixupCommericalShop_per_floor = 0;
  int mixupCommericalSelectdfloor ;
  int mixupCommericalStaringnumber = 1;
  int mixupCommericalDifferentialvalue = 1000;
  int mixupCommericalNumber = 0;

  List<CommercialArcadeModel> _mixupcommercialModel = List();
  void mixupAllocationnumber(){
    if(mixupCommericalSelectdfloor != null){
      mixupCommericalNumber = (mixupCommericalSelectdfloor * mixupCommericalDifferentialvalue) +mixupCommericalStaringnumber;
    }
  }
  mixupCommericalGetModel(){


    _mixupcommercialModel.clear();
    for(int i  =0;i<mixupCommericalfloors;i++){
      int staring = (i * mixupCommericalDifferentialvalue) +mixupCommericalStaringnumber;
      List<int> _flatsList =List();
      for(int j =0;j<mixupCommericalShop_per_floor;j++){

        _flatsList.add(staring + j);


      }

      _mixupcommercialModel.add(CommercialArcadeModel(floorNumber: i, shops:  _flatsList));
      staring = staring +100;

    }

  }


  @override
  Widget build(BuildContext context) {
    mixupAllocationnumber();
    mixupCommericalGetModel();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: Container(

        child:Column(

          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:size.width *0.01,vertical: size.height *0.01),
              child: Container(
                //color: Colors.white,

                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 1,
                          onChanged: (val)=> mixupCommericalfloors = int.parse(val),
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Floors')),
                        )),
                        SizedBox(width: size.width *0.01,),
                        Expanded(child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 3,
                          onChanged: (val)=> mixupCommericalShop_per_floor = int.parse(val),
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Shops')),
                        )),


                      ],
                    ),
                    SizedBox(height: size.width *0.01,),
                    Row(
                      children: [

                        Expanded(child: TextFormField(
                          initialValue: mixupCommericalStaringnumber.toString(),
                          keyboardType: TextInputType.phone,
                          maxLength: 4,
                          onChanged: (val)=> mixupCommericalStaringnumber = int.parse(val),
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('StartingNumber')),
                        )),
                        SizedBox(width: size.width *0.01,),
                        Expanded(child: TextFormField(
                          initialValue: mixupCommericalDifferentialvalue.toString(),
                          keyboardType: TextInputType.phone,
                          maxLength: 4,
                          onChanged: (val)=> mixupCommericalDifferentialvalue = int.parse(val),
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('NumberGap')),
                        )),
                      ],
                    ),
                  ],
                )
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height *0.1,
             // child: Text(AppLocalizations.of(context).translate('Floors')),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: size.width *0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Floors'),
                          style: TextStyle(
                              fontSize: size.height *0.03,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding:   EdgeInsets.only(right: size.width *0.02),
                          child: mixupCommericalSelectdfloor !=  null ? Text(
                            mixupCommericalSelectdfloor.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height *0.02
                          ),
                          ):Container()
                        )
                      ],
                    )
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mixupCommericalfloors,
                        itemBuilder: (context,floorindex){

                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                mixupCommericalSelectdfloor = floorindex;

                                print(mixupCommericalNumber);
                                // print(selectdfloor.toString());
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: floorindex == mixupCommericalSelectdfloor ?Colors.black.withOpacity(0.5):Colors.white,
                                  shape: RoundedRectangleBorder(
                                     side: BorderSide(
                                       color: Colors.black
                                     ),
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      floorindex.toString(),
                                      style: TextStyle(
                                          fontSize: size.height *0.02,
                                        color: floorindex == mixupCommericalSelectdfloor ?Colors.white:CommonAssets.standardtextcolor,
                                      ),),
                                  ),
                                )
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Divider(color: CommonAssets.dividercolor,),
            mixupCommericalSelectdfloor == null?Expanded(child: Container()):Expanded(
              child: GridView.builder(

      itemCount: mixupCommericalShop_per_floor,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    childAspectRatio: (size.height /size.height *1.8)

                  ) ,

                  itemBuilder: (context,shopindex){
                  //  building.add([shopindex]);


                    int localshopnumber = mixupCommericalNumber +shopindex;

                    return Container(

                        width: size.width /2 ,
                        height: size.height *0.1,
                       // color: selectdfloor%2 ==0?Colors.lightBlue:Colors.brown,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                              localshopnumber.toString(),
                              style: TextStyle(
                                  fontSize: size.height *0.02
                              ),),
                          ),
                        )
                    );
                  }),
            ),
          _mixupcommercialModel.length >0?  Padding(
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
                    return Navigator.pop(context,_mixupcommercialModel);
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

    );
  }
}
