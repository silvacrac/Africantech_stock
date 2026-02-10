import 'package:african_stock/obras/telas/tela_detalhes_projeto.dart';
import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../modelos/projeto.dart';

class TelaListaProjetos extends StatefulWidget {
  const TelaListaProjetos({super.key});

  @override
  State<TelaListaProjetos> createState() => _TelaListaProjetosState();
}

class _TelaListaProjetosState extends State<TelaListaProjetos> {
  // Mock de dados para visualização
  final List<Projeto> _projetos = [
    Projeto(
      id: 'PJ001',
      nome: "Manutenção Subestação",
      cliente: "EDM (Eletricidade de Moçambique)",
      localizacao: "Maputo",
      dataInicio: DateTime.now(),
      dataFim: DateTime.now().add(const Duration(days: 30)),
      status: StatusProjeto.emExecucao,
      progresso: 0.65,
    ),
    Projeto(
      id: 'PJ002',
      nome: "Instalação Painéis Solares",
      cliente: "Hospital Central",
      localizacao: "Gaza",
      dataInicio: DateTime.now().add(const Duration(days: 5)),
      dataFim: DateTime.now().add(const Duration(days: 15)),
      status: StatusProjeto.planeado,
      progresso: 0.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 0, // Pode-se criar um index novo ou aceder via Home
      tituloCustom: "Projetos e Trabalhos",
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        itemCount: _projetos.length,
        itemBuilder: (context, index) => _buildCardProjeto(_projetos[index]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CoresApp.primaria,
        onPressed: () {}, // Abrir form de novo trabalho
        child: const Icon(Icons.add_task_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildCardProjeto(Projeto projeto) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        padding: const EdgeInsets.all(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaDetalhesProjeto(projeto: projeto),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(projeto.status),
                Text(
                  projeto.id,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              projeto.nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              projeto.cliente,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: CoresApp.primaria,
                ),
                const SizedBox(width: 4),
                Text(
                  projeto.localizacao,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "Fim: ${projeto.dataFim.day}/${projeto.dataFim.month}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProgressBar(projeto.progresso),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(StatusProjeto status) {
    Color cor;
    String texto;
    switch (status) {
      case StatusProjeto.planeado:
        cor = CoresApp.alerta;
        texto = "PLANEADO";
        break;
      case StatusProjeto.emExecucao:
        cor = CoresApp.info;
        texto = "EM EXECUÇÃO";
        break;
      case StatusProjeto.concluido:
        cor = CoresApp.sucesso;
        texto = "CONCLUÍDO";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgressBar(double progresso) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Progresso do Trabalho",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              "${(progresso * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: CoresApp.primaria,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progresso,
            backgroundColor: CoresApp.primaria.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(CoresApp.primaria),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
