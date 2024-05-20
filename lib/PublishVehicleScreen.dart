import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_state.dart'; // Importa el singleton de estado de usuario

class PublishVehicleScreen extends StatefulWidget {
  @override
  _PublishVehicleScreenState createState() => _PublishVehicleScreenState();
}

class _PublishVehicleScreenState extends State<PublishVehicleScreen> {
  final _brandController = TextEditingController();
  final _mileageController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageURLController = TextEditingController();

  String? _imageUrl;
  String? _selectedType;

  @override
  void dispose() {
    _brandController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    _descriptionController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _showImageUrlDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ingrese la URL de la imagen'),
          content: TextField(
            controller: _imageURLController,
            decoration: InputDecoration(hintText: 'https://example.com/image.jpg'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _imageUrl = _imageURLController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _publishVehicle() async {
    final type = _selectedType;
    final brand = _brandController.text;
    final mileage = int.tryParse(_mileageController.text) ?? 0;
    final color = _colorController.text;
    final plate = _plateController.text;
    final description = _descriptionController.text;
    final imageUrl = _imageURLController.text;
    final userId = UserState().id;

    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/vehicles/agregar/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'type': type,
            'brand': brand,
            'mileage': mileage,
            'color': color,
            'plate': plate,
            'description': description,
            'imagen': imageUrl,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vehículo publicado con éxito')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al publicar el vehículo')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se ha podido obtener el ID del usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicar Vehículo', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: Stack(
        children: [
          // Fondo blanco
          Container(
            color: Colors.white,
          ),
          // Contenido del formulario
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showImageUrlDialog,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                      child: _imageUrl == null
                          ? Icon(Icons.directions_car, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildDropdownButton('Tipo', ['Nuevo', 'Usado']),
                  SizedBox(height: 20),
                  _buildTextField(_brandController, 'Marca'),
                  SizedBox(height: 20),
                  _buildTextField(_mileageController, 'Kilometraje', keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  _buildTextField(_colorController, 'Color'),
                  SizedBox(height: 20),
                  _buildTextField(_plateController, 'Placa'),
                  SizedBox(height: 20),
                  _buildTextField(_descriptionController, 'Descripción', maxLines: 3),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _publishVehicle,
                    child: Text('Publicar'),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String labelText, List<String> options) {
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        value: _selectedType,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedType = newValue;
          });
        },
        style: TextStyle(color: Colors.white),
        dropdownColor: Colors.orange,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
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
        maxLines: maxLines,
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
