import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CommercialArcade extends StatefulWidget {
  @override
  _CommercialArcadeState createState() => _CommercialArcadeState();
}

class _CommercialArcadeState extends State<CommercialArcade> {
  ScrollController scrollController;
  int floors = 0;
  int shop_per_floor = 0;
  int selectdfloor ;
  int staringnumber = 1000;
  int number = 0;
  List<List<int>> building= List();
  void allocationnumber(){
    if(selectdfloor != null){
      number = (selectdfloor * 100) +staringnumber;
    }
  }


  @override
  Widget build(BuildContext context) {
    allocationnumber();
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
                height: size.height  *0.1,
                child: Row(
                  children: [
                    Expanded(child: TextFormField(
                      keyboardType: TextInputType.phone,
                      maxLength: 1,
                      onChanged: (val)=> floors = int.parse(val),
                      decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Floors')),
                    )),
                    SizedBox(width: size.width *0.01,),
                    Expanded(child: TextFormField(
                    keyboardType: TextInputType.phone,
                      maxLength: 3,
                    onChanged: (val)=> shop_per_floor = int.parse(val),
                      decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Shops')),
                    )),
                    SizedBox(width: size.width *0.01,),
                    Expanded(child: TextFormField(
                      initialValue: staringnumber.toString(),
                      keyboardType: TextInputType.phone,
                      maxLength: 4,
                      onChanged: (val)=> staringnumber = int.parse(val),
                      decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('StartingNumber')),
                    )),
                  ],
                ),
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
                          child: selectdfloor !=  null ? Text(
                            selectdfloor.toString(),
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
                        itemCount: floors,
                        itemBuilder: (context,floorindex){

                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selectdfloor = floorindex;

                                print(number);
                                // print(selectdfloor.toString());
                              });
                            },
                            child: Container(
                                width: size.width /3 ,
                                //color: Colors.red,
                                child: Card(
                                  color: floorindex == selectdfloor ?Colors.black.withOpacity(0.5):Colors.white,
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
                                        color: floorindex == selectdfloor ?Colors.white:CommonAssets.standardtextcolor,
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
            selectdfloor == null?Expanded(child: Container()):Expanded(
              child: GridView.builder(

      itemCount: shop_per_floor,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    childAspectRatio: (size.height /size.height *1.8)

                  ) ,

                  itemBuilder: (context,shopindex){
                  //  building.add([shopindex]);


                    int localshopnumber = number +shopindex;

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
            )
          ],
        )
      ),

    );
  }
}
