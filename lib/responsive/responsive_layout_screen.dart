import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/global_variables.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key , required this.webScreenLayout , required this.mobileScreenLayout});
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }
    void addData() async {
      UserProvider userProvider = Provider.of<UserProvider>(context , listen: false);
     userProvider.getUser==null ? print('hello') : print('therndi');
      await userProvider.refreshUser();
      userProvider.getUser==null ? print('hello') : print('therndi');
    }
  @override 
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context , constraints) {
      if(constraints.maxWidth  > webScreenSize){
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}