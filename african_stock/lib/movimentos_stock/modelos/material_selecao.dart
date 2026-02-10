class MaterialSelecao {
  final String id;
  final String nome;
  final String sku;
  final DateTime dataEntrada;
  final double tamanhoPolegadas;
  final double stockDisponivel;
  double quantidadeSelecionada;
  bool selecionado;

  MaterialSelecao({
    required this.id,
    required this.nome,
    required this.sku,
    required this.dataEntrada,
    required this.tamanhoPolegadas,
    required this.stockDisponivel,
    this.quantidadeSelecionada = 0,
    this.selecionado = false,
  });
}