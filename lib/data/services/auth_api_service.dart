
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthApiService {

  final String _baseUrl = "https://dummyjson.com/auth/login";

  Future<String> login(String username,String password) async{

    print(username);
    print(password);

    final url = Uri.parse(_baseUrl);

    final response = await http.post(url,
        headers: {
          'Content-Type' : 'application/json',
        },
        body: jsonEncode({
          'username' : username,
          'password' : password
        })
    );
    print(response.body);
    print(response.statusCode);
    if(response.statusCode ==200){
      final result = jsonDecode(response.body);
      String token = result['accessToken'];
      return token;
    }
    else{
      throw Exception("Login Failed");
    }

  }



}