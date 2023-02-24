import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widget/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ?  Center(
        child: CircularProgressIndicator(color: Color(0xFF01C7D2),)
       )
       : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 70),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
               const Text(
                "Group Chat",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35
                ),
               ),
               const SizedBox(height: 5,),
               const Text(
                "Create your account now to chat and explore",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
               ),
                const SizedBox(height: 30,),
                Image.asset("assets/mobChat.png" ),
                const SizedBox(height: 40,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon:const Icon(
                      Icons.person,
                      color: Color(0xFF01C7D2),
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val){
                    if(val!.isNotEmpty){
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                ),

                const SizedBox(height: 15,),

                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon:const Icon(
                      Icons.email,
                      color: Color(0xFF01C7D2),
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },

                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val!) ? null : "Please enter a valid email";
                  },
                ),

                const SizedBox(height: 15,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon:const Icon(
                      Icons.lock,
                      color: Color(0xFF01C7D2),
                      ),
                  ),
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },

                  validator: (val){
                    if(val!.length < 6){
                      return "Please must be at least 6 characters";
                    }else {
                      return null;
                    }
                  },
                ),
               const SizedBox(height: 20,),
               SizedBox(
                width: double.infinity,
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF01C7D2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  onPressed: (){
                    register();
                  },
                  child: const Text(
                    "Register" ,
                    style: TextStyle(
                      fontSize: 16),
                      ),
                  ),
               ),
               const SizedBox(height: 10,),
               Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Login now",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        nextScreen(context,  LoginPage());
                      },
                    ),
                  ],
                ),
               ),
              ],
            )),
        ),
      ),
    );
  }
  register() async {
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password)
      .then((value) async {
        if(value == true){
         await HelperFunction.saveUserLoggedInStatus(true);
         await HelperFunction.saveUserEmailSf(email);
         await HelperFunction.saveUserNameSf(fullName);
         nextScreenReplace(context,  HomePage());

        } else{
          showSnackBar(context , Color(0xFFCCE0E3) , value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}