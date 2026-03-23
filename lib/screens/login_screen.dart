import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to get text from the inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GestAbsence Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController, 
              decoration: const InputDecoration(labelText: "Email")
            ),
            TextField(
              controller: passwordController, 
              decoration: const InputDecoration(labelText: "Mot de passe"),
              obscureText: true, // Hides password characters
            ),
            const SizedBox(height: 30),
            
            // --- THE LOGIN BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Se connecter"),
                onPressed: () async {
                  // 1. Prepare the URL (10.0.2.2 for Android Emulator)
                  var url = Uri.parse("http://localhost/gest_absence_api/auth/login.php");

                  try {
                    // 2. Send the POST request to your PHP
                    var response = await http.post(url, body: {
                      "email": emailController.text.trim(),
                      "password": passwordController.text,
                    });

                    // 3. Decode the JSON response
                    var data = json.decode(response.body);

                    if (data['success'] == 1) {
                      
                      String role = data['data'][0]['role'];
                      
                    
                      if (role == 'admin') {
                        Navigator.pushReplacementNamed(context, '/admin_home');
                      } else if (role == 'enseignant') {
                        Navigator.pushReplacementNamed(context, '/enseignant_home');
                      } else {
                        Navigator.pushReplacementNamed(context, '/etudiant_home');
                      }
                    } else {
                    
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(data['message'])),
                      );
                    }
                  } catch (e) {
                    // Connection Error (Server offline or wrong IP)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Impossible de contacter le serveur PHP")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}