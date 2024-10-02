class Livro {
  int? id;
  String titulo;
  String autor;
  String imagem;
  String resumo;

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.imagem,
    required this.resumo,
  });

  // Converter para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'imagem': imagem,
      'resumo': resumo,
    };
  }

  // Criar um Livro a partir de um Map (para recuperar do banco de dados)
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      imagem: map['imagem'],
      resumo: map['resumo'],
    );
  }
}
