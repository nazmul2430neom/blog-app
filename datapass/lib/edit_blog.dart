import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditBlog extends StatefulWidget {
  const EditBlog({Key? key}) : super(key: key);

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {

  final Stream<QuerySnapshot> _detailsStream=FirebaseFirestore.instance.collection("blog1").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Blog Details"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _detailsStream,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            print("Something wrong");
          }

         if(snapshot.connectionState==ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(color: Colors.red,));
         }

         return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Container(
              height: 400,
              child: Card(
                elevation:10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(data["image"],
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                          ),
                        ),
                      )
                      ),
                      SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                            child: Text(data["title"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                         SizedBox(height: 8,),
                         Container(
                          child: Text(data["des"],maxLines: 4,),
                         ),

                        InkWell(
                          onTap: () {
                            customDialog(context, data["image"], data["title"], data["des"]);
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepOrangeAccent,
                              ),
                              child: Text("See More"),
                            ),
                          ),
                        )
                      
                        ],
                      )
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
         );

        }
      ),

    );
  }

 customDialog(context,String img,String title,String des){
  return showDialog(
     context: context,
     builder: (BuildContext context){
      return Dialog(
        child: Container(
           child: SingleChildScrollView(
             child: Column(
              children: [
                 ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(img),
                 ),
                 SizedBox(height: 8,),
                 Container(
                  child: Text(title,style: TextStyle(fontSize: 20),),
                 ),
                SizedBox(height: 8,),
                Container(
                  child: Text(des,style: TextStyle(fontSize: 16),),
                 ),

              ],
             ),
           ),
        ),
      );
     }
     );
 }

}