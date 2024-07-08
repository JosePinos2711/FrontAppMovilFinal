import 'package:app_flutter/reserve.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_state.dart';

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
    final userIdString = widget.vehicle['userId']; // Asegúrate de que esto sea 'userId'
    if (userIdString != null && userIdString.isNotEmpty) {
      try {
        final userId = int.parse(userIdString);
        _futureUser = fetchUser(userId);
      } catch (e) {
        print('Error al convertir userId a int: $e');
        _futureUser = Future.error('Invalid user ID');
      }
    } else {
      print('User ID is null or empty');
      _futureUser = Future.error('User ID is null or empty');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load user data: ${response.statusCode}');
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.vehicle['imagen'] ?? 'https://example.com/default_image.jpg'; // URL predeterminada
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    height: 200,
                    child: Center(
                      child: Text('Error al cargar la imagen'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para la reserva
              },
              child: Text('Confirmar Reserva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
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
                      Text('Datos del Publicador:'),
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
