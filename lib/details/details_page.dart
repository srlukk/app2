import 'package:flutter/material.dart';
import 'dart:io';
import 'package:master_books/edit/edit_book/edit_book_page.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String author;
  final String image;
  final String resume;
  final VoidCallback onDelete;
  final Function(String, String, String, String) onEdit; 

  const DetailsPage({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.resume,
    required this.onDelete,
    required this.onEdit, 
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

    // chama a função de edição passada
    widget.onEdit(newTitle, newAuthor, newImage, newResume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              //navega para a página de edição
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => EditBookPage(
                    title: title,
                    author: author,
                    image: image,
                    resume: resume,
                    onEdit: _editBook, //passa a função de editar
                  ),
                ),
              )
                  .then((_) {
                //atualiza a tela ao voltar, se necessário
                // Por exemplo, pode-se chamar _loadBooks aqui se estiver na HomePage
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Confirmação para excluir o livro
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Excluir Livro"),
                    content: const Text("Deseja excluir o livro?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                      ),
                      TextButton(
                        child: const Text("Sim"),
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  author,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'Resumo:',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    resume,
                    style: const TextStyle(fontSize: 18),
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
