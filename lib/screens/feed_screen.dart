// import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/post_card.dart';
import 'package:instagram_clone/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  // // StreamController<QuerySnapshot> _localStreamController =
  // //     StreamController.broadcast();
  // @override
  // void initState() {
  //   super.initState();
  //   // _localStreamController.stream.listen((event) => print(event));
  //   // FirebaseFirestore.instance.collection('posts').snapshots().listen(
  //   //     (QuerySnapshot snapshot) => _localStreamController.add(snapshot));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/instagram.png',
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .snapshots(includeMetadataChanges: true),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('effrfrf');
            print(snapshot.data);
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: snapshot.data!.docs[index].data()));
          }
          else{
            return const Placeholder();
          }
        },
      ),
    );
  }
}
