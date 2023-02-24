import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFF01C7D2)),
      )
       : SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 60),
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
               const SizedBox(height: 10,),
               const Text(
                "Login now to see what they are talking!",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
               ),
                const SizedBox(height: 40,),
                Image.asset("assets/chat.png" ),
                const SizedBox(height: 40,),
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
                      print(email);
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
                      print(password);
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
                    login();
                  },
                  child: const Text(
                    "Sign In" ,
                    style: TextStyle(
                      fontSize: 16),
                      ),
                  ),
               ),
               const SizedBox(height: 10,),
               Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register here",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        nextScreen(context,  RegisterPage());
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
  login() async {
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameAndPassword(email, password)
      .then((value) async {
        if(value == true){
         QuerySnapshot snapshot = 
         await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
         .gettingUserData(email);
         //  saving value to shared preferences
         await  HelperFunction.saveUserLoggedInStatus(true);
         await HelperFunction.saveUserEmailSf(email);
         await HelperFunction.saveUserNameSf(snapshot.docs[0]['fullName']);
         nextScreenReplace(context, HomePage());

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