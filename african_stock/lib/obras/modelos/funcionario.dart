
enum TipoAcesso { admin, operacional }
class Funcionario {
  final String id;
  final String nome;
  final String email;
  final String funcao;
  final String provincia;
  final TipoAcesso tipo;
  final bool estaDisponivel;
  final String telefone;
  final List<String> habilidades;
  final String? fotoUrl;
  final bool disponivel;

  Funcionario({
    required this.id,
    required this.nome,
    required this.email,
    required this.funcao,
    required this.tipo,
    required this.telefone,
    this.estaDisponivel = true,
    this.habilidades = const [],
    required this.provincia,
    this.fotoUrl,
    this.disponivel = true,
  });

  bool get isAdmin => tipo == TipoAcesso.admin;
}
