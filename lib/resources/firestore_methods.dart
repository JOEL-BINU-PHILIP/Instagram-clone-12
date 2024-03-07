import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //upload post
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'some Error occured';
    try {
      String postURL =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        postURL: postURL,
        uid: uid,
        caption: caption,
        postId: postId,
        profileImage: profileImage,
        username: username,
        datePublished: DateTime.now().toString(),
        Likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
      return res;
    } catch (e) {
      res = e.toString();
      return res;
    }
  }
  Future<void> likePost(String postId , String uid , List likes) async{
    try {
      if (likes.contains(uid)) {
        print(uid);
        await _firestore.collection('posts').doc(postId).update({
          'Likes': FieldValue.arrayRemove([uid])
        });
      }
      else{
        print(uid);
         await _firestore.collection('posts').doc(postId).update({
          'Likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
   
  // We are storing uid and name because we want to add the additional functionality that if we click the username then we have to go the profile of the user 
  Future<void> postComment(String postId , String text , String uid , String username , String profilePic) async {
    try {
      if(text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'commentText' : text,
          'profilePic': profilePic,
          'username' : username,
          'uid' : uid,
          'commentId' : commentId,
          'datePublished' : DateTime.now(),
        });
      }
      else{
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }
   
   // Deleting a Post
   //Try to follw the res= 'success' format here it is very easy to debug
   Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
   }

   Future<void> followUser(String uid , String followId) async{
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];
      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid])
          });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId])
          });       
      } else{
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid])
          });  
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId])
          });              
      }
    } catch (e) {
      print(e.toString());
    }
   }
}
