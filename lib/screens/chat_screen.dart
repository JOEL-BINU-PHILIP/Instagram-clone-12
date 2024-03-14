import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  var userData = {};
  List<dynamic> followingUsersId = [];
  bool isLoading = false;
  int followers = 0;
  int following = 0;
  var followingUserData = {};
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

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var UserSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uidReturn())
          .get();
      setState(() {
        userData = UserSnap.data()!;
        followingUsersId = UserSnap.data()!['following'];
        followers = UserSnap.data()!['followers'].length;
        following = UserSnap.data()!['following'].length;
      });
      print(followingUsersId);
    } catch (e) {
      print(e.toString());
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<QuerySnapshot> getUsersData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('uid',
            whereIn:
                followingUsersId) // Use whereIn to check if uid is in followingUsersId list
        .get();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Title(
            color: Colors.white,
            child: Text(usernameReturn()),
          ),
          backgroundColor: mobileBackgroundColor,
        ),
        body: isLoading
            ? const CircularProgressIndicator() // Show loading indicator if data is being fetched
            : followingUsersId.isEmpty
                ? const Center(
                    child: Text("You are not following any users."),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10 , bottom: 10 , left:  20 , right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Messages",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height:
                                8), // Add some vertical space between "Messages" and the FutureBuilder
                        Expanded(
                          child: FutureBuilder(
                            future: getUsersData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Show loading indicator while waiting for data
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> userData = document
                                          .data() as Map<String, dynamic>;
                                      // Now you can access the data of each user here
                                      return ListTile(
                                        onTap: (){},
                                        leading: CircleAvatar(backgroundImage: NetworkImage(userData['photoURL'])),
                                        title: Text(userData['username']),
                                        // You can display other user details as required
                                      );
                                    }).toList(),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
