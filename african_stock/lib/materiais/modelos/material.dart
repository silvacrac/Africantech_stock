class MaterialModel {
  final String id;
  final String nome;
  final String sku;
  final String categoria;
  final double quantidade;
  final double quantidadeMinima;
  final String unidadeMedida;
  final String? marca;
  final String? tamanho;
  final double precoCompra;

  MaterialModel({
    required this.id,
    required this.nome,
    required this.sku,
    required this.categoria,
    required this.quantidade,
    required this.quantidadeMinima,
    required this.unidadeMedida,
    this.marca,
    this.tamanho,
    this.precoCompra = 0.0, 
  });
  // Verificação se o stock está baixo
  bool get estaBaixo => quantidade <= quantidadeMinima;
}