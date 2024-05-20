import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPublicationScreen extends StatefulWidget {
  final Map<String, String> publication;

  EditPublicationScreen({required this.publication});

  @override
  _EditPublicationScreenState createState() => _EditPublicationScreenState();
}

class _EditPublicationScreenState extends State<EditPublicationScreen> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageURLController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();

  String? _imageUrl;
  String _selectedType = 'Nuevo';

  @override
  void initState() {
    super.initState();
    _brandController.text = widget.publication['title'] ?? '';
    _descriptionController.text = widget.publication['description'] ?? '';
    _imageUrl = widget.publication['image'];
    _selectedType = widget.publication['type'] ?? 'Nuevo';
    _mileageController.text = widget.publication['mileage'] ?? '';
    _colorController.text = widget.publication['color'] ?? '';
    _plateController.text = widget.publication['plate'] ?? '';
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    _imageURLController.dispose();
    _colorController.dispose();
    _plateController.dispose();
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

  Future<void> _saveChanges() async {
    final publicationId = widget.publication['id'];
    if (publicationId != null) {
      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8080/api/vehicles/actualizar/$publicationId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'type': _selectedType,
            'brand': _brandController.text,
            'mileage': int.tryParse(_mileageController.text) ?? 0,
            'color': _colorController.text,
            'plate': _plateController.text,
            'description': _descriptionController.text,
            'imagen': _imageUrl,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Publicación actualizada correctamente')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar la publicación')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Publicación', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              _buildDropdown(),
              SizedBox(height: 20),
              _buildTextField(_brandController, 'Marca', Icons.local_offer),
              SizedBox(height: 20),
              _buildTextField(_mileageController, 'Kilometraje', Icons.speed),
              SizedBox(height: 20),
              _buildTextField(_colorController, 'Color', Icons.color_lens),
              SizedBox(height: 20),
              _buildTextField(_plateController, 'Placa', Icons.confirmation_number),
              SizedBox(height: 20),
              _buildTextField(_descriptionController, 'Descripción', Icons.description, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Guardar'),
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
    );
  }

  Widget _buildDropdown() {
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedType = newValue!;
            });
          },
          items: <String>['Nuevo', 'Usado'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          dropdownColor: Colors.orange,
          iconEnabledColor: Colors.white,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
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
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(color: Colors.white),
        maxLines: maxLines,
      ),
    );
  }
}
