import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/textfield_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,

          padding: MediaQuery.of(context).size.width > webScreenSize ?
                   EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3) :
                   const EdgeInsets.symmetric(horizontal: 32),

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

              // LOGIN BUTTON
              InkWell(
                onTap: logInUser,
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
                  const Text('Log In'),
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
                    child: const Text("Don't have an Acount?"),
                  ),

                  // SIGN UP BUTTON
                  GestureDetector(
                    onTap: (){
                      navigateToSignUp();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign up.",
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
    );
  }

  Future<void> logInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
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

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      )
    );
  }
}
