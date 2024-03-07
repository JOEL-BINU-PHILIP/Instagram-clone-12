import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/Follow_Button.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
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
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var UserSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
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
    setState(() {
      isLoading = false;
    });
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(userData['username'] ?? 'dead'),
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
                              backgroundImage: NetworkImage(userData[
                                      'photoURL'] ??
                                  'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI='),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(userData['username'] ?? 'dead'),
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    backgroundColor: Color(0xFF1F1F1F),
                                    borderColor: Colors.grey,
                                    textColor: primaryColor,
                                    text: 'Sign out',
                                    function: () async{
                                        await AuthMethods().signOut();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> LoginScreen()));
                                    },
                                  )
                                : isFollowing
                                    ? FollowButton(
                                        backgroundColor: Color(0xFF1F1F1F),
                                        borderColor: Colors.grey,
                                        textColor: primaryColor,
                                        text: 'Unfollow',
                                        function: () async {
                                          await FireStoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData['uid']);
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      )
                                    : FollowButton(
                                        backgroundColor: Colors.blue,
                                        borderColor: Colors.white,
                                        textColor: primaryColor,
                                        text: 'Follow',
                                        function: () async {
                                          await FireStoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData['uid']);
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                        
                                        
                                      )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            userData['bio'] ?? 'dead',
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1.5,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap = snapshot.data!.docs[index];
                            return Image(
                              image: NetworkImage(snap['postURL']),
                              fit: BoxFit.fill,
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      })
                ],
              ),
            ),
          );
  }
}
