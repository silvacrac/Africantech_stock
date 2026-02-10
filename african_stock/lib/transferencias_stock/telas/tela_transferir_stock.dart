import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';

class TelaTransferirStock extends StatefulWidget {
  const TelaTransferirStock({super.key});

  @override
  State<TelaTransferirStock> createState() => _TelaTransferirStockState();
}

class _TelaTransferirStockState extends State<TelaTransferirStock> {
  String _origem = "STOCK GERAL";
  String? _provinciaDestino;
  String? _materialSelecionado;
  final _qtdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Nova Transferência"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogisticaSection(),
            const SizedBox(height: 24),
            _buildMaterialSection(),
            const SizedBox(height: 32),
            _buildInfoAutorizacao(),
            const SizedBox(height: 40),
            BotaoPadrao(
              texto: "Criar Transferência PENDENTE",
              icone: Icons.send_rounded,
              onPressed: () {
                _confirmarCriacao();
              },
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "O stock só será descontado após a confirmação do destino.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: CoresApp.textoSecundario, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("LOGÍSTICA", icone: Icons.local_shipping),
        CardPadrao(
          child: Column(
            children: [
              _buildDropdownSimples(
                label: "Origem do Stock",
                value: _origem,
                items: ["STOCK GERAL", "PROVÍNCIA MAPUTO", "PROVÍNCIA GAZA"],
                onChanged: (v) => setState(() => _origem = v!),
              ),
              const Divider(height: 32),
              _buildDropdownSimples(
                label: "Província de Destino",
                value: _provinciaDestino,
                hint: "Selecione o destino",
                items: ["MAPUTO", "GAZA", "INHAMBANE", "SOFALA", "TETE"],
                onChanged: (v) => setState(() => _provinciaDestino = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("DETALHES DO MATERIAL", icone: Icons.inventory_2),
        CardPadrao(
          child: Column(
            children: [
              _buildDropdownSimples(
                label: "Item para Transferência",
                value: _materialSelecionado,
                hint: "Pesquisar material...",
                items: ["Varão de Aço 12mm", "Cimento Portland 50kg", "Cabo Cobre 4mm"],
                onChanged: (v) => setState(() => _materialSelecionado = v),
              ),
              const Divider(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Quantidade a Transferir", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _qtdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "0.00",
                      suffixText: "Unidades",
                      filled: true,
                      fillColor: CoresApp.borda.withOpacity(0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAutorizacao() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.primaria.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CoresApp.primaria.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.assignment_ind, color: CoresApp.primaria),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("RESPONSÁVEL AUTORIZADO", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: CoresApp.textoSecundario)),
                Text("Eduardo Da Silva (Tecnico de Informatica)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSimples({required String label, String? value, String? hint, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(hint ?? ""),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String t, {required IconData icone}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icone, size: 16, color: CoresApp.primaria),
          const SizedBox(width: 8),
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: CoresApp.textoSecundario)),
        ],
      ),
    );
  }

  void _confirmarCriacao() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Confirmar Guia"),
        content: const Text("Deseja gerar a guia de transferência? O destino deverá confirmar a recepção para validar o stock."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Revisar")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(c);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transferência PENDENTE criada!")));
            },
            child: const Text("Gerar Guia"),
          )
        ],
      ),
    );
  }
}