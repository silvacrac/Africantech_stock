import 'package:african_stock/autenticacao/Controllers/controlador_autenticacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../movimentos_stock/modelos/material_selecao.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';

class TelaRegistarSaida extends StatefulWidget {
  const TelaRegistarSaida({super.key});

  @override
  State<TelaRegistarSaida> createState() => _TelaRegistarSaidaState();
}

class _TelaRegistarSaidaState extends State<TelaRegistarSaida> {
  final _obsController = TextEditingController();
  final TextEditingController _codigoGuiaController = TextEditingController();
  final List<MaterialSelecao> _materiaisSelecionados = [];
  String? _obraSelecionada;

  @override
  void initState() {
    super.initState();
    _gerarCodigoAutomatico();
  }

  void _gerarCodigoAutomatico() {
    setState(() {
      _codigoGuiaController.text =
          "SAI-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    });
  }

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

  void _escanearEAdicionarMaterial() async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A abrir Scanner QR...")));
    
    // Simulação de retorno do Scanner
    await Future.delayed(const Duration(seconds: 1));
    final materialEscaneado = MaterialSelecao(
        id: 'qr-101',
        nome: "Material via QR",
        sku: "SKU-QR-IDENTIFIED",
        dataEntrada: DateTime.now(),
        tamanhoPolegadas: 1.5,
        stockDisponivel: 20,
        quantidadeSelecionada: 1,
        selecionado: true);

    setState(() {
      if (!_materiaisSelecionados.any((m) => m.sku == materialEscaneado.sku)) {
        _materiaisSelecionados.add(materialEscaneado);
      }
    });
  }

  void _processarSaidaFinal() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator()));

    await Future.delayed(const Duration(seconds: 2)); // Simula API

    if (mounted) {
      Navigator.pop(context); // Fecha loading
      Navigator.pop(context); // Volta para Home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Guia ${_codigoGuiaController.text} registada!"),
          backgroundColor: CoresApp.sucesso,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final funcionario = ControladorAutenticacao.instancia.funcionarioLogado;

    return BaseScaffold(
      indexAtivo: 0,
      tituloCustom: "Nova Saída de Material",
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CÓDIGO DA GUIA (UNIFICADOR)
            _buildHeaderCodigoGuia(isDark),
            const SizedBox(height: 24),

            // 2. INFO CARDS (RESPONSÁVEL E PROVÍNCIA)
            _buildInfoCards(funcionario?.nome ?? "Funcionário", funcionario?.provincia ?? "Província"),
            const SizedBox(height: 24),

            // 3. SELEÇÃO DA OBRA
            _buildLabel("Obra de Destino"),
            _buildDropdownObra(),
            const SizedBox(height: 32),

            // 4. LISTA DE MATERIAIS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("Materiais Selecionados"),
                TextButton.icon(
                  onPressed: _abrirSeletorMateriais,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text("Adicionar", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
            _materiaisSelecionados.isEmpty ? _buildEmptyState() : _buildListaSelecionados(),
            
            const SizedBox(height: 32),

            // 5. OBSERVAÇÕES
            _buildLabel("Observações da Guia"),
            CardPadrao(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _obsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Notas adicionais para este documento...",
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 6. BOTÃO DE CONFIRMAÇÃO
            _buildBotaoConfirmar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCodigoGuia(bool isDark) {
    return CardPadrao(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CÓDIGO ÚNICO DO DOCUMENTO",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codigoGuiaController,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: CoresApp.primaria),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Nº da Guia"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded, color: CoresApp.primaria),
                onPressed: _escanearEAdicionarMaterial,
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.grey),
                onPressed: _gerarCodigoAutomatico,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(String nome, String provincia) {
    return Row(
      children: [
        Expanded(child: _buildTile("RESPONSÁVEL", nome, Icons.person_outline)),
        const SizedBox(width: 12),
        Expanded(child: _buildTile("PROVÍNCIA", provincia, Icons.map_outlined)),
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
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey))
          ]),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
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
          hint: const Text("Selecione a obra de destino"),
          items: ["Ponte Maputo-Katembe", "Torres Rani", "Avenida Marginal", "Subestação Matola"]
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
        color: CoresApp.primaria.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CoresApp.primaria.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, color: CoresApp.primaria.withOpacity(0.3), size: 48),
          const SizedBox(height: 12),
          const Text("Nenhum material adicionado", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildListaSelecionados() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _materiaisSelecionados.length,
      itemBuilder: (context, index) {
        final item = _materiaisSelecionados[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CardPadrao(
            child: Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("${item.tamanhoPolegadas}\" • SKU: ${item.sku}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ]),
                ),
                _buildContador(item),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: CoresApp.erro, size: 20),
                  onPressed: () => setState(() => _materiaisSelecionados.removeAt(index)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContador(MaterialSelecao item) {
    return Row(
      children: [
        _btnMini(Icons.remove, () => setState(() => item.quantidadeSelecionada > 1 ? item.quantidadeSelecionada-- : null)),
        Container(
          width: 35,
          child: Text("${item.quantidadeSelecionada.toInt()}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        _btnMini(Icons.add, () => setState(() => item.quantidadeSelecionada < item.stockDisponivel ? item.quantidadeSelecionada++ : null)),
      ],
    );
  }

  Widget _btnMini(IconData icon, VoidCallback tap) => GestureDetector(
    onTap: tap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: CoresApp.primaria),
    ),
  );

  Widget _buildBotaoConfirmar() {
    bool pode = _materiaisSelecionados.isNotEmpty && _obraSelecionada != null;
    return BotaoPadrao(
      texto: pode ? "CONFIRMAR SAÍDA (${_materiaisSelecionados.length} ITENS)" : "PREENCHA TODOS OS CAMPOS",
      icone: Icons.check_circle_rounded,
      onPressed: pode ? _processarSaidaFinal : null,
    );
  }

  Widget _buildLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))));
}

// --- SELETOR DE MATERIAIS COM FILTROS AVANÇADOS ---
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
    MaterialSelecao(id: '1', nome: 'Tubo Galvanizado', sku: 'TG-200', dataEntrada: DateTime(2023, 10, 01), tamanhoPolegadas: 2.0, stockDisponivel: 50),
    MaterialSelecao(id: '2', nome: 'Tubo PVC Hidráulico', sku: 'TP-400', dataEntrada: DateTime(2023, 09, 15), tamanhoPolegadas: 4.0, stockDisponivel: 100),
    MaterialSelecao(id: '3', nome: 'Válvula de Pressão', sku: 'VP-050', dataEntrada: DateTime(2023, 10, 10), tamanhoPolegadas: 0.5, stockDisponivel: 20),
    MaterialSelecao(id: '4', nome: 'Cabo Cobre 4mm', sku: 'CB-004', dataEntrada: DateTime(2023, 11, 05), tamanhoPolegadas: 1.0, stockDisponivel: 500),
  ];

  @override
  Widget build(BuildContext context) {
    final filtrados = _mockData.where((m) {
      final bateNome = m.nome.toLowerCase().contains(_busca.toLowerCase()) || m.sku.toLowerCase().contains(_busca.toLowerCase());
      final batePol = _filtroPolegada == null || m.tamanhoPolegadas == _filtroPolegada;
      final bateData = _filtroData == null || m.dataEntrada.isAfter(_filtroData!);
      return bateNome && batePol && bateData;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(
        children: [
          _buildDragHandle(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Selecionar Materiais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          _buildBarraBusca(),
          _buildAvisoMaterialNaoEncontrado(filtrados.length),
          _buildFiltrosRapidos(),
          Expanded(
            child: filtrados.isEmpty ? const Center(child: Text("Nenhum material encontrado.")) : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtrados.length,
              itemBuilder: (context, i) {
                final item = filtrados[i];
                return CheckboxListTile(
                  title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.tamanhoPolegadas}\" • SKU: ${item.sku} • Stock: ${item.stockDisponivel.toInt()}"),
                  value: item.selecionado,
                  activeColor: CoresApp.primaria,
                  onChanged: (v) => setState(() => item.selecionado = v!),
                );
              },
            ),
          ),
          _buildFooter(filtrados),
        ],
      ),
    );
  }

  Widget _buildDragHandle() => Center(child: Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))));

  Widget _buildBarraBusca() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
      onChanged: (v) => setState(() => _busca = v),
      decoration: InputDecoration(
        hintText: "Nome ou SKU...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: CoresApp.primaria.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    ),
  );

  Widget _buildAvisoMaterialNaoEncontrado(int qtd) {
    if (qtd > 0 && _busca.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          const Expanded(child: Text("Não encontrou?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          TextButton(onPressed: () {}, child: const Text("Solicitar Cadastro", style: TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildFiltrosRapidos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _chipFiltro(_filtroData == null ? "Data" : DateFormat('dd/MM').format(_filtroData!), Icons.calendar_month, () async {
            final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
            if (d != null) setState(() => _filtroData = d);
          }),
          const SizedBox(width: 10),
          _chipFiltro(_filtroPolegada == null ? "Polegadas" : "${_filtroPolegada}\"", Icons.straighten, () {
            showModalBottomSheet(context: context, builder: (c) => ListView(shrinkWrap: true, children: [0.5, 1.0, 2.0, 4.0].map((p) => ListTile(title: Text("$p polegadas"), onTap: () { setState(() => _filtroPolegada = p); Navigator.pop(context); })).toList()));
          }),
          if (_filtroData != null || _filtroPolegada != null)
            IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 20), onPressed: () => setState(() { _filtroData = null; _filtroPolegada = null; }))
        ],
      ),
    );
  }

  Widget _chipFiltro(String t, IconData i, VoidCallback tap) => ActionChip(
    onPressed: tap,
    avatar: Icon(i, size: 14, color: CoresApp.primaria),
    label: Text(t, style: const TextStyle(fontSize: 11)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  Widget _buildFooter(List<MaterialSelecao> lista) => Container(
    padding: const EdgeInsets.all(24),
    child: BotaoPadrao(
      texto: "ADICIONAR SELECIONADOS",
      onPressed: () => Navigator.pop(context, _mockData.where((e) => e.selecionado).toList()),
    ),
  );
}