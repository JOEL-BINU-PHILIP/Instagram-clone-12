import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // adding an image to firebase storage 
  Future<String> uploadImageToStorage(String childName, Uint8List file , bool isPost) async{
   Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
   //Upload the file
   //With this UploadTask we have the ability to control how our file is bieng uploade to the Firebase Storage 
   UploadTask uploadTask = ref.putData(file);
   //and with this upload task we can get a TasKSnapshot 
   TaskSnapshot snap = await uploadTask;
   //So basically this will fetch us the download url of the file that we are uploading to the fireStore database,  
   //and using this url we can display the same profile picture to other users by using a network Image also 
   String downloadUrl =await snap.ref.getDownloadURL();
   return downloadUrl;
  }
} 