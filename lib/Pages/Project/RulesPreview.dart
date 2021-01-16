import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
class RulesPreview extends StatefulWidget {
  List<String> rules ;
  List<int> rulesindex ;
  RulesPreview({@required this.rules,@required this.rulesindex});
  @override
  _RulesPreviewState createState() => _RulesPreviewState();
}

class _RulesPreviewState extends State<RulesPreview> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
    appBar: CommonAppbar(Container()),
      body: ListView.builder(
          itemCount: widget.rulesindex.length,
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
                  widget.rules[widget.rulesindex[index]],
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
