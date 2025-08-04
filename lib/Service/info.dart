import 'dart:convert';

import 'package:http/http.dart' as http;
class UserService {
  static Future<Map<String, dynamic>?> getEmpIdAndDayOffByUserId(String userId) async {
    final url = Uri.parse('https://localhost:7218/api/Utilisateur/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final employe = responseData['employe'];
      final empId = employe['empId'];
      final dayOff = employe['dayOff'];
      return {'empId': empId, 'dayOff': dayOff};
    } else {
      // Si la requête échoue, renvoyer null
      return null;
    }

  }

}