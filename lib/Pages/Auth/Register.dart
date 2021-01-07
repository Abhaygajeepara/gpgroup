import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String error = '';
  String email ;
  String password ;
  final _registerformkey = GlobalKey<FormState>();
  bool _vision = true;
  void _visibility(){
    setState(() {
      print(_vision);
      _vision = ! _vision;
    });
  }
  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      CommonAssets.apptitle.toString(),
                      style: TextStyle(
                          color:CommonAssets.apptitletextColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500

                      ),
                    ),

                    SizedBox(height: 10,),
                    Text(
                     'Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:CommonAssets.titletextsize,
                        fontWeight: FontWeight.w500,

                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: Colors.red,


                      ),
                    ),
                    SizedBox(height: 20,),
                    Form(
                      key: _registerformkey,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: width * 0.10),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Email')),
                              validator: (val) => val.isEmpty ?AppLocalizations.of(context).translate('EnterEmail'):null,
                              onChanged: (val)=> email =val,
                            ),
                            SizedBox(height:20,),
                            TextFormField(
                              obscureText: _vision,
                              decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Password'),suffixIcon: IconButton(
                                onPressed:_visibility,
                                icon:_vision == true ? Icon(Icons.visibility_off,color:  Colors.black,):Icon(Icons.visibility,color: Colors.black),),),
                              validator: (val) => val.isEmpty ?AppLocalizations.of(context).translate('EnterPassword'):null,
                              onChanged: (val)=> password =val,

                            ),
                            SizedBox(height: 20,),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.15,vertical: height * 0.02),
                              shape: StadiumBorder(),
                              color: CommonAssets.apptitletextColor,
                              onPressed: ()async{
                                if(_registerformkey.currentState.validate()){
                                  dynamic result = await  LogInAndSignIn().RegisterwithEmail(email,password);
                                  print(result);
                                  if(result == 'email-already-in-use'){
                                    setState(() {
                                      error = AppLocalizations.of(context).translate('EmailIsExist');
                                    });

                                  }
                                  else{
                                    Navigator.pop(context);
                                  }


                                }
                                else{
                                  Navigator.pop(context);
                                  return null;
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('Register'),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),


                            SizedBox(height: 20,),
                            RaisedButton(
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(vertical: height * 0.009),
                              color: Colors.white,
                              onPressed: ()async{

                                await LogInAndSignIn().loginWithGoogle();
                                Navigator.pop(context);
                                // return    Navigator.pushReplacement(context, PageRouteBuilder(
                                //   pageBuilder: (_, __, ___) => Home(),
                                //   transitionDuration: Duration(seconds: 0),
                                // ),);



                              },
                              child: Container(

                                width: width * .7,
                                child: Row(
                                  children: [
                                    Expanded(

                                      child: Container(
                                        height: 40,

                                        child: Image(
                                          image: AssetImage('assets/google.png'),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Expanded(
                                      flex:2,child: Text(
                                        AppLocalizations.of(context).translate('RegisterWithGoogle'),
                                      style: TextStyle(fontSize: 16.0),
                                    ),)
                                  ],
                                ),
                              ),

                            ),
                            SizedBox(height: 20,)
                          ],
                        ),

                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
