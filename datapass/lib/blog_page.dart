import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final Stream<QuerySnapshot> _blogStream=FirebaseFirestore.instance.collection("blog1").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: StreamBuilder<QuerySnapshot>(
         stream: _blogStream,
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
                return Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                       Container(
                         height: 400,
                         child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Padding(
                            padding:  EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        child: Text(data["title"][0]),
                                      ),
                                    ),
                                   
                                   Text(data["title"],style: TextStyle(fontSize: 20),),
                                   Icon(Icons.more_horiz),

                                  ],
                                ),
                                

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      child: Image.network(data["image"]),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),

                                Expanded(
                                  child: Container(child: Text(data["des"],maxLines: 4,)),
                                  )

                              ],
                            ),
                          ),
                         ),
                       )
                    ],
                  ),
                );
                  
               }).toList(),
             );
         }
       )
    );
  }
}