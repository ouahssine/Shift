import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shift/Service/authentifier.dart';
import '../Model/login.dart';
import '../Service/info.dart';
import '../Service/token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 250,
                    width: 200,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF7A90A4),
                    ),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Color(0xFFBED3C3),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF7A90A4),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color(0xFFBED3C3),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        login l = login(
                            username: usernameController.text,
                            password: passwordController.text);
                        print('00000');
                        var token = await AuthService.Login(l);
                        print('111111');

                        if (token != null) {
                          print("hello");
                          Global.t = token;

                          print('JWT Token: $token');
                          Map<String, dynamic> expirationDate = JwtDecoder.decode(token);
                          print(expirationDate);
                          Global.user = expirationDate['actort'];
                          Global.etb = expirationDate['etabID'];
                          final result = await UserService.getEmpIdAndDayOffByUserId(Global.user );
                          print('ID de l\'employé: ${result?['empId']}');
                          print('Jour de congé: ${result?['dayOff']}');
                          Global.emp = result?['empId']?.toString() ?? '';
                          Global.dayoff = result?['dayOff']?.toString() ?? '';


                          Navigator.pushReplacementNamed(context, '/index');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid username or password'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Username or Password invalid'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF344D59),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
