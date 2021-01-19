
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

class CircularLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            semanticsLabel:'Loading' ,
            valueColor:AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        backgroundColor: CommonAssets.circularLoadingbackgroud,

        ));
  }
}
