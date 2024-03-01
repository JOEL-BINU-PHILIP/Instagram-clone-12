import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  const Post({
    required this.postURL,
    required this.uid,
    required this.caption,
    required this.postId,
    required this.profileImage,
    required this.username,
    required this.datePublished,
    required this.likes,
  });
  final String uid;
  final String postURL;
  final String datePublished;
  final String caption;
  final String postId;
  final String profileImage;
  final String username;
  final likes;

  Map<String, dynamic> toJson() => {
        'datePublished': datePublished,
        'uid': uid,
        'postId': postId,
        'caption': caption,
        'profileImage': profileImage,
        'username': username,
        'postURL': postURL,
        'likes' :likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      uid: snapshot['uid'],
      caption: snapshot['caption'],
      postId: snapshot['postId'],
      profileImage: snapshot['profileImage'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      postURL: snapshot['postURL'],
      likes: snapshot['likes']
    );
  }
}
