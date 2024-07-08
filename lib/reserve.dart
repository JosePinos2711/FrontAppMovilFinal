import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ReservaScreen extends StatefulWidget {
  final Map<String, String> vehicle;

  ReservaScreen({required this.vehicle});

  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  late Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser(int.parse(widget.vehicle['userId']!));
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/vehicles/buscar/1'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Vehículo'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservar el vehículo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Marca: ${widget.vehicle['brand']}'),
            Text('Descripción: ${widget.vehicle['description']}'),
            Text('Color: ${widget.vehicle['color']}'),
            Text('Kilometraje: ${widget.vehicle['mileage']}'),
            Text('Placa: ${widget.vehicle['plate']}'),
            Text('Tipo: ${widget.vehicle['type']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción al confirmar la reserva
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirmar Reserva'),
            ),
            SizedBox(height: 20),
            FutureBuilder<User>(
              future: _futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos del Publicador:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Nombre: ${user.firstName} ${user.lastName}'),
                      Text('Correo: ${user.email}'),
                      Text('Ciudad: ${user.city}'),
                      Text('Edad: ${user.age}'),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final String city;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      age: json['age'],
      city: json['city'],
    );
  }
}
