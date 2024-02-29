import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/webScreenLayout.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Method to login the user
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      print(res);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    } else {
      //
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Method for if not logged in then go to sign up screen
  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //svg image
            Image.asset(
              'assets/instagram.png',
              height: 64,
            ),
            const SizedBox(
              height: 64,
            ),
            //text field input for email
            TextfieldInput(
              hintText: 'Enter your Email',
              isPass: false,
              inputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            //text field for password
            TextfieldInput(
              hintText: 'Enter Your Password',
              isPass: true,
              inputType: TextInputType.text,
              textEditingController: _passwordController,
            ),
            const SizedBox(
              height: 24,
            ),
            //button Login
            TextButton(
              onPressed: loginUser,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                child: _isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Center(
                        child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      )),
              ),
            ),
            const SizedBox(height: 12),

            //Transitioning to signing up
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an Account ?"),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            )
          ],
        ),
      )),
    );
  }
}
