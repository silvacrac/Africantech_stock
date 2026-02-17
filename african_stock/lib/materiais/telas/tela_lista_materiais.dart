import 'package:african_stock/autenticacao/controllers/controlador_autenticacao.dart';
import 'package:african_stock/nucleo/configuracoes/config_ambiente.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
// Componentes do Sistema
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/servicos/api_service.dart';
import '../../nucleo/seguranca/gestor_token.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Modelos
import '../modelos/material.dart';
import '../componentes/modal_qr_material.dart';
import '../../obras/modelos/funcionario.dart';

class TelaListaMateriais extends StatefulWidget {
  const TelaListaMateriais({super.key});

  @override
  State<TelaListaMateriais> createState() => _TelaListaMateriaisState();
}

class _TelaListaMateriaisState extends State<TelaListaMateriais> {
 bool get _souAdmin => ControladorAutenticacao.instancia.funcionarioLogado?.isAdmin ?? false;
  // --- CONTROLADORES ---
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  // --- ESTADO DE DADOS ---
  List<MaterialModel> _materiais = [];
  List<String> _categorias = ["Todos"];
  DateTimeRange? _intervaloDatas;
    List<dynamic> _categoriasFull = []; 
  
  // Controle de Seleção para Entrada Rápida
  final List<MaterialModel> _selecionadosParaEntrada = [];
  final Map<String, double> _selecionadosQtd = {}; 

  // --- ESTADO DE PAGINAÇÃO E FILTROS ---
  bool _carregando = false;
  int _paginaAtual = 1;
  int _totalPaginas = 1;
  String _filtroCategoria = "Todos";

  @override
  void initState() {
    super.initState();
    _inicializarPagina();
  }

  // --- LÓGICA DE COMUNICAÇÃO COM BACKEND ---

