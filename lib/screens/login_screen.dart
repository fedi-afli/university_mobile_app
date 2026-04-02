import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ScholarCheck")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 100,
                child: ElevatedButton(
                  child: const Text("Se connecter"),
                  onPressed: () async {
                    var url = Uri.parse("${baseUrl}/auth/login.php");

                    try {
                      var response = await http.post(
                        url,
                        body: {
                          "email": emailController.text.trim(),
                          "password": passwordController.text,
                        },
                      );

                      
                      var data = json.decode(response.body);

                      if (data['success'] == 1) {
                        
                        String role = data['data'][0]['role'];
                        //var d = data['data'];
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        // 2. Save the user's data locally (THIS IS YOUR "SESSION")
                        await prefs.setBool('isLoggedIn', true);
                        await prefs.setString(
                          'userId',data['data'][0]['id'].toString(),
                        );
                        await prefs.setString('userRole', role);

                        if (role == 'admin') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/admin_home',
                            arguments: 0,
                          );
                        } else if (role == 'enseignant') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/enseignant_home',
                           
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            '/etudiant_home',
                       
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(data['message'])),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("erreur: cannot connect to server "),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("dispose appelé");
    super.dispose();
  }
}



