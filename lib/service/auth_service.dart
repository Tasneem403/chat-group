import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth fierbaseAuth = FirebaseAuth.instance;

  // login

  Future loginWithUserNameAndPassword( String email , String password) async {
    try{
      User user = (await fierbaseAuth.signInWithEmailAndPassword(
        email: email, password: password
        )).user!;

        if(user != null){
          return true;
        }
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
    String fullName , String email , String password
  ) async {
    try{
      User user = (await fierbaseAuth.createUserWithEmailAndPassword(
        email: email, password: password
        )).user!;

        if(user != null){
         await DatabaseService(uid: user.uid ).savingUserData(fullName, email);
          return true;
        }
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  // signout
  Future signOut() async{
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSf("");
      await HelperFunction.saveUserNameSf("");
      await fierbaseAuth.signOut();
    } catch (e){
      return null;
    }
  }
}