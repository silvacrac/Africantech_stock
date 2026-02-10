class MaterialModel {
  final String id;
  final String nome;
  final String sku;
  final String categoria;
  final double quantidade;
  final double quantidadeMinima;
  final String unidadeMedida;

  MaterialModel({
    required this.id,
    required this.nome,
    required this.sku,
    required this.categoria,
    required this.quantidade,
    required this.quantidadeMinima,
    required this.unidadeMedida,
  });

  bool get estaBaixo => quantidade <= quantidadeMinima;
}