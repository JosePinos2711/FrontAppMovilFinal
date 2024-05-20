import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_state.dart'; // Importa el singleton de estado de usuario
import 'editpublicationscreen.dart'; // Importa la pantalla de edición de publicaciones

class ManagePublicationsScreen extends StatefulWidget {
  @override
  _ManagePublicationsScreenState createState() => _ManagePublicationsScreenState();
}

class _ManagePublicationsScreenState extends State<ManagePublicationsScreen> {
  List<Map<String, String>> _publications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPublications();
  }

  Future<void> _loadPublications() async {
    final userId = UserState().id;
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/vehicles/filtrar/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> vehicles = jsonDecode(response.body);
          final List<Map<String, String>> publications = vehicles.map((dynamic vehicle) {
            return {
              'id': vehicle['id'].toString(),
              'type': vehicle['type']?.toString() ?? 'Sin tipo',
              'title': vehicle['brand']?.toString() ?? 'Sin marca',
              'mileage': vehicle['mileage']?.toString() ?? '0',
              'color': vehicle['color']?.toString() ?? 'Sin color',
              'plate': vehicle['plate']?.toString() ?? 'Sin placa',
              'description': vehicle['description']?.toString() ?? 'Sin descripción',
              'image': vehicle['imagen']?.toString() ?? '',
            };
          }).toList();

          setState(() {
            _publications = publications;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar las publicaciones')),
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
  }

  Future<void> _deletePublication(int index) async {
    final publicationId = _publications[index]['id'];
    if (publicationId != null) {
      try {
        final response = await http.delete(
          Uri.parse('http://10.0.2.2:8080/api/vehicles/eliminar/$publicationId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 204) {
          setState(() {
            _publications.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Publicación eliminada correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la publicación')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  void _editPublication(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPublicationScreen(publication: _publications[index])),
    );

    if (result == true) {
      _loadPublications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Publicaciones', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _publications.isEmpty
              ? Center(child: Text('No hay publicaciones'))
              : ListView.builder(
                  itemCount: _publications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: _publications[index]['image']!.isNotEmpty
                            ? Image.network(
                                _publications[index]['image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 50, color: Colors.grey),
                        title: Text(
                          _publications[index]['title']!,
                          style: TextStyle(color: Colors.orange, fontFamily: 'Pixel', fontSize: 18),
                        ),
                        subtitle: Text(
                          _publications[index]['description']!,
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editPublication(context, index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePublication(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
