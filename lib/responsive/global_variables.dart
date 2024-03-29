import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
const webScreenSize = 600;

var homeScreenItems = [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('notifs'),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
];