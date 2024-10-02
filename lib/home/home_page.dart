import 'dart:io';
import 'package:flutter/material.dart';
import 'package:master_books/addBook/add_book/add_book_page.dart';
import 'package:master_books/details/details_page.dart';
import 'package:master_books/db/database_helper.dart';
import 'package:master_books/models/livro.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Livro> books = [];
  List<Livro> filteredBooks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
    searchController.addListener(() {
      _filterBooks(searchController.text);
    });
  }

  Future<void> updateBook(int index, Livro updatedBook) async {
    await _dbHelper.atualizarLivro(updatedBook); //atualiza no banco de dados
    _loadBooks(); //recarrega os livros após atualização
  }

  Future<void> _loadBooks() async {
    final livros = await _dbHelper.obterLivros();
    setState(() {
      books = livros;
      filteredBooks = List.from(books);
    });
  }

  void _filterBooks(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        final title = book.titulo.toLowerCase();
        final author = book.autor.toLowerCase();
        return title.contains(lowerCaseQuery) ||
            author.contains(lowerCaseQuery);
      }).toList();
    });
  }

  void addBook(String title, String author, String image, String resume) async {
    final novoLivro = Livro(
      titulo: title,
      autor: author,
      imagem: image,
      resumo: resume,
    );

    await _dbHelper.inserirLivro(novoLivro);
    _loadBooks();
  }

  void deleteBook(int id) async {
    await _dbHelper.deletarLivro(id);
    _loadBooks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Qual Livro Procura?',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(addBook: addBook),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBooks,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.4,
                ),
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  final imagePath = book.imagem;

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            title: book.titulo,
                            author: book.autor,
                            image: book.imagem,
                            resume: book.resumo,
                            onDelete: () => deleteBook(book.id!),
                            onEdit: (newTitle, newAuthor, newImage, newResume) {
                              final updatedBook = Livro(
                                id: book.id,
                                titulo: newTitle,
                                autor: newAuthor,
                                imagem: newImage,
                                resumo: newResume,
                              );
                              updateBook(index, updatedBook);
                            },
                          ),
                        ),
                      ).then((_) {
                        // Após voltar da DetailsPage, recarregue a lista de livros
                        _loadBooks();
                      });
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 0.7,
                            child: imagePath.startsWith('assets/')
                                ? Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              book.titulo,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            child: Text(
                              book.autor,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
