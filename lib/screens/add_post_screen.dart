import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
//The _selectImage function is to return a DialogBox on which the user can chose to
//take the photo from gallery or camera or something else.
  Uint8List? _file;

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
              )
            ],
          );
        });
  }
  @override

  @override
  Widget build(BuildContext context) {

    final UserProvider user   =  Provider.of<UserProvider>(context);
    print(user.getUser!.bio);
    return _file == null
        ? Center(
            child: IconButton(icon: const Icon(Icons.upload), onPressed:() => _selectImage(context)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {},
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.getUser!.photoURL as String),
                    ),
                    SizedBox(
                      // Here we are using media Query because we haave both mobile and a web Screen
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
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
                              image: AssetImage('assets/avatar.png'),
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