  void _inicializarPagina() async {
    await _carregarCategorias();
    _buscarDadosDoBanco();
  }

Future<void> _carregarCategorias() async {
    try {
      final lista = await ApiService().obterCategorias();
      if (mounted) {
        setState(() {
          _categoriasFull = lista; 
          _categorias = ["Todos", ...lista.map((c) => c['nome'].toString())];
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar categorias: $e");
    }
  }

  Future<void> _buscarDadosDoBanco() async {
    if (!mounted) return;
    setState(() => _carregando = true);
    try {
      final response = await ApiService().obterStockPaginado(
        pagina: _paginaAtual,
        busca: _searchController.text,
        categoria: _filtroCategoria,
      );

      final List<dynamic> dados = response['dados'] ?? [];
      setState(() {
        _materiais = dados.map((json) => MaterialModel(
          id: json['id'].toString(),
          nome: json['nome'] ?? "",
          sku: json['sku'] ?? "",
          categoria: json['categoria']?.toString().toUpperCase() ?? "GERAL",
          quantidade: double.tryParse(json['quantidade_real']?.toString() ?? "0") ?? 0.0,
          quantidadeMinima: double.tryParse(json['quantidade_minima']?.toString() ?? "0") ?? 10.0,
          unidadeMedida: json['unidade_medida'] ?? "Un",
        )).toList();
        _totalPaginas = response['paginacao']?['total_paginas'] ?? 1;
      });
    } catch (e) {
      debugPrint("Erro na listagem MySQL: $e");
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // --- MÉTODOS DE FILTRO ---

  Future<void> _selecionarIntervaloDatas() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: CoresApp.primaria),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _intervaloDatas = picked);
      _buscarDadosDoBanco();
    }
  }

  // --- MODAL 1: ADICIONAR CATEGORIA (REQUISITO ADMIN) ---

  void _abrirModalNovaCategoria() {
    final TextEditingController _catController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Nova Categoria ou Marca", style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: _catController,
          decoration: const InputDecoration(labelText: "Nome da Categoria", hintText: "Ex: Hidráulica, Bosch..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CoresApp.primaria),
            onPressed: () async {
              if (_catController.text.isNotEmpty) {
                bool ok = await ApiService().criarCategoria(_catController.text);
                if (ok && mounted) {
                  Navigator.pop(context);
                  _carregarCategorias();
                }
              }
            },
            child: const Text("GRAVAR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

 // MODAL 2: CADASTRO COMPLETO (Corrigido para salvar no banco)
void _abrirModalNovoCadastro() {
  // 1. Controladores de Texto
  final nomeC = TextEditingController();
  final marcaC = TextEditingController();
  final skuC = TextEditingController();
  final polC = TextEditingController();
  final precoC = TextEditingController();
  final unidadeC = TextEditingController(text: "Unidades"); // Valor padrão
  
  String? categoriaSelecionada;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que o modal suba com o teclado
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste para o teclado
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Linha superior (Indicador)
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              const Text(
                "CADASTRAR NOVO MATERIAL", 
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: CoresApp.primaria)
              ),
              const SizedBox(height: 24),
              
              // SELEÇÃO DE CATEGORIA
              _buildDropdownCategoria(categoriaSelecionada, (val) {
                setModalState(() => categoriaSelecionada = val);
              }),
              const SizedBox(height: 12),
              
              // NOME DO MATERIAL
              _buildField("Nome do Material", Icons.inventory_2_outlined, nomeC),
              const SizedBox(height: 12),
              
              // MARCA E TAMANHO (Lado a lado)
              Row(
                children: [
                  Expanded(child: _buildField("Marca", Icons.branding_watermark, marcaC)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField("Tamanho", Icons.straighten, polC)),
                ],
              ),
              const SizedBox(height: 12),
              
              // PREÇO DE COMPRA E UNIDADE (Lado a lado)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: precoC,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Preço Compra (MT)",
                        prefixIcon: const Icon(Icons.monetization_on_outlined, size: 20, color: Colors.green),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField("Unidade (Un, Kg...)", Icons.scale, unidadeC)),
                ],
              ),
              const SizedBox(height: 12),
              
              // SKU / CÓDIGO QR
              _buildField("SKU / Código QR Único", Icons.qr_code_scanner, skuC),
              
              const SizedBox(height: 32),
              
              // BOTÃO GRAVAR
              BotaoPadrao(
                texto: "GRAVAR NO BANCO DE DADOS",
                onPressed: () async {
                  // Validação Simples
                  if (nomeC.text.isEmpty || skuC.text.isEmpty || categoriaSelecionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preencha Nome, SKU e Categoria!"), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  // Busca o ID da categoria selecionada na lista que carregamos do banco
                  final categoriaObj = _categoriasFull.firstWhere(
                    (c) => c['nome'].toString() == categoriaSelecionada,
                    orElse: () => null,
                  );

                  if (categoriaObj != null) {
                    setState(() => _carregando = true);
                    
                    bool ok = await ApiService().criarMaterial({
                      "nome": nomeC.text.toUpperCase(),
                      "sku": skuC.text.toUpperCase(),
                      "marca": marcaC.text.toUpperCase(),
                      "tamanho": polC.text,
                      "unidade_medida": unidadeC.text,
                      "preco_compra": double.tryParse(precoC.text.replaceAll(',', '.')) ?? 0.0,
                      "categoria_id": categoriaObj['id'], // Envia o ID numérico para o MySQL
                    });

                    if (ok && mounted) {
                      Navigator.pop(context);
                      _buscarDadosDoBanco(); // Atualiza a lista principal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Material cadastrado com sucesso!"), backgroundColor: Colors.green),
                      );
                    }
                    setState(() => _carregando = false);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
}
  
  // --- MODAL 3: ENTRADA RÁPIDA (REPOSIÇÃO SIMPLIFICADA) ---

void _abrirModalEntradaSimples() {
    _selecionadosParaEntrada.clear();
    _selecionadosQtd.clear();

    String filtroTextoModal = "";
    final precoC = TextEditingController();
    String categoriaSelecionadaModal = "Todos";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Filtragem
          List<MaterialModel> materiaisFiltrados = _materiais.where((m) {
            bool batePesquisa = m.nome.toLowerCase().contains(filtroTextoModal.toLowerCase()) || 
                               m.sku.toLowerCase().contains(filtroTextoModal.toLowerCase());
            bool bateCategoria = categoriaSelecionadaModal == "Todos" || m.categoria == categoriaSelecionadaModal;
            return batePesquisa && bateCategoria;
          }).toList();

          Map<String, List<MaterialModel>> agrupados = {};
          for (var m in materiaisFiltrados) {
            agrupados.putIfAbsent(m.categoria, () => []).add(m);
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                const Text("ENTRADA RÁPIDA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: CoresApp.primaria)),
                const SizedBox(height: 15),

                TextField(
                  onChanged: (val) => setModalState(() => filtroTextoModal = val),
                  decoration: InputDecoration(
                    hintText: "Filtrar por nome ou SKU...",
                    prefixIcon: const Icon(Icons.search, color: CoresApp.primaria),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categorias.length,
                    itemBuilder: (context, i) {
                      bool sel = categoriaSelecionadaModal == _categorias[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_categorias[i], style: TextStyle(fontSize: 11, color: sel ? Colors.white : Colors.black)),
                          selected: sel,
                          selectedColor: CoresApp.primaria,
                          onSelected: (v) => setModalState(() => categoriaSelecionadaModal = _categorias[i]),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 30),

                Expanded(
                  child: materiaisFiltrados.isEmpty // Corrigido de 'filtrados' para 'materiaisFiltrados'
                  ? const Center(child: Text("Nenhum material encontrado."))
                  : ListView(
                    children: agrupados.entries.map((entry) => Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.orange, fontSize: 12)),
                        ),
                        ...entry.value.map((mat) {
                          bool estaMarcado = _selecionadosParaEntrada.any((element) => element.id == mat.id);
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: estaMarcado ? CoresApp.primaria : Colors.grey.withOpacity(0.2)),
                            ),
                            child: CheckboxListTile(
                              activeColor: CoresApp.primaria,
                              // CORREÇÃO AQUI: controlAffinity e ListTileControlAffinity
                              controlAffinity: ListTileControlAffinity.leading, 
                              title: Text(mat.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: estaMarcado 
                                ? _buildContadorModal(mat, setModalState)
                                : Text("SKU: ${mat.sku} | Saldo: ${mat.quantidade.toInt()}"),
                              value: estaMarcado,
                              onChanged: (val) {
                                setModalState(() {
                                  if (val!) {
                                    _selecionadosParaEntrada.add(mat);
                                    _selecionadosQtd[mat.id] = 1;
                                  } else {
                                    _selecionadosParaEntrada.removeWhere((item) => item.id == mat.id);
                                    _selecionadosQtd.remove(mat.id);
                                  }
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    )).toList(),
                  ),
                ),
                
                const SizedBox(height: 10),
                BotaoPadrao(
                  texto: "CONFIRMAR ENTRADA (${_selecionadosParaEntrada.length})",
                  onPressed: _selecionadosParaEntrada.isEmpty ? null : () async {
                    final List<Map<String, dynamic>> payload = _selecionadosParaEntrada.map((m) => {
                      "material_id": m.id,
                      "quantidade": _selecionadosQtd[m.id]
                    }).toList();

                    bool sucesso = await ApiService().registarEntradaRapida(payload);
                    if (sucesso && mounted) {
                      Navigator.pop(context);
                      _buscarDadosDoBanco();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportarDadosCSV() async {
  // Cabeçalho do arquivo
  String csv = "SKU;MATERIAL;CATEGORIA;MARCA;QUANTIDADE;PRECO COMPRA;VALOR TOTAL\n";
  
  for (var m in _materiais) {
    double total = m.quantidade * m.precoCompra;
    csv += "${m.sku};${m.nome};${m.categoria};${m.marca};${m.quantidade};${m.precoCompra} MT;${total.toStringAsFixed(2)} MT\n";
  }

  try {
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/inventario_precos.csv";
    final file = File(path);
    await file.writeAsString(csv);

    // Abre o menu de partilha do telemóvel para enviar por WhatsApp ou Email
    await Share.shareXFiles([XFile(path)], text: 'Exportação de Inventário - African Stock');
  } catch (e) {
    debugPrint("Erro ao exportar: $e");
  }
}
  // --- BUILD PRINCIPAL ---

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      indexAtivo: 1,
      tituloCustom: "Gestão Industrial de Stock",
      acoesAppBar: [
         if (_souAdmin) ...[
        IconButton(icon: const Icon(Icons.category_rounded, color: Colors.orange), onPressed: _abrirModalNovaCategoria),
        IconButton(icon: const Icon(Icons.add_to_photos_rounded, color: Colors.blue), onPressed: _abrirModalNovoCadastro),
        IconButton(icon: const Icon(Icons.file_upload_outlined, color: Colors.green), onPressed: _importarExcel),
      ] ,  
       IconButton(
        icon: const Icon(Icons.download_rounded, color: CoresApp.primaria), 
        onPressed: _exportarDadosCSV, 
        tooltip: "Exportar Tabela de Preços"
      ),],

      body: Column(
        children: [
          _buildBarraBuscaFiltro(isDark),
          _buildChipsCategorias(),
          Expanded(
            child: _carregando 
              ? const Center(child: CircularProgressIndicator()) 
              : _buildTabelaDinamica(isDark),
          ),
          _buildPaginacaoFooter(isDark),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CoresApp.primaria,
        onPressed: _abrirModalEntradaSimples,
        icon: const Icon(Icons.bolt_rounded, color: Colors.white),
        label: const Text("ENTRADA RÁPIDA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- WIDGETS DE UI ---

  Widget _buildBarraBuscaFiltro(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: CardPadrao(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _searchController,
                onChanged: (v) => _buscarDadosDoBanco(),
                decoration: const InputDecoration(
                  hintText: "Procurar Marca, SKU ou Nome...",
                  prefixIcon: Icon(Icons.search, color: CoresApp.primaria),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: CoresApp.primaria.withOpacity(0.1)),
            onPressed: _selecionarIntervaloDatas,
            icon: Icon(Icons.calendar_month_rounded, color: _intervaloDatas != null ? Colors.green : CoresApp.primaria),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsCategorias() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        itemBuilder: (context, i) {
          bool sel = _filtroCategoria == _categorias[i];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(_categorias[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              selected: sel,
              selectedColor: CoresApp.primaria,
              onSelected: (v) {
                setState(() { _filtroCategoria = _categorias[i]; _paginaAtual = 1; });
                _buscarDadosDoBanco();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabelaDinamica(bool isDark) {
    if (_materiais.isEmpty) return const Center(child: Text("Sem registros encontrados no MySQL."));

    return CardPadrao(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        controller: _verticalScroll,
        child: SingleChildScrollView(
          controller: _horizontalScroll,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 35,
            headingRowColor: MaterialStateProperty.all(CoresApp.primaria.withOpacity(0.05)),
            columns: const [
              DataColumn(label: Text("SKU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text("MATERIAL/MARCA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text("STOCK ATUAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text("ACÇÃO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
            rows: _materiais.map((m) => DataRow(
              cells: [
                DataCell(Text(m.sku, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))),
                DataCell(Text(m.nome.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                DataCell(Text("${m.quantidade.toInt()} ${m.unidadeMedida}", 
                  style: TextStyle(fontWeight: FontWeight.w900, color: m.estaBaixo ? Colors.red : CoresApp.primaria))),
                DataCell(IconButton(icon: const Icon(Icons.qr_code_scanner, size: 20), 
                  onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => ModalQrMaterial(material: m)))),
              ]
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginacaoFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
      color: isDark ? CoresApp.cardEscuro : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Pág. $_paginaAtual de $_totalPaginas", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), 
                onPressed: _paginaAtual > 1 ? () { setState(() => _paginaAtual--); _buscarDadosDoBanco(); } : null),
              IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), 
                onPressed: _paginaAtual < _totalPaginas ? () { setState(() => _paginaAtual++); _buscarDadosDoBanco(); } : null),
            ],
          )
        ],
      ),
    );
  }

  // --- HELPERS INTERNOS ---

  Widget _buildField(String label, IconData icon, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdownCategoria(String? atual, Function(String?) mudar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: atual,
          hint: const Text("Selecione a Categoria/Marca"),
          items: _categorias.where((c) => c != "Todos").map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: mudar,
        ),
      ),
    );
  }

  Widget _buildContadorModal(MaterialModel mat, StateSetter setState) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), 
          onPressed: () => setState(() { 
            if(_selecionadosQtd[mat.id]! > 1) _selecionadosQtd[mat.id] = _selecionadosQtd[mat.id]! - 1; 
          })),
        Text("${_selecionadosQtd[mat.id]?.toInt() ?? 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.green), 
          onPressed: () => setState(() { _selecionadosQtd[mat.id] = (_selecionadosQtd[mat.id] ?? 1) + 1; })),
      ],
    );
  }

  Future<void> _importarExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx'], withData: true);
    if (result != null) {
      setState(() => _carregando = true);
      final token = await GestorToken.obterToken();
      var request = http.MultipartRequest('POST', Uri.parse(ConfigApi.importarExcel));
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.files.add(http.MultipartFile.fromBytes('excel', result.files.first.bytes!, filename: result.files.first.name));
      var response = await request.send();
      if (response.statusCode == 200) _buscarDadosDoBanco();
      setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScroll.dispose();
    _verticalScroll.dispose();
    super.dispose();
  }
}