import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textfield_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SPACE BETWEEN TOP AND 1ST WIDGET
                Flexible(
                  flex: 2,
                  child: Container(),
                ),

                // LOGO OF INSTAGRAM
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 64,),

                // CIRCLE AVATAR FOR ACCOUNT IMAGE
                Stack(
                  children: [
                    // CIRCLE AVATAR ACCOUNT IMAGE
                    _image!=null ?
                      CircleAvatar(
                        backgroundImage: MemoryImage(_image!),
                        radius: 64,
                      ) :
                      const CircleAvatar(
                        radius: 64,
                        child: Icon(Icons.account_circle),
                      ),

                    // ADD A PROFILE PHOTO ICON
                    Positioned(
                      top: 95,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24,),

                // TEXT FIELD FOR USERNAME
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter Your Username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24,),

                // TEXT FIELD FOR EMAIL
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter Your Email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24,),

                // TEXT FIELD FOR PASSWORD
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter Your Password",
                  textInputType: TextInputType.text,
                  isPassword: true,
                ),
                const SizedBox(height: 24,),

                // TEXT FIELD FOR BIO
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter Your Bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24,),

                // LOGIN BUTTON
                InkWell(
                  onTap: singUpUser,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading ?
                      const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ) :
                      const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 12,),

                Flexible(
                  flex: 2,
                  child: Container(),
                ),

                // DON'T HAVE AN ACCOUNT TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already have an Acount?"),
                    ),

                    // SIGN IN BUTTON
                    GestureDetector(
                      onTap: navigateToLogIn,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Sign in.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);     // THIS WILL CALL THE GALLERY AND USER CAN SELECT A PHOTO FROM IT
    setState(() {
      _image = image;
    });
  }

  // THIS WILL SIGN UP THE USER
  void singUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if(_image == null){
      showSnackBar(content: "Please add all the details", context: context);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    String res = await AuthMethods().signupUser(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
        bio: _bioController.text.toString(),
        username: _usernameController.text.toString(),
        file: _image!
    );
    setState(() {
      _isLoading = false;
    });
    if(res != 'success') showSnackBar(content: res, context: context);
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        )
      );
    }
  }

  // THIS WILL NAVIGATE USER TO THE LOGIN SCREEN
  void navigateToLogIn() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        )
    );
  }

}
