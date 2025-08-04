import 'dart:convert';

import 'package:http/http.dart';

class New{
static const String apiUrl = "https://localhost:7218/api/Utilisateur?role=3&etabId=0";
static Future<List> getAllProducts() async
{
Response response =await get(Uri.parse(apiUrl));
List body=[];
if(response.statusCode == 200)
{ //créer une liste vide

//convertir chaine json en List de Map
var  body = jsonDecode(response.body);





}
return body;
}

}