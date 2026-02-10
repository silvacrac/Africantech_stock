enum StatusPresenca { agendado, emTrabalho, concluido, ausente }

class AgendaTrabalho {
  final String id;
  final String projetoNome;
  final String funcionarioNome;
  final DateTime horarioInicio;
  final DateTime horarioFim;
  final StatusPresenca status;
  final String localizacao; 

  AgendaTrabalho({
    required this.id,
    required this.projetoNome,
    required this.funcionarioNome,
    required this.horarioInicio,
    required this.horarioFim,
    required this.status,
    required this.localizacao,
  });
}