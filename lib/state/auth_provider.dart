
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_app/data/services/auth_api_service.dart';

class AuthProvider extends ChangeNotifier{

  bool isChecking = true;
  bool isAuthenticated = false;
  bool isLoading = false;
  String? token;
  String? error;
  final AuthApiService _authApiService = AuthApiService();

  static const _tokenKey = "auth_token";
  final _storage = const FlutterSecureStorage();

  AuthProvider(){
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async{

    final result = await _storage.read(key: _tokenKey);

    if(result!=null){
      this.token = result;
      isAuthenticated = true;
    }
    else{
      isAuthenticated = false;
    }
    isChecking = false;
    notifyListeners();

  }

  Future<void> login(String username,String password) async{
    isLoading = true;
    error = null;
    notifyListeners();
    try{
      token = await _authApiService.login(username, password);
      await _storage.write(key: _tokenKey, value: token);
      isAuthenticated = true;
    }
    catch(e){
      print(e);
      error = "Cannot login";
      isAuthenticated = false;
    }
    finally{
      isLoading = false;
    }
    notifyListeners();


  }

  Future<void> logout() async{
    await _storage.delete(key: _tokenKey);
    token = null;
    isAuthenticated = false;
    error = null;
    notifyListeners();
  }


}