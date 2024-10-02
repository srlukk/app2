import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //para selecionar a imagem do dispositivo

class AddBookPage extends StatefulWidget {
  final Function(String, String, String, String) addBook;

  const AddBookPage({Key? key, required this.addBook}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _resumeController = TextEditingController();
  String? _imagePath; //variável para armazenar o caminho da imagem

  //função para pegar imagem da galeria
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path; //salvando o caminho da imagem
      });
    }
  }

  void _saveBook() {
    //validação dos campos
    if (_titleController.text.isEmpty) {
      _showSnackBar('O "Título" deve ser preenchido!');
      return;
    }
    if (_authorController.text.isEmpty) {
      _showSnackBar('O "Autor" deve ser preenchido!');
      return;
    }
    if (_imagePath == null) {
      _showSnackBar('A "Imagem" deve ser preenchido!');
      return;
    }
    if (_resumeController.text.isEmpty) {
      _showSnackBar('O "Sinopse" deve ser preenchido!');
      return;
    }

    //todos os caminhos devem ser preenchidos

    //adiciona o livro
    widget.addBook(
      _titleController.text,
      _authorController.text,
      _imagePath!, //passa o caminho da imagem local
      _resumeController.text,
    );

    // Limpar os campos
    _titleController.clear();
    _authorController.clear();
    _resumeController.clear();
    _imagePath = null;

    //mensagem para o usuario
    _showSnackBar('Livro adicionado com sucesso!');

    //volta para a tela anterior
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Adicionar Novo Livro'),
      ),
      body: SingleChildScrollView(
        //scroll da págona
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
            const SizedBox(height: 10),
            _imagePath == null
                ? const Text('Nenhuma imagem selecionada')
                : Container(
                    height: 300, //altura total
                    width: 200, //largura total
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit
                            .cover, //ajusta a imagem para preencher o espaço
                      ),
                    ),
                  ),
            ElevatedButton(
              onPressed: _pickImage, //botão para escolher a imagem
              child: const Text('Selecionar Imagem'),
            ),
            TextField(
              controller: _resumeController,
              decoration: const InputDecoration(labelText: 'Resumo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              child: const Text('Salvar'), //botão para salvar
            ),
          ],
        ),
      ),
    );
  }
}
