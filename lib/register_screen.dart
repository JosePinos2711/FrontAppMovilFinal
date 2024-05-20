import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart'; // Importa la pantalla de inicio de sesión
import 'CarAnimationScreen.dart'; // Importa la pantalla de animación del carrito

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _usernameController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    final city = _cityController.text;

    // Aquí solo mostramos un mensaje en consola a modo de prueba
    print('Username: $username');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Email: $email');
    print('Password: $password');
    print('Age: $age');
    print('City: $city');

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'email': email,
          'age': age,
          'city': city,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CarAnimationScreen(destination: LoginScreen())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo blanco
          Container(
            color: Colors.white,
          ),
          // Contenido del registro
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 50, color: Colors.white), // Ícono de persona
                  ),
                  SizedBox(height: 30),
                  _buildTextField(_usernameController, 'Username'),
                  SizedBox(height: 20),
                  _buildTextField(_firstNameController, 'First Name'),
                  SizedBox(height: 20),
                  _buildTextField(_lastNameController, 'Last Name'),
                  SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email'),
                  SizedBox(height: 20),
                  _buildTextField(_passwordController, 'Password', obscureText: true),
                  SizedBox(height: 20),
                  _buildTextField(_ageController, 'Age', keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  _buildTextField(_cityController, 'City'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, // Fondo del botón
                      foregroundColor: Colors.white, // Color del texto del botón
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 10,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: Text(
                      'Back to Login',
                      style: TextStyle(color: Colors.orange, fontFamily: 'Pixel'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
