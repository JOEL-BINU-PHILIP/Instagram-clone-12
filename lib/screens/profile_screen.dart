import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/Follow_Button.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen =0;
  int followers =0;
  int following = 0;
  bool isFollowing = false;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    try {
      var UserSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid' , isEqualTo: widget.uid).get();
      setState(() {
        postLen = postSnap.docs.length;
        userData = UserSnap.data()!;
        followers = UserSnap.data()!['followers'].length;
        following = UserSnap.data()!['following'].length;
        isFollowing = UserSnap.data()!['followers'].contains(widget.uid);
      });
    } catch (e) {
      print(e.toString());
      showSnackBar(e.toString(), context);
    }
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title:
            Text(userData['username'] == null ? 'dead' : userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.png'),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStateColumn(postLen, "posts"),
                          buildStateColumn(followers, "followers"),
                          buildStateColumn(following, "following"),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('ede'),
                    ),
                    Expanded(
                      child: FirebaseAuth.instance.currentUser!.uid ==widget.uid ? FollowButton(
                        backgroundColor:  Color(0xFF1F1F1F) ,
                        borderColor: Colors.grey,
                        textColor: primaryColor,
                        text: 'Edit Profile',
                        function: () {},
                      ) : isFollowing ? FollowButton(
                        backgroundColor: Color(0xFF1F1F1F),
                        borderColor: Colors.grey,
                        textColor: primaryColor,
                        text: 'Unfollow',
                        function: () {},
                      ) : FollowButton(
                        backgroundColor: Colors.blue,
                        borderColor: Colors.grey,
                        textColor: primaryColor,
                        text: 'Unfollow',
                        function: () {},
                    ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'] == null ? 'dead' : userData['bio'],
                    style:const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
