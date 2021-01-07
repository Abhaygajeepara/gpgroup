import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
  
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
            Container(
              height: height *0.08,
              child: Form(
                key: _formkey,
                child: Row(

                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Floors'),counterText: ""),
                        // validator: (val) => val.isEmpty ?'Enter The Number':null,
                        onChanged: (val)=> floors =int.parse(val),
                      ),
                    ),
                    SizedBox(width: 10,),

                      Expanded(
                        child: TextFormField(
                          maxLength: 1,
                          decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Flats'),counterText: ""),
                          validator: (val) => val.isEmpty ?'Enter The Number':null,
                          onChanged: (val)=> flats =int.parse(val),
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
                        return ss(index,flats);
                      }
                  ),
                ),

              )
            ],
          )
        ),
      )

    );
  }

  Widget ss(int floor,int flat){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
print(floor.toString());
  int floornumber = floor +1;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child:Text(floornumber.toString(),style: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
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
                      int newflat = index  + 1;
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal:width * 0.003),
                    child: Container(
                      width: width* 0.85 / 3 ,

                      height: height / floornumber,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text(floornumber.toString()+'0'+newflat.toString(),style: TextStyle(
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
