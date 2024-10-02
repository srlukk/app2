import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBookPage extends StatefulWidget {
  final String title;
  final String author;
  final String image;
  final String resume;
  final Function(String, String, String, String) onEdit;

  const EditBookPage({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.resume,
    required this.onEdit,
  });

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController resumeController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker
  File? _selectedImage; // Para armazenar a imagem selecionada

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    authorController.text = widget.author;
    imageController.text = widget.image;
    resumeController.text = widget.resume;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Armazena a imagem selecionada
        imageController.text =
            pickedFile.path; // Atualiza o controlador de texto
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
            ElevatedButton(
              onPressed: _pickImage, // Chama o método para selecionar imagem
              child: const Text('Selecionar Imagem'),
            ),
            if (_selectedImage != null) // Exibe a imagem selecionada
              Image.file(
                _selectedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            TextField(
              controller: resumeController,
              decoration: const InputDecoration(labelText: 'Resumo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Chama a função de edição
                widget.onEdit(
                  titleController.text,
                  authorController.text,
                  imageController.text,
                  resumeController.text,
                );
                // Volta para a tela anterior
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
