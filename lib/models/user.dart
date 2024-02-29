
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User(
      {required this.photoURL,
      required this.uid,
      required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.username});
  final String uid;
  final String? photoURL;
  final String username;
  final String bio;
  final String email;
  final List followers;
  final List following;

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
        'photoURL': photoURL
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      username: snapshot['username'],
      photoURL: snapshot['photoURL'],
    );
  }
}
