import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';

class RulesPreview extends StatefulWidget {
  List<String> english;
  List<String> hindi;
  List<String> gujarati;



  RulesPreview({@required this.english, @required this.hindi,@required this.gujarati});

  @override
  _RulesPreviewState createState() => _RulesPreviewState();
}

class _RulesPreviewState extends State<RulesPreview> {
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CommonAppbar(Container()),

        body:  PageView(
          controller: _pageController,
          children: [
            _rulesData(widget.english),
        _rulesData(widget.gujarati),
    _rulesData(widget.hindi),
          ],
        )
    );
  }

  Widget _rulesData(List<String> rules) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: rules.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black.withOpacity(0.3))),
            child: ListTile(
              title: Text(
                rules[index],
                style: TextStyle(fontSize: size.height * 0.02),
              ),
            ),
          );
        });
  }
}
