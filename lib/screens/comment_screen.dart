import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/Widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.snap});
  final snap;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }
  String? profilePicsReturn() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return userProvider.getUser!.photoURL;
  }

  String usernameReturn() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return userProvider.getUser!.username;
  }

  String uidReturn() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return userProvider.getUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Comments'),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(profilePicsReturn() as String),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${usernameReturn()}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStoreMethods().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    uidReturn(),
                    usernameReturn(),
                    profilePicsReturn() as String,
                  );
                  print(_commentController.text);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8),
                  child: const Text('Post',
                      style: TextStyle(color: blueColor)),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished', descending: true)
              .snapshots(includeMetadataChanges: true),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('effrfrf');
              print(snapshot.data);
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      CommentCard(snap: snapshot.data!.docs[index].data()));
            }
          }),
    );
  }
}
