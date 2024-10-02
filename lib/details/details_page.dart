import 'package:flutter/material.dart';
import 'dart:io';
import 'package:master_books/edit/edit_book/edit_book_page.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String author;
  final String image;
  final String resume;
  final VoidCallback onDelete;

  const DetailsPage({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.resume,
    required this.onDelete, 
    required Null Function(dynamic newTitle, dynamic newAuthor, dynamic newImage, dynamic newResume) onEdit,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String title;
  late String author;
  late String image;
  late String resume;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    author = widget.author;
    image = widget.image;
    resume = widget.resume;
  }

  void _editBook(
      String newTitle, String newAuthor, String newImage, String newResume) {
    setState(() {
      title = newTitle;
      author = newAuthor;
      image = newImage;
      resume = newResume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navega para a página de edição
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBookPage(
                    title: title,
                    author: author,
                    image: image,
                    resume: resume,
                    onEdit: _editBook, // Passa a função de edição
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Confirmação para excluir o livro
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Excluir Livro"),
                    content: Text("Deseja excluir o livro?"),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                      ),
                      TextButton(
                        child: Text("Sim"),
                        onPressed: () {
                          widget.onDelete(); // Função deletar
                          Navigator.of(context)
                              .pop(); // Fecha o diálogo de confirmação
                          Navigator.of(context).pop(); // Volta para home
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: image.isNotEmpty && File(image).existsSync()
                    ? Image.file(
                        File(image),
                        fit: BoxFit.cover,
                        height: 300,
                        width: 200,
                      )
                    : image.startsWith('http')
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            height: 300,
                            width: 200,
                          )
                        : Image.asset(
                            'assets/images/default_book_cover.png',
                            fit: BoxFit.cover,
                            height: 300,
                            width: 200,
                          ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  author,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'Resumo:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    resume,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
