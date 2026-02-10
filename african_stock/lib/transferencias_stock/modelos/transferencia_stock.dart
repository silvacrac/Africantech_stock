enum StatusTransferencia { pendente, concluida, cancelada }

class TransferenciaStock {
  final String id;
  final String materialId;
  final String materialNome;
  final double quantidade;
  final String origemTipo;
  final String? origemProvinciaId;
  final String destinoTipo;
  final String? destinoProvinciaId;
  final StatusTransferencia status;
  final String responsavelOrigem;
  final DateTime dataCriacao;
  final String numeroDocumento;

  TransferenciaStock({
    required this.id,
    required this.materialId,
    required this.materialNome,
    required this.quantidade,
    required this.origemTipo,
    this.origemProvinciaId,
    required this.destinoTipo,
    this.destinoProvinciaId,
    required this.status,
    required this.responsavelOrigem,
    required this.dataCriacao,
    required this.numeroDocumento,
  });
}