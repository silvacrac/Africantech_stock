import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../modelos/agenda_trabalho.dart';

class TelaAgendaGlobal extends StatefulWidget {
  const TelaAgendaGlobal({super.key});

  @override
  State<TelaAgendaGlobal> createState() => _TelaAgendaGlobalState();
}

class _TelaAgendaGlobalState extends State<TelaAgendaGlobal> {
  DateTime _diaSelecionado = DateTime.now();

  // Mock de agendamentos
  final List<AgendaTrabalho> _agendamentos = [
    AgendaTrabalho(
      id: 'T1',
      projetoNome: "Manutenção Subestação Maputo",
      funcionarioNome: "Ricardo Matsinhe",
      horarioInicio: DateTime.now().copyWith(hour: 08, minute: 00),
      horarioFim: DateTime.now().copyWith(hour: 12, minute: 00),
      status: StatusPresenca.emTrabalho,
      localizacao: "Maputo - Matola",
    ),
    AgendaTrabalho(
      id: 'T2',
      projetoNome: "Instalação Fibra Óptica",
      funcionarioNome: "Artur Chilaule",
      horarioInicio: DateTime.now().copyWith(hour: 14, minute: 30),
      horarioFim: DateTime.now().copyWith(hour: 17, minute: 00),
      status: StatusPresenca.agendado,
      localizacao: "Gaza - Xai-Xai",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 2, // Index do Histórico ou Novo
      tituloCustom: "Agenda e Turnos",
      body: Column(
        children: [
          _buildCalendarioHorizontal(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              itemCount: _agendamentos.length,
              itemBuilder: (context, index) => _buildCardTurno(_agendamentos[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioHorizontal() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 14, // Próximas 2 semanas
        itemBuilder: (context, index) {
          DateTime data = DateTime.now().add(Duration(days: index));
          bool selecionado = data.day == _diaSelecionado.day;

          return GestureDetector(
            onTap: () => setState(() => _diaSelecionado = data),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: selecionado ? CoresApp.primaria : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selecionado ? CoresApp.primaria : CoresApp.bordaClaro.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E', 'pt_BR').format(data).toUpperCase(),
                      style: TextStyle(color: selecionado ? Colors.white70 : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(data.day.toString(),
                      style: TextStyle(color: selecionado ? Colors.white : null, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardTurno(AgendaTrabalho turno) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.access_time_filled_rounded, color: CoresApp.primaria, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(turno.projetoNome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text("${DateFormat('HH:mm').format(turno.horarioInicio)} - ${DateFormat('HH:mm').format(turno.horarioFim)}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                _buildStatusChip(turno.status),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(turno.funcionarioNome, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                _buildBotaoCheck(turno.status),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(StatusPresenca status) {
    Color cor;
    String texto;
    switch (status) {
      case StatusPresenca.emTrabalho: cor = CoresApp.sucesso; texto = "NO LOCAL"; break;
      case StatusPresenca.agendado: cor = CoresApp.info; texto = "AGENDADO"; break;
      case StatusPresenca.concluido: cor = Colors.grey; texto = "CONCLUÍDO"; break;
      case StatusPresenca.ausente: cor = CoresApp.erro; texto = "FALTOU"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: cor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(texto, style: TextStyle(color: cor, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBotaoCheck(StatusPresenca status) {
    if (status == StatusPresenca.agendado) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CoresApp.primaria,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
        child: const Text("CHECK-IN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      );
    } else if (status == StatusPresenca.emTrabalho) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: CoresApp.erro),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
        child: const Text("CHECK-OUT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CoresApp.erro)),
      );
    }
    return const SizedBox.shrink();
  }
}