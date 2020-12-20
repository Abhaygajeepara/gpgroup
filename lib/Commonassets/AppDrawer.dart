
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            onTap: ()async{

               Navigator.pop(context);
          return   await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 5),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(
              children: [
                Icon(Icons.home),
                Text('Home')
              ],
            ),
          ),
          ListTile(
            onTap: ()async{

              Navigator.pop(context);
              return   await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 5),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(
              children: [
                Icon(Icons.sd_card),
                Text('Home')
              ],
            ),
          )
        ],
      ),
    );
  }
}
