import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CarAnimationScreen.dart'; // Importa la pantalla de animación del carrito
import 'login_screen.dart'; // Importa la pantalla de inicio de sesión
import 'userdatascreen.dart'; // Importa la pantalla de datos del usuario
import 'publishvehiclescreen.dart'; // Importa la pantalla de publicar vehículo
import 'managepublicationsscreen.dart'; // Importa la pantalla de gestión de publicaciones
import 'user_state.dart'; // Importa el singleton de estado de usuario

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> _vehicles = [];
  List<Map<String, String>> _filteredVehicles = [];
  bool _isLoading = true;
  String _selectedCategory = 'Todos';
  String _searchBrand = '';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/vehicles/listar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> vehicles = jsonDecode(response.body);
        setState(() {
          _vehicles = vehicles
              .map((dynamic vehicle) {
                return {
                  'brand': vehicle['brand']?.toString() ?? 'Sin marca',
                  'description': vehicle['description']?.toString() ?? 'Sin descripción',
                  'imagen': vehicle['imagen']?.toString() ?? '',
                  'type': vehicle['type']?.toString() ?? '',
                };
              })
              .where((vehicle) => vehicle['imagen']!.isNotEmpty)
              .toList();
          _filteredVehicles = List.from(_vehicles);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los vehículos')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredVehicles = _vehicles.where((vehicle) {
        final matchesCategory = _selectedCategory == 'Todos' || vehicle['type'] == _selectedCategory;
        final matchesBrand = _searchBrand.isEmpty || vehicle['brand']!.toLowerCase().contains(_searchBrand.toLowerCase());
        return matchesCategory && matchesBrand;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Todos';
      _searchBrand = '';
      _filteredVehicles = List.from(_vehicles);
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CarAnimationScreen(destination: LoginScreen())),
    );
  }

  void _navigateToUserData(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDataScreen()),
    );
  }

  void _navigateToPublishVehicle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublishVehicleScreen()),
    );
  }

  void _navigateToManagePublications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManagePublicationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? username = UserState().username;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.orange),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Filtrar vehículos'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          items: <String>['Todos', 'Nuevo', 'Usado']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Marca'),
                          onChanged: (value) {
                            setState(() {
                              _searchBrand = value;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.of(context).pop();
                        },
                        child: Text('Aplicar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _resetFilters();
                          Navigator.of(context).pop();
                        },
                        child: Text('Reset'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.pinkAccent,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    username ?? 'Usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Pixel',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.orange),
              title: Text('Datos del Usuario', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
                _navigateToUserData(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.orange),
              title: Text('Publicar Vehículo', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
                _navigateToPublishVehicle(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_search, color: Colors.orange),
              title: Text('Gestión de Publicaciones', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
                _navigateToManagePublications(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.orange),
              title: Text('Inicio', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.orange),
              title: Text('Tareas', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.orange),
              title: Text('Calendario', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.orange),
              title: Text('Grupos', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.orange),
              title: Text('Configuración', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.orange, fontFamily: 'Pixel')),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Bienvenido a tu Dashboard!',
                style: TextStyle(fontSize: 24, color: Colors.orange, fontFamily: 'Pixel'),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredVehicles.isEmpty
                    ? Center(child: Text('No hay vehículos'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredVehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = _filteredVehicles[index];
                          return Card(
                            margin: EdgeInsets.all(10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15),
                              title: Text(
                                vehicle['brand']!,
                                style: TextStyle(color: Colors.orange, fontFamily: 'Pixel', fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicle['description']!,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Image.network(
                                      vehicle['imagen']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Text('Error al cargar la imagen');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
