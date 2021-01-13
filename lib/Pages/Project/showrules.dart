import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
class PreviewRules extends StatefulWidget {
  List<String> rules ;
  PreviewRules({@required this.rules});
  @override
  _PreviewRulesState createState() => _PreviewRulesState();
}

class _PreviewRulesState extends State<PreviewRules> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
    appBar: CommonAppbar(Container()),
      body: ListView.builder(
          itemCount: widget.rules.length,
          itemBuilder: (context,index){
          return  Card(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(

                      color: Colors.black.withOpacity(0.3)
                  )
              ),
              child: ListTile(




                title: Text(
                  widget.rules[index],
                  style: TextStyle(
                      fontSize: size.height *0.02
                  ),
                ),
              ),
            );
    }),
    );
  }
}
