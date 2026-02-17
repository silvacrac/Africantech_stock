import 'package:flutter/material.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/constantes/constantes_cores.dart';

class TelaRegistarEntrada extends StatefulWidget {
  const TelaRegistarEntrada({super.key});

  @override
  State<TelaRegistarEntrada> createState() => _TelaRegistarEntradaState();
}

class _TelaRegistarEntradaState extends State<TelaRegistarEntrada> {
  final TextEditingController _guiaController = TextEditingController();
  final List<Map<String, dynamic>> _itensParaEntrada = [];

  @override
  void initState() {
    super.initState();
    _guiaController.text = "ENT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
  }

  void _adicionarLinhaMaterial() {
    setState(() {
      _itensParaEntrada.add({
        "nome": "",
        "marca": "",
        "tamanho": "",
        "quantidade": 0,
        "categoria": "CONSTRUÇÃO"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 1,
      tituloCustom: "Entrada de Mercadoria",
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        child: Column(
          children: [
            _buildHeaderGuia(),
            const SizedBox(height: 24),
            if (_itensParaEntrada.isEmpty) 
              _buildDicaInicial()
            else 
              ..._itensParaEntrada.asMap().entries.map((entry) => _buildCardEntradaItem(entry.key, entry.value)),
            
            const SizedBox(height: 20),
            _buildBotaoAdicionarItem(),
            const SizedBox(height: 40),
            
            BotaoPadrao(
              texto: "PROCESSAR ENTRADA TOTAL",
              onPressed: _itensParaEntrada.isEmpty ? null : () {
                // Envia lista completa para o Backend Node.js
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderGuia() {
    return CardPadrao(
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: CoresApp.primaria),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _guiaController,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              decoration: const InputDecoration(labelText: "Nº DO DOCUMENTO / GUIA", border: InputBorder.none),
            ),
          ),
          const Icon(Icons.verified, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildCardEntradaItem(int index, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ITEM #${index + 1}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                IconButton(onPressed: () => setState(() => _itensParaEntrada.removeAt(index)), icon: const Icon(Icons.close, size: 18, color: Colors.red)),
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Nome do Material"),
              onChanged: (v) => item['nome'] = v,
            ),
            Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(labelText: "Marca"), onChanged: (v) => item['marca'] = v)),
                const SizedBox(width: 12),
                Expanded(child: TextField(decoration: const InputDecoration(labelText: "Tamanho (Pol)"), onChanged: (v) => item['tamanho'] = v)),
              ],
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantidade de Entrada"),
              onChanged: (v) => item['quantidade'] = double.tryParse(v) ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoAdicionarItem() {
    return InkWell(
      onTap: _adicionarLinhaMaterial,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: CoresApp.primaria, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15)
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: CoresApp.primaria),
            SizedBox(width: 8),
            Text("ADICIONAR OUTRO MATERIAL À GUIA", style: TextStyle(color: CoresApp.primaria, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDicaInicial() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.add_to_photos_rounded, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text("Clique abaixo para começar a adicionar materiais a esta guia.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}