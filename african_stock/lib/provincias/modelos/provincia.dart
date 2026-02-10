class LocalArmazem {
  final String id;
  final String nome;
  final String endereco;
  final String responsavel;

  LocalArmazem({required this.id, required this.nome, required this.endereco, required this.responsavel});
}

class ProvinciaModel {
  final String id;
  final String nome;
  final String codigo;
  final int totalArmazens;
  final int totalEquipas;
  final double valorTotalStock;
  final List<LocalArmazem> armazens;

  ProvinciaModel({
    required this.id, 
    required this.nome, 
    required this.codigo, 
    this.totalArmazens = 0, 
    this.totalEquipas = 0, 
    this.valorTotalStock = 0.0,
    this.armazens = const [],
  });
}