import 'package:flutter/material.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:provider/provider.dart';
class BrokerClients extends StatefulWidget {

  @override
  _BrokerClientsState createState() => _BrokerClientsState();
}

class _BrokerClientsState extends State<BrokerClients> {
  @override
  Widget build(BuildContext context) {
     final projectRetrieve  =  Provider.of<ProjectRetrieve>(context);
    return Container();
  }
}
