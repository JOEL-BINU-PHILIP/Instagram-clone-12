import 'package:instagram_clone/models/user.dart' as model;
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // A function for getting the user details
  Future<model.User> getUserDetails() async{
    User currentUser =_auth.currentUser!;
    print("======${currentUser}");
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    print(currentUser.uid);
    print(currentUser.photoURL);
    print(snap);
    return model.User.fromSnap(snap);
  }

  //sign up the user  For SignUp Authentication
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = "Some Error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) 
          {
          print('signUp-------------------------------------------------------------------------------------------------------------------------------');
        //register user        
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoURL = await StorageMethods()
            .uploadImageToStorage('profilePics', file!, false);
          print('signUp2-------------------------------------------------------------------------------------------------------------------------------');
        model.User user = model.User(
          photoURL: photoURL,
          uid: cred.user!.uid,
          bio: bio,
          email: email,
          followers: [],
          following: [],
          username: username,
        );

        //add user to our database

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson()
                //Instead of doing this we modularise our data
                // 'username': username,
                // 'uid': cred.user!.uid,
                // 'email': email,
                // 'bio': bio,
                // 'followers': [],
                // 'following': [],
                // 'photoURL': photoURL
                );
        //The below method u can use to keep the user more safe and secure it is more better as, In the collection users each of the users will have a unique id and in the above method the document uid of the of each user is
        // same as the unique id of each entry in the collection users, but in the below method both the unique id of each entry of the users collection is not same as the document uid of each user.
        //  await _firestore.collection('users').add({
        //     'username': username,
        //     'uid': cred.user!.uid,
        //     'email': email,
        //     'bio': bio,
        //     'followers' : [],
        //     'following' :[]
        //  });
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      res = 'FireBase Error$err';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // For Login Authentication
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the credentials properly";
      }
    } on FirebaseException catch (e) {
      res = 'FireBase Exception$e';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
