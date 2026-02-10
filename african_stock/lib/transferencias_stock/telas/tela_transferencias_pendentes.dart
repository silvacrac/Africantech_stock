import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../controladores/controlador_transferencias.dart';
import 'tela_detalhes_transferencia.dart';

class TelaTransferenciasPendentes extends StatefulWidget {
  const TelaTransferenciasPendentes({super.key});

  @override
  State<TelaTransferenciasPendentes> createState() => _TelaTransferenciasPendentesState();
}

class _TelaTransferenciasPendentesState extends State<TelaTransferenciasPendentes> {
  final _controlador = ControladorTransferencias();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Transferências Pendentes"),
      body: _controlador.pendentes.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _controlador.pendentes.length,
            itemBuilder: (context, index) {
              final trans = _controlador.pendentes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CardPadrao(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TelaDetalhesTransferencia(transferencia: trans))
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: CoresApp.alerta.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Text("PENDENTE", style: TextStyle(color: CoresApp.alerta, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          Text(trans.numeroDocumento, style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: CoresApp.primaria, size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trans.materialNome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("${trans.quantidade} Unidades", style: const TextStyle(color: CoresApp.primaria, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: CoresApp.textoSecundario),
                          const SizedBox(width: 4),
                          Text("${trans.origemTipo} → ${trans.destinoProvinciaId}", style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario)),
                          const Spacer(),
                          const Icon(Icons.calendar_today_outlined, size: 14, color: CoresApp.textoSecundario),
                          const SizedBox(width: 4),
                          Text(DateFormat('dd/MM/yy').format(trans.dataCriacao), style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: CoresApp.sucesso.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text("Tudo em dia!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Nenhuma transferência aguardando confirmação.", style: TextStyle(color: CoresApp.textoSecundario)),
        ],
      ),
    );
  }
}