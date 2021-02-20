
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gpgroup/Pages/Project/AboutProject/UpdateDetails.dart';

import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class ProjectInfo extends StatefulWidget {
  ProjectRetrieve  projectProvider;

  ProjectInfo({ @required this.projectProvider});
  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {


  bool isInformationPage  = true;
  void  willpopChange(){

    setState(() {
      isInformationPage = true;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.projectProvider.setListners();
  //   if(widget.projectProvider.typeOfProject =="Society"||widget.projectProvider.typeOfProject =="CommercialArcade"){
  //     widget.projectProvider.setListners();
  //   }
  //   else if(widget.projectProvider.typeOfProject =="Apartment") {
  //     widget.projectProvider.apartMentSetListners();
  //   }
  // else if(widget.projectProvider.typeOfProject =="Mixed-Use"){
  // widget.projectProvider.MixedUse();
  // }


  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    // print(projectProvider.ProjectName);





    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: StreamBuilder<ProjectNameList>(
        stream: projectProvider.SINGLEPROJECT,
        builder: (context,singleProjectInfoSnapshot){
          if(singleProjectInfoSnapshot.hasData){


               if(isInformationPage){

                 return InformationPage(singleProjectInfoSnapshot.data, context);

               }
               else{


                 // return InformationPage(singleProjectInfoSnapshot.data, context);
                  return  DataPage(singleProjectInfoSnapshot.data);
               }
          }
          else if(singleProjectInfoSnapshot.hasError){
            return Container(child: Center(
              child: Text(CommonAssets.snapshoterror.toString()),
            ));
          }
          else{
            return CircularLoading();
          }
        }
      ),
      bottomNavigationBar:  Theme(
        data: Theme.of(context).copyWith(
        primaryColor: CommonAssets.bottomBarActiveButtonColor
    ),
    child:

    isInformationPage?RaisedButton.icon(
      color: Colors.white,
        label: Text(
          AppLocalizations.of(context).translate('ViewSite'),
          style: TextStyle(
            fontSize: size.height *0.03,
            fontWeight: FontWeight.bold
          ),
        ),
      onPressed: (){
        setState(() {
          isInformationPage = false;

        });
      },
      icon: Icon(
          Icons.construction,
      size: size.height *0.03,
      ),
      //label: AppLocalizations.of(context).translate('Home'),
    ):Container(
      height: 0,
    ),
    ),
    );

  }

  Widget InformationPage(ProjectNameList singleProjectInfoSnapshot ,BuildContext context){
    final size = MediaQuery.of(context).size;
    double titleTextSize = size.height *0.023;
    double valueTextSize = size.height *0.02;
    double normalSpacce = size.height *0.02;
    String ProjectNameUpperCase = singleProjectInfoSnapshot.projectName.substring(0,1).toUpperCase().toString()+singleProjectInfoSnapshot.projectName.substring(1).toString();
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.symmetric( vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            Container(
              //color: Colors.green,

              child: CarouselSlider.builder(
                  options: CarouselOptions(

                    // height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,

                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: singleProjectInfoSnapshot.imagesUrl.length,
                  itemBuilder: (BuildContext context,index){
                    return GestureDetector(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext  context){
                              return Dialog(
                                child: Image.network(
                                  singleProjectInfoSnapshot.imagesUrl[index],



                                ),
                              );
                            }
                        );
                      },
                      child: Image.network(
                        singleProjectInfoSnapshot.imagesUrl[index],
                        width: size.width,
                        height:size.height *0.3 ,
                        fit:BoxFit.fill,


                      ),
                    );
                  }
              ),

            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: Icon(Icons.delete), onPressed: (){}),
                SizedBox(width: size.width *0.03,),
                IconButton(icon: Icon(Icons.edit), onPressed: (){
                  return Navigator.push(context, PageRouteBuilder(pageBuilder:(_,__,___)=>UpdateProjectDetails(projectName:  singleProjectInfoSnapshot.projectName,)));
                }),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('ProjectName'),
                    style: TextStyle(
                      fontSize:titleTextSize,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    ProjectNameUpperCase,
                    style: TextStyle(
                      fontSize:valueTextSize,


                    ),
                  ),
                  SizedBox(
                    height:normalSpacce,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('Landmark'),
                    style: TextStyle(
                      fontSize:titleTextSize,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    singleProjectInfoSnapshot.landmark,
                    style: TextStyle(
                      fontSize:valueTextSize,


                    ),
                  ),
                  SizedBox(
                    height:normalSpacce,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('Address'),
                    style: TextStyle(
                      fontSize:titleTextSize,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    singleProjectInfoSnapshot.address,
                    style: TextStyle(
                      fontSize:valueTextSize,


                    ),
                  ),
                  SizedBox(
                    height:normalSpacce,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('Description'),
                    style: TextStyle(
                      fontSize:titleTextSize,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    singleProjectInfoSnapshot.description,
                    style: TextStyle(
                      fontSize:valueTextSize,


                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget DataPage(ProjectNameList data  ) {

   // print('Datapge');
    String buildingType = data.typeofBuilding;

    // return WillPopScope(
    //     onWillPop:  (){
    //       willpopChange();
    //     },
    //     child: houseStructure(data.projectName,context));
    if(buildingType == "Society" ){
      //||buildingType == "CommercialArcade"
      return WillPopScope(
          onWillPop:  (){
            willpopChange();
          },
          child: houseStructure(data.projectName,context,data));
    }
     else if(buildingType == "CommercialArcade" ){

      return WillPopScope(
          onWillPop:  (){
            willpopChange();
          },
          child: commercialStructure(data.projectName,context,data));
    }
    else if(buildingType == "Apartment"){
      return WillPopScope(
          onWillPop:  (){
            willpopChange();
          },
          child: apartmentStructure(data.projectName,context,data));
      return Text('Data type not exist add this to localization file');
    }

    else if(buildingType == "Mixed-Use"){
      return WillPopScope(
          onWillPop:  (){
            willpopChange();
          },
          child: mixedUseStructure(data.projectName,context,data));
      return Text('Data type not exist add this to localization file');
    }
    else{
      return Text('other format');
    }
  }
  Widget houseStructure(String projectName,BuildContext context,ProjectNameList projectNameList) {
   // print('houseStructure');
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<InnerData>>(
        stream: projectProvider.STRUCTURESTREAM,
        builder: (context,snapshot){
          if(snapshot.hasData){

            //print("Snapshot length = " +snapshot.data.length.toString());
            return CarouselSlider.builder(
                options: CarouselOptions(


                   height: size.height,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,

                  scrollDirection: Axis.horizontal,
                ),
                itemCount: projectNameList.Structure.length,
                itemBuilder: (BuildContext context,index){

                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data[index].name,
                          style: TextStyle(
                              color:  Theme.of(context).primaryColor,
                              //color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height *0.035,

                          ),
                        ),

                    Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 1,
                    ),
                    //  SizedBox(height: size.height *0.01,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: projectNameList.Structure[index]['Length'],
                            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              //  childAspectRatio: (size.height /size.height *1.8)

                            ) , itemBuilder: (context,indexCus){
                              int currentHouseNumber = indexCus +1;
                          return Padding(
                            padding:  EdgeInsets.symmetric(horizontal: size.width *0.01,vertical: size.height *0.005),
                            child: GestureDetector(
                              onTap: ()async{

                               projectProvider.customerUploadData(snapshot.data[index].name,currentHouseNumber);
                              },
                              child: Card(
                                  elevation: 30.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // side:BorderSide(
                                  //   color: !snapshot.data[index].cusList[indexCus].isLoanOn?
                                  //         Theme.of(context).primaryColor:CommonAssets.soldProduct
                                  // )
                                ),
                                  shadowColor: Colors.transparent.withOpacity(0.2),
                                  child: Center(child: Text(
                                    currentHouseNumber.toString(),
                                  style: TextStyle(
                                    fontSize: size.height  *0.02
                                  ),
                                  ))
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                      ],
                    ),
                  );
                }

            );
          }
          else{
            return CircularLoading();
          }
        });
  }

  Widget commercialStructure(String projectName,BuildContext context,ProjectNameList projectNameList) {
    // print('houseStructure');
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<InnerData>>(
        stream: projectProvider.STRUCTURESTREAM,
        builder: (context,snapshot){
          if(snapshot.hasData){
          //  print("Snapshot length = " +snapshot.data.length.toString());
            return CarouselSlider.builder(
                options: CarouselOptions(


                  height: size.height,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,

                  scrollDirection: Axis.horizontal,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,index){
                  int startingShopNumber = (projectNameList.Structure[0]['DifferentialValue'] *index) +projectNameList.Structure[0]['Staring'];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data[index].name,
                          style: TextStyle(
                            color:  Theme.of(context).primaryColor,
                            //color: CommonAssets.AppbarTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height *0.035,

                          ),
                        ),

                        Divider(
                          color: Theme.of(context).primaryColor,
                          thickness: 1,
                        ),
                        //  SizedBox(height: size.height *0.01,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                // index of projectNameList.Structure[0]['TotalShop'] because there only one list value in database
                                itemCount: projectNameList.Structure[0]['TotalShop'],
                                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  //  childAspectRatio: (size.height /size.height *1.8)

                                ) , itemBuilder: (context,indexCus){
                                  int currenShop = indexCus +startingShopNumber;
                              return Padding(
                                padding:  EdgeInsets.symmetric(horizontal: size.width *0.01,vertical: size.height *0.005),
                                child: GestureDetector(
                                  onTap: ()async{
                                    projectProvider.customerUploadData(snapshot.data[index].name,currenShop);
                                  },
                                  child: Card(
                                      elevation: 30.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        // side:BorderSide(
                                        //   color: !snapshot.data[index].cusList[indexCus].isLoanOn?
                                        //         Theme.of(context).primaryColor:CommonAssets.soldProduct
                                        // )
                                      ),
                                      shadowColor: Colors.transparent.withOpacity(0.2),
                                      child: Center(child: Text(
                                        currenShop.toString(),
                                        style: TextStyle(
                                            fontSize: size.height  *0.02
                                        ),
                                      ))
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  );
                }

            );
          }
          else{
            return CircularLoading();
          }
        });
  }

  Widget apartmentStructure(String projectName,BuildContext context,ProjectNameList projectNameList) {

    // print('houseStructure');
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    final size = MediaQuery.of(context).size;




    return StreamBuilder<List<InnerData>>(
        stream: projectProvider.STRUCTURESTREAM,
        builder: (context,snapshot){
          if(snapshot.hasData){
            //print("Snapshot length = " +snapshot.data.length.toString());
           // return  Text();
            return CarouselSlider.builder(
                options: CarouselOptions(


                  height: size.height,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,

                  scrollDirection: Axis.horizontal,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,index){

                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data[index].name,
                          style: TextStyle(
                            color:  Theme.of(context).primaryColor,
                            //color: CommonAssets.AppbarTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height *0.035,

                          ),
                        ),

                        Divider(
                          color: Theme.of(context).primaryColor,
                          thickness: 1,
                        ),

                        Expanded(
                          child: ListView.builder(
                              itemCount: projectNameList.Structure[0]['TotalFloor'],

                              itemBuilder: (context,indexFloor){
                                  int currentFloorStartingNumer = (indexFloor +1)*100;
                                return Container(
                                  height: size.height *0.05,
                                  child: ListView.builder(

                                      itemCount: projectNameList.Structure[0]['FlatPerFloor'],

                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,flatIndex){
                                        int currentFlat = (flatIndex +1)+ currentFloorStartingNumer;
                                        return Container(
                                          width: size.width /projectNameList.Structure[0]['FlatPerFloor'] ,
                                          child: GestureDetector(
                                            onTap: ()async{
                                              projectProvider.customerUploadData(snapshot.data[index].name,currentFlat);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                // side: BorderSide(
                                                //   color:
                                                //   !snapshot.data[index].numberOfFlats[indexFloor].cusLists[flatIndex].isLoanOn?
                                                //   Theme.of(context).primaryColor:CommonAssets.boxBorderColors
                                                // )
                                              ),
                                              child: Center(child: Text(currentFlat.toString())),
                                            ),
                                          ),
                                        );
                                      },
                                  ),
                                );
                              }),
                        ),

                         SizedBox(height: size.height *0.01,),

                      ],
                    ),
                  );
                }

            );
          }
          else{
            return CircularLoading();
          }
        });
  }

  mixedUseStructure(String projectName, BuildContext context,ProjectNameList projectNameList) {
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context,);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<InnerData>>(
        stream: projectProvider.STRUCTURESTREAM,
        builder: (context,commercialSnapshot){
          if(commercialSnapshot.hasData){
           // print("Snapshot length = " +commercialSnapshot.data.length.toString());

                    return CarouselSlider.builder(
                        options: CarouselOptions(


                          height: size.height,
                          aspectRatio: 16/9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,

                          scrollDirection: Axis.horizontal,
                        ),
                        itemCount: commercialSnapshot.data.length,
                        itemBuilder: (BuildContext context,index){

                       if(int.tryParse(commercialSnapshot.data[index].name) != null){
                         int startingShopNumber = (projectNameList.Structure[0]['DifferentialValue'] *index) +projectNameList.Structure[0]['Staring'];

                         return  mixCommercial(commercialSnapshot.data[index].name, context, projectNameList,startingShopNumber,projectProvider);
                       }
                      else{
                         int passIndex =projectNameList.Structure[0]['TotalFloor']-(index +1);
                         passIndex= passIndex.abs();
                        return mixApartment(commercialSnapshot.data[index].name, context, projectNameList, passIndex,projectProvider);
                       }


                        }

                    );

          }
          else{
            return CircularLoading();
          }
        });
  }
  Widget mixCommercial(String projectName, BuildContext context,ProjectNameList projectNameList,int startingShopNumber,ProjectRetrieve projectProvider){

    final size= MediaQuery.of(context).size;
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            projectName.toString(),
            style: TextStyle(
              color:  Theme.of(context).primaryColor,
              //color: CommonAssets.AppbarTextColor,
              fontWeight: FontWeight.bold,
              fontSize: size.height *0.035,

            ),
          ),

          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 1,
          ),
          //  SizedBox(height: size.height *0.01,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                // index of projectNameList.Structure[0]['TotalShop'] because there only one list value in database
                  itemCount: projectNameList.Structure[0]['TotalShop'],
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    //  childAspectRatio: (size.height /size.height *1.8)

                  ) , itemBuilder: (context,indexCus){
                int currenShop = indexCus +startingShopNumber;
                return Padding(
                  padding:  EdgeInsets.symmetric(horizontal: size.width *0.01,vertical: size.height *0.005),
                  child: GestureDetector(
                    onTap: ()async{
                      projectProvider.customerUploadData(projectName,currenShop);
                    },
                    child: Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side:BorderSide(
                          //   color: !snapshot.data[index].cusList[indexCus].isLoanOn?
                          //         Theme.of(context).primaryColor:CommonAssets.soldProduct
                          // )
                        ),
                        shadowColor: Colors.transparent.withOpacity(0.2),
                        child: Center(child: Text(
                          currenShop.toString(),
                          style: TextStyle(
                              fontSize: size.height  *0.02
                          ),
                        ))
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
  Widget mixApartment(String projectName, BuildContext context,ProjectNameList projectNameList,int index,ProjectRetrieve projectProvider){
    final size = MediaQuery.of(context).size;
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            projectName.toString(),
            style: TextStyle(
              color:  Theme.of(context).primaryColor,
              //color: CommonAssets.AppbarTextColor,
              fontWeight: FontWeight.bold,
              fontSize: size.height *0.035,

            ),
          ),

          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 1,
          ),

          Expanded(
            child: ListView.builder(
                itemCount: projectNameList.Structure[index]['FlatPerFloor'].length,

                itemBuilder: (context,indexFloor){
                  int currentFloorStartingNumer = (indexFloor +1)*100;
                  // return Text(currentFloorStartingNumer.toString());
                  return Container(
                    height: size.height *0.05,
                    child: ListView.builder(

                      itemCount: projectNameList.Structure[index]['FlatPerFloor'][indexFloor],

                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,flatIndex){
                        int currentFlat = (flatIndex +1)+ currentFloorStartingNumer;

                        return Container(
                          width: size.width /projectNameList.Structure[index]['FlatPerFloor'][indexFloor],
                          child: GestureDetector(
                            onTap: (){
                              projectProvider.customerUploadData(projectName,currentFlat);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //   color:
                                //   !snapshot.data[index].numberOfFlats[indexFloor].cusLists[flatIndex].isLoanOn?
                                //   Theme.of(context).primaryColor:CommonAssets.boxBorderColors
                                // )
                              ),
                              child: Center(child: Text(currentFlat.toString())),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),

          SizedBox(height: size.height *0.01,),

        ],
      ),
    );
  }
}


