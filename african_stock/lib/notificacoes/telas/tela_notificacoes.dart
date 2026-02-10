import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../modelos/notificacao.dart';

class TelaNotificacoes extends StatefulWidget {
  const TelaNotificacoes({super.key});

  @override
  State<TelaNotificacoes> createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  final List<Notificacao> _notificacoes = [
    Notificacao(
      id: '1',
      titulo: 'Stock Baixo: Armazém A',
      mensagem: 'O item SKU-402 está abaixo do limite de segurança.',
      data: DateTime.now().subtract(const Duration(minutes: 2)),
      tipo: TipoNotificacao.alertaStock,
    ),
    Notificacao(
      id: '2',
      titulo: 'Transferência Iniciada',
      mensagem: '50 unidades em trânsito de Maputo para Gaza.',
      data: DateTime.now().subtract(const Duration(minutes: 15)),
      tipo: TipoNotificacao.transferencia,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraSuperior(
        titulo: "Notificações",
        acoes: [
          TextButton(
            onPressed: () => setState(() => _notificacoes.forEach((n) => n.lida = true)),
            child: const Text("Ler tudo", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSubtitulo("RECEBIDAS RECENTEMENTE"),
                ..._notificacoes.map((n) => _buildCardNotificacao(n)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: CoresApp.borda.withOpacity(0.5)))),
      child: Row(
        children: [
          _tabItem("Todas", selecionada: true),
          _tabItem("Não lidas"),
          _tabItem("Arquivadas"),
        ],
      ),
    );
  }

  Widget _tabItem(String texto, {bool selecionada = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: selecionada ? CoresApp.primaria : Colors.transparent, width: 2))
        ),
        child: Text(texto, textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 13, fontWeight: selecionada ? FontWeight.bold : FontWeight.normal, color: selecionada ? CoresApp.textoPrincipal : CoresApp.textoSecundario)),
      ),
    );
  }

  Widget _buildSubtitulo(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CoresApp.textoSecundario, letterSpacing: 1.1)),
    );
  }

  Widget _buildCardNotificacao(Notificacao n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconeCirculo(n.tipo),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(n.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(DateFormat('HH:mm').format(n.data), style: const TextStyle(fontSize: 10, color: CoresApp.textoSecundario)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n.mensagem, style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconeCirculo(TipoNotificacao tipo) {
    IconData icone;
    Color cor;
    switch (tipo) {
      case TipoNotificacao.alertaStock: icone = Icons.warning_amber_rounded; cor = CoresApp.erro; break;
      case TipoNotificacao.transferencia: icone = Icons.swap_horiz; cor = CoresApp.info; break;
      default: icone = Icons.notifications; cor = CoresApp.primaria;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icone, color: cor, size: 24),
    );
  }
}