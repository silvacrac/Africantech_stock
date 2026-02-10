import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Certifique-se de que os caminhos abaixo coincidem com a estrutura do seu projeto
import '../../movimentos_stock/modelos/material_selecao.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/campo_texto_padrao.dart';

class TelaRegistarSaida extends StatefulWidget {
  const TelaRegistarSaida({super.key});

  @override
  State<TelaRegistarSaida> createState() => _TelaRegistarSaidaState();
}

class _TelaRegistarSaidaState extends State<TelaRegistarSaida> {
  final _obsController = TextEditingController();
  final List<MaterialSelecao> _materiaisSelecionados = [];
  String? _obraSelecionada;

  void _abrirSeletorMateriais() async {
    final resultado = await showModalBottomSheet<List<MaterialSelecao>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SeletorMultiploMateriais(),
    );

    if (resultado != null) {
      setState(() {
        for (var item in resultado) {
          if (!_materiaisSelecionados.any((element) => element.id == item.id)) {
            _materiaisSelecionados.add(item);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Saída Multi-Material"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCards(),
            const SizedBox(height: 24),
            _buildLabel("Obra de Destino"),
            _buildDropdownObra(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("Materiais para Saída"),
                TextButton.icon(
                  onPressed: _abrirSeletorMateriais,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Adicionar"),
                )
              ],
            ),
            if (_materiaisSelecionados.isEmpty)
              _buildEmptyState()
            else
              _buildListaSelecionados(),
            
            const SizedBox(height: 32),
            _buildLabel("Observações Gerais"),
            CardPadrao(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _obsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Notas adicionais sobre esta movimentação...",
                  hintStyle: TextStyle(color: CoresApp.textoSecundario.withOpacity(0.5), fontSize: 13),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            BotaoPadrao(
              texto: "Confirmar Saída (${_materiaisSelecionados.length} itens)",
              onPressed: _materiaisSelecionados.isEmpty || _obraSelecionada == null ? null : () {
                // Lógica de envio
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(child: _buildTile("RESPONSÁVEL", "Eduado Da Silva", Icons.person)),
        const SizedBox(width: 12),
        Expanded(child: _buildTile("PROVÍNCIA", "Beira", Icons.map)),
      ],
    );
  }

  Widget _buildTile(String label, String value, IconData icon) {
    return CardPadrao(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 12, color: CoresApp.primaria),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: CoresApp.textoSecundario))
          ]),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDropdownObra() {
    return CardPadrao(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _obraSelecionada,
          hint: const Text("Selecione a obra destino"),
          items: ["Ponte Maputo-Katembe", "Torres Rani", "Avenida Marginal"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _obraSelecionada = v),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: CoresApp.borda.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CoresApp.borda.withOpacity(0.5)),
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, color: CoresApp.textoSecundario, size: 48),
          SizedBox(height: 12),
          Text("Nenhum material selecionado", style: TextStyle(color: CoresApp.textoSecundario)),
        ],
      ),
    );
  }

  Widget _buildListaSelecionados() {
    return Column(
      children: _materiaisSelecionados.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: CardPadrao(
          child: Row(
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${item.tamanhoPolegadas}\" • SKU: ${item.sku}", style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario)),
                ]),
              ),
              _buildContador(item),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: CoresApp.erro),
                onPressed: () => setState(() => _materiaisSelecionados.remove(item)),
              )
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildContador(MaterialSelecao item) {
    return Row(
      children: [
        _btnMini(Icons.remove, () => setState(() => item.quantidadeSelecionada > 0 ? item.quantidadeSelecionada-- : null)),
        SizedBox(
          width: 40,
          child: Text("${item.quantidadeSelecionada.toInt()}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        _btnMini(Icons.add, () => setState(() => item.quantidadeSelecionada < item.stockDisponivel ? item.quantidadeSelecionada++ : null)),
      ],
    );
  }

  Widget _btnMini(IconData icon, VoidCallback tap) => GestureDetector(
    onTap: tap,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: CoresApp.primaria),
    ),
  );

  Widget _buildLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)));
}

// --- SELETOR COM FILTROS AVANÇADOS ---
class SeletorMultiploMateriais extends StatefulWidget {
  const SeletorMultiploMateriais({super.key});

  @override
  State<SeletorMultiploMateriais> createState() => _SeletorMultiploMateriaisState();
}

class _SeletorMultiploMateriaisState extends State<SeletorMultiploMateriais> {
  String _busca = "";
  double? _filtroPolegada;
  DateTime? _filtroData;

