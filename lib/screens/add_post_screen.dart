import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

//The _selectImage function is to return a DialogBox on which the user can chose to
//take the photo from gallery or camera or something else.
  bool _isLoading = false;
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  void postImage(String caption , Uint8List image , String uid) async {
        setState(() {
          _isLoading = true;
        });
      try {
        String res = await FireStoreMethods().uploadPost(caption, _file!, uid, usernameReturn(), profilePicsReturn() as String);
        setState(() {
          _isLoading = false;
        });
        if (res == 'success') {
          showSnackBar('Posted!', context);
          clearImage();
        }
        else{
          showSnackBar(res, context);
        }
      } catch (e) {
        showSnackBar(e.toString(), context);
      }
  }
  
  String uidReturn(){
        UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return userProvider.getUser!.uid;
  }
  
  String? profilePicsReturn() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return userProvider.getUser!.photoURL;
  }

  String usernameReturn() {
        UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
      return userProvider.getUser!.username;
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a  Post'),
            children: [
              SimpleDialogOption(
                //Here we are padding because otherwise all the options wil get squeezed together
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text('Take a photo'),
              ),
              SimpleDialogOption(
                //Here we are padding because otherwise all the options wil get squeezed together
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text('Choose from gallery'),
              ),
              SimpleDialogOption(
                //Here we are padding because otherwise all the options wil get squeezed together
                padding: const EdgeInsets.all(20),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  void clearImage() {
    _file =null;
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
                icon: const Icon(Icons.upload),
                onPressed: () => _selectImage(context)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    clearImage();
                  });
                },
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed:() => postImage(_descriptionController.text , _file! , uidReturn()),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePicsReturn() == null
                          ? 'thth'
                          : profilePicsReturn() as String),
                    ),
                    SizedBox(
                      // Here we are using media Query because we haave both mobile and a web Screen
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Write a  Caption ...',
                            border: InputBorder.none),
                        //The below property is to see how many columns the text can go
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
