import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
const webScreenSize = 600;

const homeScreenItems = [
          FeedScreen(),
          Text('searched'),
          AddPostScreen(),
          Text('notifs'),
          Text('profile')
];