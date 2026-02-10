enum StatusProjeto { planeado, emExecucao, concluido }

class Projeto {
  final String id;
  final String nome;
  final String cliente;
  final String localizacao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final StatusProjeto status;
  final List<String> materiaisIds;
  final List<String> equipaIds;
  final double progresso;

  Projeto({
    required this.id,
    required this.nome,
    required this.cliente,
    required this.localizacao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    this.materiaisIds = const [],
    this.equipaIds = const [],
    this.progresso = 0.0,
  });
}