import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Pages/Project/AboutProject/ProjectInfo.dart';
import 'package:gpgroup/Providers/Project/ProjectName.dart';
import 'package:gpgroup/Service/Database/Retrieve/ProjectDataRetrieve.dart';
import 'package:provider/provider.dart';
class Sites extends StatefulWidget {
  @override
  _SitesState createState() => _SitesState();
}

class _SitesState extends State<Sites> {
  @override
  Widget build(BuildContext context) {
    ProjectRetrieve projectProvider = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(

        body: StreamBuilder<List<ProjectNameList>>(
          stream: ProjectRetrieve().PROJECTNAMELIST,
          builder: (context,projectNameSanpshot){

            if(projectNameSanpshot.hasData){
              return ListView.builder(

                  itemCount: projectNameSanpshot.data.length,
                  itemBuilder: (context,projectNameIndex){
                    String ProjectNameUpperCase = projectNameSanpshot.data[projectNameIndex].projectName.substring(0,1).toUpperCase().toString()+projectNameSanpshot.data[projectNameIndex].projectName.substring(1).toString();
                    return Card(

                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: CommonAssets.boxBorderColors,
                              width: 0.1)),
                      child: ListTile(
                        onTap: (){
                            projectProvider.setProjectName(projectNameSanpshot.data[projectNameIndex].projectName,projectNameSanpshot.data[projectNameIndex].typeofBuilding);
                        // projectProvider.setProjectName(projectNameSanpshot.data[projectNameIndex].projectName);
                        // print( "Project Name" +projectProvider.projectName);
                          return    Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ProjectInfo(projectProvider: projectProvider),
                            transitionDuration: Duration(seconds: 0),
                          ),);
                        },
                        leading: CircleAvatar(

                          backgroundImage: NetworkImage(
                            projectNameSanpshot.data[projectNameIndex].imagesUrl[0],


                          ),
                        ),
                        title:  Text(ProjectNameUpperCase,maxLines: 1,),
                        subtitle:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(projectNameSanpshot.data[projectNameIndex].landmark,maxLines: 1,),
                            Text(projectNameSanpshot.data[projectNameIndex].typeofBuilding,maxLines: 1,)
                          ],
                        ),
                        


                      ),
                    );
                  });
            }
            else if(projectNameSanpshot.hasError){
              return Container(child: Center(
                child: Text(CommonAssets.snapshoterror.toString()),
              ));
            }
            else{
              return CircularLoading();
            }
          },
        )




    );
  }
}


