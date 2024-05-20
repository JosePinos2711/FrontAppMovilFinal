import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_state.dart'; // Importa el singleton de estado de usuario

class UserDataScreen extends StatefulWidget {
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userId = UserState().id;
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/users/buscar/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          setState(() {
            _usernameController.text = userData['username'];
            _firstNameController.text = userData['firstName'];
            _lastNameController.text = userData['lastName'];
            _emailController.text = userData['email'];
            _ageController.text = userData['age'].toString();
            _cityController.text = userData['city'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar los datos del usuario')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  void _saveUserData() {
    final username = _usernameController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final age = _ageController.text;
    final city = _cityController.text;

    // Aquí solo mostramos un mensaje en consola a modo de prueba
    print('Username: $username');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Email: $email');
    print('Age: $age');
    print('City: $city');

    // Añade aquí la lógica para guardar la información del usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos del Usuario', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
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
                  _buildTextField(_ageController, 'Age'),
                  SizedBox(height: 20),
                  _buildTextField(_cityController, 'City'),
                  SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
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
