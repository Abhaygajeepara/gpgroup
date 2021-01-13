import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Structure/HousingModel.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:zoom_widget/zoom_widget.dart';

class HousingStructure extends StatefulWidget {
  @override
  _HousingStructureState createState() => _HousingStructureState();
}

class _HousingStructureState extends State<HousingStructure> {
  ScrollController scrollController;
  String part ;
  int house;
  int selected_part ;
  int staringnumber = 1;
  int number = 0;
  List<String> _localpart = List();
  List<CreateHousingStrctureModel> _partslist= List();
  final _formkey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

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
                  child: Form(
                    key: _formkey,
                    child: Row(
                      children: [
                        Expanded(child: TextFormField(
                        validator: Stringvalidation,
                         // keyboardType: TextInputType.text,
                        maxLength: 1,
                          onChanged: (val)=> part = val,
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Part')),
                        )),
                        SizedBox(width: size.width *0.01,),
                        Expanded(child: TextFormField(
                          validator: numbervalidtion,
                          keyboardType: TextInputType.phone,
                          maxLength: 3,
                          onChanged: (val)=> house = int.parse(val),
                          decoration: commoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('House')),
                        )),
                        SizedBox(width: size.width *0.01,),
                        Container(
                          child: Center(
                            child: IconButton(
                                icon: Icon(Icons.add),

                                color: Colors.black,
                              iconSize: size.height *0.04,
                              onPressed: (){
                                   if(_formkey.currentState.validate()){
                                      if(!_localpart.contains(part)){
                                       setState(() {
                                         _localpart.add(part);
                                         _partslist.add(CreateHousingStrctureModel(name: part,totalhouse: house));
                                       });
                                      }
                                     // if(_partslist.length == 0){
                                     //   setState(() {
                                     //     print('ss');
                                     //     _partslist.add(CreateHousingStrcture(name: part,totalhouse: house));
                                     //   });
                                     // }
                                     // else{
                                     //   for(int i = 0;i<_partslist.length;i++){
                                     //     if(part != _partslist[i].name){
                                     //       setState(() {
                                     //         _partslist.add(CreateHousingStrcture(name: part,totalhouse: house));
                                     //       });
                                     //       print('notmatch1');
                                     //     }
                                     //     else{
                                     //       print('match2');
                                     //
                                     //     }
                                     //   }
                                     // }

                                   }

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              AppLocalizations.of(context).translate('Part'),
                              style: TextStyle(
                                  fontSize: size.height *0.03,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding:   EdgeInsets.only(right: size.width *0.02),
                                child: selected_part !=  null ? Text(
                                  _partslist[selected_part].name .toString(),
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
                          itemCount: _partslist.length,
                          itemBuilder: (context,partindex){

                            return GestureDetector(
                              onLongPress: (){
                                setState(() {
                                  _localpart.removeAt(partindex);
                                  _partslist.removeAt(partindex);
                                  selected_part = null;
                                });
                              },
                              onTap: (){
                                setState(() {
                                  selected_part = partindex;

                                  print(number);
                                  // print(selected_part.toString());
                                });
                              },
                              child: Container(
                                  width: size.width /3 ,
                                  //color: Colors.red,
                                  child: Card(
                                    color: partindex == selected_part ?Colors.black.withOpacity(0.5):Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                        ),
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: Center(
                                      child: Text(
                                        _partslist[partindex].name.toString(),
                                        style: TextStyle(
                                          fontSize: size.height *0.02,
                                          color: partindex == selected_part ?Colors.white:CommonAssets.standardtextcolor,
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
              selected_part == null?Expanded(child: Container()):Expanded(
                child: GridView.builder(

                    itemCount: _partslist[selected_part].totalhouse,
                    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: (size.height /size.height *1.8)

                    ) ,

                    itemBuilder: (context,shopindex){
                      //  building.add([shopindex]);


                      int localshopnumber = shopindex +1;

                      return Container(

                          width: size.width /2 ,
                          height: size.height *0.1,
                          // color: selected_part%2 ==0?Colors.lightBlue:Colors.brown,
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
  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The Number Only';
    }
    else if(value.length >3){
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }
  String Stringvalidation(String value){
    Pattern pattern = '^[a-zA-Z]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The character Only';
    }
    else if(value.length >1){
      return "Character Is Grater Than One";
    }
    else {
      return null;
    }
  }
}
