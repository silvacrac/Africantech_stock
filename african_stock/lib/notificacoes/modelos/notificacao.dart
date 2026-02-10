enum TipoNotificacao { alertaStock, transferencia, movimento, sistema }

class Notificacao {
  final String id;
  final String titulo;
  final String mensagem;
  final DateTime data;
  final TipoNotificacao tipo;
  bool lida;

  Notificacao({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.data,
    required this.tipo,
    this.lida = false,
  });
}