import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Service/Rules/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class RulesLanguage extends StatelessWidget {
  List<String> rulesdata ;
  RulesModel rulesModel;
  RulesLanguage({@required this.rulesdata,@required this.rulesModel});
  TextEditingController english = TextEditingController();
  TextEditingController hindi = TextEditingController();
  TextEditingController gujarati = TextEditingController();
  final _fomrkey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
          itemCount: rulesdata.length,
        itemBuilder: (context,index){
            return Card(

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
                                  await CompanyRules().deleteRules(rulesModel.english[index],rulesModel.hindi[index],rulesModel.gujarati[index],);
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
                  rulesdata[index],
                  style: TextStyle(
                    fontSize: size.height *0.02
                  ),
                ),
              ),
            );
    });

  }
}
