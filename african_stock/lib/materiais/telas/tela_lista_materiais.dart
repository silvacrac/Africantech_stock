import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:file_picker/file_picker.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../modelos/material.dart';
import '../componentes/modal_qr_material.dart';

class TelaListaMateriais extends StatefulWidget {
  const TelaListaMateriais({super.key});

  @override
  State<TelaListaMateriais> createState() => _TelaListaMateriaisState();
}

class _TelaListaMateriaisState extends State<TelaListaMateriais> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Estado da Lista e Paginação
  List<MaterialModel> _listaCompleta = [];
  List<MaterialModel> _listaFiltrada = [];
  List<MaterialModel> _listaExibida = [];
  bool _carregandoMais = false;
  int _paginaAtual = 0;
  final int _itensPorPagina = 15;

  // Filtros ativos
  String _filtroCategoria = "Todos";
  String _buscaTexto = "";

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();

    // Listener para Paginação (Infinite Scroll)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _carregarMaisDados();
      }
    });
  }


void _aplicarFiltros() {
  setState(() {
    _listaFiltrada = _listaCompleta.where((item) {
      final bateNome = item.nome.toLowerCase().contains(_buscaTexto.toLowerCase());
      final bateSKU = item.sku.toLowerCase().contains(_buscaTexto.toLowerCase());
      final bateCategoria = _filtroCategoria == "Todos" || item.categoria == _filtroCategoria;
      
      return (bateNome || bateSKU) && bateCategoria;
    }).toList();
  });
}

  Future<void> _carregarDadosIniciais() async {
  setState(() => _carregandoMais = true);
  // Simulação de delay da base de dados
  await Future.delayed(const Duration(milliseconds: 800));
  _listaCompleta = _gerarMockDados(0, _itensPorPagina);
  _aplicarFiltros();
}

 Future<void> _carregarMaisDados() async {
  if (_carregandoMais) return;
  setState(() => _carregandoMais = true);
  
  await Future.delayed(const Duration(seconds: 1)); // Simula latência de rede
  
  _paginaAtual++;
  final novosItens = _gerarMockDados(_paginaAtual * _itensPorPagina, _itensPorPagina);
  
  setState(() {
    _listaCompleta.addAll(novosItens);
    _aplicarFiltros();
    _carregandoMais = false;
  });
}

  // Simula um grande volume de dados (Milhares de itens)
  List<MaterialModel> _gerarMockDados(int inicio, int quantidade) {
    return List.generate(quantidade, (i) {
      int index = inicio + i;
      return MaterialModel(
        id: '$index',
        nome: 'Material Corporativo #$index',
        sku: 'SKU-${2000 + index}',
        categoria: index % 3 == 0 ? 'CONSTRUÇÃO' : (index % 3 == 1 ? 'ELÉCTRICO' : 'HIDRÁULICA'),
        quantidade: (index * 12.0) % 800,
        quantidadeMinima: 200,
        unidadeMedida: 'Unidades',
      );
    });
  }

  // Lógica de Importação de Excel
  Future<void> _importarExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A processar ficheiro Excel..."), backgroundColor: Colors.green),
      );
      // Aqui entraria a lógica de parsing da lib excel
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      indexAtivo: 1, // Ativa ícone STOCK na barra inferior
      acoesAppBar: [
        IconButton(
          icon: const Icon(Icons.file_upload_outlined, color: Colors.green, size: 26),
          onPressed: _importarExcel,
          tooltip: "Importar Excel",
        ),
        const SizedBox(width: 8),
      ],
      body: Column(
        children: [
          // 1. BARRA DE PESQUISA PREMIUM
          _buildBarraPesquisa(isDark),

          // 2. FILTROS RÁPIDOS
          _buildFiltrosCategorias(),

          // 3. LISTAGEM COM PAGINAÇÃO
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              physics: const BouncingScrollPhysics(),
              itemCount: _listaExibida.length + (_carregandoMais ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _listaExibida.length) {
                  return _buildCardMaterial(_listaExibida[index], isDark);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraPesquisa(bool isDark) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: CardPadrao(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: _searchController,
        onChanged: (v) {
          _buscaTexto = v;
          _aplicarFiltros();
        },
        decoration: InputDecoration(
          hintText: "Pesquisar por Nome ou SKU...",
          prefixIcon: const Icon(Icons.search_rounded, color: CoresApp.primaria),
          suffixIcon: _buscaTexto.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.close), onPressed: () {
                _searchController.clear();
                _buscaTexto = "";
                _aplicarFiltros();
              }) 
            : const Icon(Icons.tune_rounded, size: 20, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    ),
  );
}

Widget _buildFiltrosCategorias() {
  final categorias = ["Todos", "CONSTRUÇÃO", "ELÉCTRICO", "HIDRÁULICA", "FERRAMENTAS"];
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: categorias.map((cat) {
        bool selecionado = _filtroCategoria == cat;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(cat),
            selected: selecionado,
            onSelected: (v) {
              setState(() => _filtroCategoria = cat);
              _aplicarFiltros();
            },
            selectedColor: CoresApp.primaria,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: selecionado ? Colors.white : const Color(0xFF64748B),
              fontSize: 11, fontWeight: FontWeight.bold
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: selecionado ? CoresApp.primaria : const Color(0xFFE2E8F0)),
          ),
        );
      }).toList(),
    ),
  );
}

  Widget _chipFiltro(String label, bool selecionado) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: selecionado,
        onSelected: (v) {},
        selectedColor: CoresApp.primaria,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: selecionado ? Colors.white : const Color(0xFF64748B),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: selecionado ? CoresApp.primaria : const Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildCardMaterial(MaterialModel material, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(material.categoria, style: const TextStyle(color: CoresApp.primaria, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(material.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("SKU: ${material.sku}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  ),
                  // BOTÃO QR CODE PARA IMPRESSÃO DE ETIQUETA
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.qr_code_2_rounded, color: CoresApp.primaria, size: 24),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                        builder: (context) => ModalQrMaterial(material: material),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile("UNIDADE", material.unidadeMedida),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("DISPONÍVEL", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      Text(
                        "${material.quantidade.toInt()}",
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.w900, 
                          color: material.estaBaixo ? CoresApp.erro : CoresApp.primaria
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildStatusFooter(material.estaBaixo),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildStatusFooter(bool estaBaixo) {
    final cor = estaBaixo ? CoresApp.erro : const Color(0xFF10B981);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(estaBaixo ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded, size: 14, color: cor),
          const SizedBox(width: 6),
          Text(
            estaBaixo ? "ALERTA: STOCK ABAIXO DO MÍNIMO" : "ESTADO DE STOCK OPTIMAL",
            style: TextStyle(color: cor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}