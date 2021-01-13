import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Service/Rules/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class RulesLanguage extends StatefulWidget {
  List<String> rulesdata ;
  RulesModel rulesModel;
  bool isdeleteon;
  RulesLanguage({@required this.rulesdata,@required this.rulesModel,@required this.isdeleteon});
  bool createlist = true; //
  @override
  _RulesLanguageState createState() => _RulesLanguageState();
}

class _RulesLanguageState extends State<RulesLanguage> {
  TextEditingController english = TextEditingController();

  TextEditingController hindi = TextEditingController();

  TextEditingController gujarati = TextEditingController();

  final _fomrkey= GlobalKey<FormState>();
  List<bool> _rulescheck ;
  List<String> _selectedrules=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rulescheck = List<bool>.filled(widget.rulesdata.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
    Expanded(
      child: ListView.builder(
      itemCount: widget.rulesdata.length,
          itemBuilder: (context,index){

            return widget.isdeleteon?

            Card(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(

                      color: Colors.black.withOpacity(0.3)
                  )
              ),
              child: ListTile(

                onLongPress: ()async{

                  return showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context).translate('AreYouSure')),
                          content: Text(AppLocalizations.of(context).translate('YouWantToDeleteThisRule')),
                          actions: [
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              shape: StadiumBorder(),
                              onPressed: ()async{
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('Cancel'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor
                                ),
                              ),

                            ),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              shape: StadiumBorder(),
                              onPressed: ()async{
                                await CompanyRules().deleteRules(widget.rulesModel.english[index],widget.rulesModel.hindi[index],widget.rulesModel.gujarati[index],);
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('Delete'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor
                                ),
                              ),

                            ),

                          ],
                        );
                      }
                  );
                },
                // color: index % 2 ==0?Colors.black:Colors.tealAccent,
                // elevation: index % 2 ==0? 0.0:50.0,

                title: Text(
                  widget.rulesdata[index],
                  style: TextStyle(
                      fontSize: size.height *0.02
                  ),
                ),
              ),
            ):Card(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(

                      color: Colors.black.withOpacity(0.3)
                  )
              ),
              child: CheckboxListTile(


                value: _rulescheck[index],
                onChanged: (val){
                  setState(() {
                    _rulescheck[index]= val;
                    if(val){
                      _selectedrules.add(widget.rulesdata[index]);

                    }
                    else{
                      _selectedrules.remove(widget.rulesdata[index]);
                    }

                  });
                },
                title: Text(
                  widget.rulesdata[index],
                  style: TextStyle(
                      fontSize: size.height *0.02
                  ),
                ),
              ),
            );
          }),
    ),
       !widget.isdeleteon? Padding(
         padding: EdgeInsets.symmetric(
             horizontal: size.width * 0.01, vertical: size.height * 0.005),
         child: Center(
           child: RaisedButton(
             padding: EdgeInsets.symmetric(
                 horizontal: size.width * 0.3,
                 vertical: size.height * 0.015),
             shape: StadiumBorder(),
             color: Theme.of(context).primaryColor,
             onPressed: ()async {
           return    Navigator.pop(context,_selectedrules);
             },
             child: Text(
               AppLocalizations.of(context).translate("SelectRules"),
               style: TextStyle(
                   color: CommonAssets.AppbarTextColor,
                   fontWeight: FontWeight.w700,
                   fontSize: size.height * 0.020),
             ),
           ),
         ),
       ):Container()
      ],
    );

  }
}
