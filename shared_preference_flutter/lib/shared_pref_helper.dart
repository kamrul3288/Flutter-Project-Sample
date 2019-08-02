import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{
  void putValue(String key,String value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  Future<String> getValue(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  void clearSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void clearSinglePrefData(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}