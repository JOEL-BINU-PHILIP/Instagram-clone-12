import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  //You should always make the User? variable(instance) aa private field because it will cause bugs in the future and
  //because ther is one class called UserProvider which was given by the provider package  using this we access data from the User? 
  //variable which will cause problems in our app
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  //The below line of code is a function in which the get the data of the user using the user model folder
   User? get getUser => _user;
   getUserDetails() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    print(user.photoURL);
    notifyListeners();
   }
  //Why we are doing this method is because suppose we change the username directly from firebase(firestore database), and then for it to be displayed
  //in the mobile-screen-Layout screen and web Screen Layout without restarting the app. 
  // Future<void> refreshUser() async{
  //   User users  = await _authMethods.getUserDetails();
  //   print('patti');
  //   print(users.email);
  //   _user = users;
  //   print(_user!.bio);
  //   print(_user!.photoURL);
  //   notifyListeners();
  // }
}