  final List<MaterialSelecao> _mockData = [
    MaterialSelecao(id: '1', nome: 'Tubo Galvanizado', sku: 'TG-01', dataEntrada: DateTime(2023, 10, 01), tamanhoPolegadas: 2.0, stockDisponivel: 50),
    MaterialSelecao(id: '2', nome: 'Tubo PVC Hidráulico', sku: 'TP-04', dataEntrada: DateTime(2023, 09, 15), tamanhoPolegadas: 4.0, stockDisponivel: 100),
    MaterialSelecao(id: '3', nome: 'Válvula de Pressão', sku: 'VP-02', dataEntrada: DateTime(2023, 10, 10), tamanhoPolegadas: 0.5, stockDisponivel: 20),
  ];

  void _mostrarDialogoSolicitarCadastro() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Solicitar Novo Material", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Informe os dados básicos para validação do administrador."),
            SizedBox(height: 20),
            CampoTextoPadrao(label: "Nome do Material", hint: "Ex: Tubo de Queda 75mm"),
            SizedBox(height: 12),
            CampoTextoPadrao(label: "Polegadas/Medida", hint: "Ex: 3\" ou 75mm"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CoresApp.primaria, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
               Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Solicitação enviada!")));
            },
            child: const Text("Enviar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _mockData.where((m) {
      final bateNome = m.nome.toLowerCase().contains(_busca.toLowerCase());
      final batePol = _filtroPolegada == null || m.tamanhoPolegadas == _filtroPolegada;
      final bateData = _filtroData == null || m.dataEntrada.isAfter(_filtroData!);
      return bateNome && batePol && bateData;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeaderSeletor(),
          _buildBarraBusca(),
          _buildAvisoMaterialNaoEncontrado(filtrados.length),
          _buildFiltrosRapidos(),
          Expanded(
            child: filtrados.isEmpty 
              ? _buildBuscaVazia() 
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtrados.length,
                  itemBuilder: (context, i) {
                    final item = filtrados[i];
                    return CheckboxListTile(
                      title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${item.tamanhoPolegadas}\" • Entrada: ${DateFormat('dd/MM/yy').format(item.dataEntrada)}"),
                      value: item.selecionado,
                      onChanged: (v) => setState(() => item.selecionado = v!),
                      activeColor: CoresApp.primaria,
                    );
                  },
                ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildAvisoMaterialNaoEncontrado(int quantidade) {
    if (quantidade > 0 && _busca.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: CoresApp.primaria, size: 20),
          const SizedBox(width: 8),
          const Expanded(child: Text("Material não listado?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          TextButton(onPressed: _mostrarDialogoSolicitarCadastro, child: const Text("Solicitar Cadastro", style: TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildBuscaVazia() => const Center(child: Text("Nenhum material encontrado."));

  Widget _buildDragHandle() => Center(child: Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: CoresApp.borda, borderRadius: BorderRadius.circular(2))));

  Widget _buildHeaderSeletor() => const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text("Selecionar Materiais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));

  Widget _buildBarraBusca() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
      onChanged: (v) => setState(() => _busca = v),
      decoration: InputDecoration(
        hintText: "Pesquisar por nome ou SKU...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: CoresApp.borda.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    ),
  );

  Widget _buildFiltrosRapidos() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _chipFiltro(
            _filtroData == null ? "Data Entrada" : DateFormat('dd/MM').format(_filtroData!),
            Icons.calendar_month,
            () async {
              final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
              if(d != null) setState(() => _filtroData = d);
            }
          ),
          const SizedBox(width: 10),
          _chipFiltro(
            _filtroPolegada == null ? "Polegadas" : "${_filtroPolegada}\"",
            Icons.straighten,
            () {
              showModalBottomSheet(
                context: context,
                builder: (c) => ListView(
                  shrinkWrap: true,
                  children: [0.5, 1.0, 2.0, 4.0].map((p) => ListTile(
                    title: Text("$p polegadas"),
                    onTap: () { setState(() => _filtroPolegada = p); Navigator.pop(context); },
                  )).toList(),
                )
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _chipFiltro(String t, IconData i, VoidCallback tap) => ActionChip(
    onPressed: tap,
    avatar: Icon(i, size: 16, color: CoresApp.primaria),
    label: Text(t, style: const TextStyle(fontSize: 12)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  Widget _buildFooter() => Container(
    padding: const EdgeInsets.all(20),
    child: BotaoPadrao(
      texto: "Adicionar Selecionados",
      onPressed: () => Navigator.pop(context, _mockData.where((e) => e.selecionado).toList()),
    ),
  );
}