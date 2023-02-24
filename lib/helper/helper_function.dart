import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmaileKey = "USEREMAILEKEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSf(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSf(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmaileKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmaileKey);
  }

  static Future<String?> getUserNameFromSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}