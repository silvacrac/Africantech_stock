enum TipoMovimento { entrada, saida }

class MovimentoStock {
  final String id;
  final TipoMovimento tipo;
  final String materialId;
  final String materialNome;
  final String? obraId; // Obrigatório na Saída
  final String? obraNome;
  final double quantidade;
  final DateTime data;
  final String responsavelId;
  final String responsavelNome;
  final String provinciaId;
  final String? observacao;
  final String numeroDocumento;

  MovimentoStock({
    required this.id,
    required this.tipo,
    required this.materialId,
    required this.materialNome,
    this.obraId,
    this.obraNome,
    required this.quantidade,
    required this.data,
    required this.responsavelId,
    required this.responsavelNome,
    required this.provinciaId,
    this.observacao,
    required this.numeroDocumento,
  });
}