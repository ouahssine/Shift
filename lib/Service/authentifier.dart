import 'dart:convert';
import 'package:http/http.dart';
import 'package:shift/Model/login.dart';

class AuthService {
  static const String apiUrl = "https://localhost:7218/api/Utilisateur";

  static Future<String> Login(login l) async{
    var headers ={'Content-Type':'application/json;charset=UTF-8'} ;
    var body = jsonEncode(l); //appel implicit de la fonction toJson de Product
    Response response = await post(Uri.parse(apiUrl+"/login"), headers: headers, body:body);


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to login');
    }
  }
}