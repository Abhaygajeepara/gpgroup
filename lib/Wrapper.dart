import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Providers/BotttomNavigationProvider.dart';
import 'package:gpgroup/Providers/Project/ProjectName.dart';
import 'package:gpgroup/Service/Database/ProjectServices.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:provider/provider.dart';

import 'Pages/Auth/LogIn.dart';


class Wrapper extends StatefulWidget {
  @override
  //
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
   // SingleProjectData(ProjectName: "demo").setListners();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<BottomNavigationProvider>.value(
    //     value: BottomNavigationProvider(),
    //     child: HomeScreen()
    // );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        if(!snapshot.hasData || snapshot.data == null)
        {
          return LogIn();
        }
        else{
          return ChangeNotifierProvider<BottomNavigationProvider>.value(
            value: BottomNavigationProvider(),
              child: HomeScreen()
          );
        }
      },
    );
  }
}
