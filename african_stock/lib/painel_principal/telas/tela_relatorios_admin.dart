import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';

class TelaRelatoriosAdmin extends StatefulWidget {
  const TelaRelatoriosAdmin({super.key});

  @override
  State<TelaRelatoriosAdmin> createState() => _TelaRelatoriosAdminState();
}

class _TelaRelatoriosAdminState extends State<TelaRelatoriosAdmin> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 2, // Aba de documentos/relatórios
      tituloCustom: "Relatórios de Auditoria",
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. RESUMO DE CUSTÓDIA (Onde está o material agora?)
            _buildSecaoTitulo("CUSTÓDIA POR PROJETO"),
            _buildCardCustodia("Ponte Maputo-Katembe", "MT 450.000 em material", 0.8),
            _buildCardCustodia("Subestação Matola", "MT 1.200.000 em material", 0.4),
            
            const SizedBox(height: 32),

            // 2. RESUMO DIÁRIO (Quem adicionou o quê nas últimas 24h)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSecaoTitulo("AUDITORIA 24H (RESPONSÁVEIS)"),
                const Icon(Icons.history_toggle_off, size: 16, color: Colors.grey),
              ],
            ),
            _buildListaAuditoriaDiaria(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCustodia(String projeto, String valor, double ocupacao) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(projeto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(valor, style: const TextStyle(color: CoresApp.primaria, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ocupacao,
              backgroundColor: CoresApp.primaria.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(ocupacao > 0.7 ? Colors.orange : CoresApp.primaria),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaAuditoriaDiaria() {
    // Dados que o Admin recebe 1 dia depois
    final logs = [
      {"user": "Eduardo Silva", "acao": "Cadastrou 45 novos itens", "hora": "Ontem, 14:20", "prov": "Beira"},
      {"user": "Marta Alberto", "acao": "Entrada de 200kg de Aço", "hora": "Ontem, 09:15", "prov": "Maputo"},
    ];

    return Column(
      children: logs.map((log) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CardPadrao(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: CoresApp.primaria.withOpacity(0.1), child: const Icon(Icons.person_search, color: CoresApp.primaria, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log['user']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(log['acao']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(log['prov']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CoresApp.primaria)),
                  Text(log['hora']!, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildSecaoTitulo(String t) => Padding(padding: const EdgeInsets.only(bottom: 12, top: 8), child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.2)));
}