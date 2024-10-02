import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    authorController.text = widget.author;
    imageController.text = widget.image;
    resumeController.text = widget.resume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Imagem ou URL'),
            ),
            TextField(
              controller: resumeController,
              decoration: const InputDecoration(labelText: 'Resumo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onEdit(
                  titleController.text,
                  authorController.text,
                  imageController.text,
                  resumeController.text,
                );
                Navigator.of(context).pop(); // Volta para detalhes
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
