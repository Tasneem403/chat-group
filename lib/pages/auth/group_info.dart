import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

 const GroupInfo({
  Key? key,
  required this.groupId,
  required this.groupName,
  required this.adminName
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    .getGroupMembers(widget.groupId)
    .then((val){
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r ){
    return r.substring(r.indexOf("_") +1);
  }

  String getId(String res){
    return res.substring(0 , res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF01C7D2),
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                  barrierDismissible: false,
                  context: context ,
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Exit"),
                      content: const Text("Are you sure you exit the group?"),
                      actions: [
                        IconButton(
                          onPressed:(){
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),

                        IconButton(
                          onPressed:()async{
                            DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid
                            )
                            .toggleGroupjoin(
                              widget.groupId,
                              getName(widget.adminName) ,
                              widget.groupName).whenComplete(() {
                                nextScreenReplace(context, HomePage());
                              });

                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  }
                );
            },
            icon: const Icon(Icons.exit_to_app),
            )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF01C7D2).withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF01C7D2),
                    child: Text(
                      widget.groupName.substring(0 , 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5,),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context , AsyncSnapshot snapShot){
        if(snapShot.hasData){
          if(snapShot.data['members'] != null){
            if(snapShot.data['members'].length !=0){
              return ListView.builder(
                itemCount: snapShot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context , index){
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xFF01C7D2),
                        child: Text(
                          getName(snapShot.data['members'][index])
                          .substring(0 ,1)
                          .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      title: Text(getName(snapShot.data['members'][index])),
                      subtitle: Text(getId(snapShot.data['members'][index])),
                    ),
                  );
                }
              );
            } else{
              return const Center(
                child: Text("No MEMBERS"),
              );
            }
          } else {
            return const Center(
                child: Text("No MEMBERS"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF01C7D2),
            ),
          );
        }
      }
      );
  }
}