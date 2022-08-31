import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 final Stream<QuerySnapshot> _madStream=FirebaseFirestore.instance.collection("mad4").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _madStream,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            print("Something wrong");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.red,));
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Card(
                elevation: 10,
                color: Colors.blue.withOpacity(0.9),
                child: ListTile(
                  title: Text('${data["first_name"]}'),
                  subtitle: Text('${data["last_name"]}'),
                ),
              );

            }).toList(),
          );
        }
        ),
    );
  }
}