import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/constantes/constantes_rotas.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../../nucleo/servicos/api_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';



const Map<String, Map<String, List<String>>> mocambique = {
  "Maputo Cidade": {
    "Cidade": [
      "KaMpfumo",
      "Nlhamankulu",
      "KaMaxaquene",
      "KaMavota",
      "KaMubukwana",
      "KaTembe",
      "KaNyaka",
    ],
  },

  "Maputo Província": {
    "Cidade": [
      "Boane",
      "Magude",
      "Manhiça",
      "Marracuene",
      "Matola",
      "Matutuíne",
      "Moamba",
      "Namaacha",
    ],
  },

  "Gaza": {
    "Cidade": [
      "Bilene",
      "Chibuto",
      "Chicualacuala",
      "Chigubo",
      "Chókwè",
      "Chongoene",
      "Guijá",
      "Limpopo",
      "Mabalane",
      "Manjacaze",
      "Massangena",
      "Massingir",
      "Xai-Xai",
    ],
  },

  "Inhambane": {
    "Cidade": [
      "Funhalouro",
      "Govuro",
      "Homoíne",
      "Inhambane",
      "Inharrime",
      "Inhassoro",
      "Jangamo",
      "Mabote",
      "Massinga",
      "Maxixe",
      "Morrumbene",
      "Panda",
      "Vilankulo",
      "Zavala",
    ],
  },

  "Sofala": {
    "Cidade": [
      "Beira",
      "Búzi",
      "Caia",
      "Chemba",
      "Cheringoma",
      "Chibabava",
      "Dondo",
      "Gorongosa",
      "Machanga",
      "Maringué",
      "Marromeu",
      "Muanza",
      "Nhamatanda",
    ],
  },

  "Manica": {
    "Cidade": [
      "Bárue",
      "Chimoio",
      "Gondola",
      "Guro",
      "Machaze",
      "Macossa",
      "Manica",
      "Mossurize",
      "Sussundenga",
      "Tambara",
      "Vanduzi",
    ],
  },

  "Tete": {
    "Cidade": [
      "Angónia",
      "Cahora Bassa",
      "Changara",
      "Chifunde",
      "Chiuta",
      "Dôa",
      "Macanga",
      "Magoé",
      "Marara",
      "Moatize",
      "Mutarara",
      "Tete",
      "Tsangano",
      "Zumbo",
    ],
  },

  "Zambézia": {
    "Cidade": [
      "Alto Molócuè",
      "Chinde",
      "Derre",
      "Gilé",
      "Gurué",
      "Ile",
      "Inhassunge",
      "Luabo",
      "Lugela",
      "Maganja da Costa",
      "Milange",
      "Mocuba",
      "Mopeia",
      "Morrumbala",
      "Mulevala",
      "Namacurra",
      "Namarroi",
      "Nicoadala",
      "Pebane",
      "Quelimane",
    ],
  },

  "Nampula": {
    "Cidade": [
      "Angoche",
      "Eráti",
      "Ilha de Moçambique",
      "Lalaua",
      "Larde",
      "Liúpo",
      "Malema",
      "Meconta",
      "Mecubúri",
      "Memba",
      "Mogincual",
      "Mogovolas",
      "Moma",
      "Monapo",
      "Mossuril",
      "Muecate",
      "Murrupula",
      "Nacala-a-Velha",
      "Nacala Porto",
      "Nacarôa",
      "Nampula",
      "Rapale",
      "Ribáuè",
    ],
  },

  "Cabo Delgado": {
    "Cidade": [
      "Ancuabe",
      "Balama",
      "Chiúre",
      "Ibo",
      "Macomia",
      "Mecúfi",
      "Meluco",
      "Metuge",
      "Mocímboa da Praia",
      "Montepuez",
      "Mueda",
      "Muidumbe",
      "Namuno",
      "Nangade",
      "Palma",
      "Pemba",
      "Quissanga",
    ],
  },

  "Niassa": {
    "Cidade": [
      "Chimbonila",
      "Cuamba",
      "Lago",
      "Lichinga",
      "Majune",
      "Mandimba",
      "Marrupa",
      "Maúa",
      "Mavago",
      "Mecanhelas",
      "Mecula",
      "Metarica",
      "Muembe",
      "N'gauma",
      "Nipepe",
      "Sanga",
    ],
  },
};

class TelaHistoricoGeral extends StatefulWidget {
  const TelaHistoricoGeral({super.key});

  @override
  State<TelaHistoricoGeral> createState() => _TelaHistoricoGeralState();
}

class _TelaHistoricoGeralState extends State<TelaHistoricoGeral> {
  // --- ESTADO DE DADOS ---
  List<dynamic> _listaOriginal = []; // Dados brutos do banco
  List<dynamic> _listaExibida = []; // Dados após filtros
  bool _carregando = false;
  String _filtroProvincia = "Todas";
  String _filtroDistrito = "Todos";
  String _filtroLocalidade = "Todas";

  // --- VARIÁVEIS DE FILTRO ---
  String _filtroTipo = "Todos";
  String _filtroResponsavel = "";
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    _buscarDadosIniciais();
  }

  Future<void> _buscarDadosIniciais() async {
    setState(() => _carregando = true);
    try {
      final response = await ApiService().obterHistoricoGeral();
      if (response['sucesso'] && mounted) {
        setState(() {
          _listaOriginal = response['dados'];
          _aplicarFiltros(); // Inicializa a lista exibida
        });
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // --- LÓGICA DE FILTRAGEM COMBINADA ---
  void _aplicarFiltros() {
  setState(() {
    _listaExibida = _listaOriginal.where((mov) {
      // 1. Filtros anteriores (Tipo, Data, Responsável...)
      bool bateTipo = _filtroTipo == "Todos" || mov['tipo'] == _filtroTipo;
      // ... (outros filtros)

      // 2. LOGICA REGIONAL HIERÁRQUICA
      bool bateRegiao = true;
      if (_filtroProvincia != "Todas") {
        // Se filtrei por província, mas não escolhi distrito/localidade específica no BD ainda
        bateRegiao = mov['provincia_nome'] == _filtroProvincia;
        
        // Se quiser ser mais específico (ajuste conforme as colunas do seu banco)
        if (_filtroDistrito != "Todos" && mov['distrito'] != null) {
          bateRegiao = bateRegiao && mov['distrito'] == _filtroDistrito;
        }
      }

      return bateTipo && bateRegiao; 
    }).toList();
  });
}

  // --- MÉTODOS DE SELEÇÃO DE FILTRO ---

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dataSelecionada = picked);
      _aplicarFiltros();
    }
  }

  void _abrirFiltroResponsavel() {
    final ctrl = TextEditingController(text: _filtroResponsavel);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filtrar por Responsável"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: "Nome do funcionário..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _filtroResponsavel = ctrl.text);
              _aplicarFiltros();
              Navigator.pop(context);
            },
            child: const Text("APLICAR"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 2,
      tituloCustom: "Auditoria Industrial",
      body: Column(
        children: [
          _buildBarraFiltrosAtivos(),
          _buildChipsDeAcao(),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _buscarDadosIniciais,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                      itemCount: _listaExibida.length,
                      itemBuilder: (context, index) =>
                          _buildCardDocumento(_listaExibida[index]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CoresApp.primaria,
        onPressed: _gerarRelatorioFiltrado,
        icon: const Icon(Icons.print_rounded, color: Colors.white),
        label: const Text(
          "GERAR RELATÓRIO",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- WIDGETS DE UI ---

  Widget _buildBarraFiltrosAtivos() {
    if (_filtroTipo == "Todos" &&
        _filtroProvincia == "Todas" &&
        _dataSelecionada == null &&
        _filtroResponsavel.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.orange.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          const Text(
            "Filtros Ativos",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _filtroTipo = "Todos";
                _filtroProvincia = "Todas";
                _filtroResponsavel = "";
                _dataSelecionada = null;
              });
              _aplicarFiltros();
            },
            child: const Text(
              "Limpar Tudo",
              style: TextStyle(fontSize: 11, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
 void _abrirSeletorRegional() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("FILTRAR POR REGIÃO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: CoresApp.primaria)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.public, color: Colors.blue),
              title: const Text("Todo o País (Moçambique)", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() { _filtroProvincia = "Todas"; _filtroDistrito = "Todos"; _filtroLocalidade = "Todas"; });
                _aplicarFiltros(); Navigator.pop(context);
              },
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: mocambique.entries.map((prov) => ExpansionTile(
                  title: Text(prov.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: prov.value.entries.map((dist) => ExpansionTile(
                    title: Padding(padding: const EdgeInsets.only(left: 16), child: Text(dist.key)),
                    children: dist.value.map((loc) => ListTile(
                      contentPadding: const EdgeInsets.only(left: 48),
                      title: Text(loc, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      onTap: () {
                        setState(() { _filtroProvincia = prov.key; _filtroDistrito = dist.key; _filtroLocalidade = loc; });
                        _aplicarFiltros(); Navigator.pop(context);
                      },
                    )).toList(),
                  )).toList(),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildChipsDeAcao() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          _chipFiltro(
            "Data: ${_dataSelecionada == null ? 'Sempre' : DateFormat('dd/MM').format(_dataSelecionada!)}",
            Icons.calendar_today,
            _selecionarData,
          ),
          _chipFiltro("Tipo: $_filtroTipo", Icons.swap_vert, _mudarTipo),
          _chipFiltro(
             _filtroProvincia == "Todas" 
              ? "Região: Moçambique" 
               : "${_filtroProvincia} > ${_filtroDistrito}", 
              Icons.location_on, 
              _abrirSeletorRegional
              ),
          _chipFiltro(
            "Responsável: ${_filtroResponsavel.isEmpty ? 'Todos' : _filtroResponsavel}",
            Icons.person,
            _abrirFiltroResponsavel,
          ),
        ],
      ),
    );
  }

  Widget _chipFiltro(String label, IconData icon, VoidCallback action) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: action,
        avatar: Icon(icon, size: 14, color: CoresApp.primaria),
        label: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- ALTERNAR ESTADOS ---
  void _mudarTipo() {
    setState(() {
      if (_filtroTipo == "Todos")
        _filtroTipo = "ENTRADA";
      else if (_filtroTipo == "ENTRADA")
        _filtroTipo = "SAÍDA";
      else
        _filtroTipo = "Todos";
    });
    _aplicarFiltros();
  }

  void _mudarProvincia() {
    // Aqui você poderia abrir um Modal com a lista real de províncias
    List<String> provs = ["Todas", "Maputo", "Gaza", "Beira", "Tete"];
    int index = provs.indexOf(_filtroProvincia);
    setState(() => _filtroProvincia = provs[(index + 1) % provs.length]);
    _aplicarFiltros();
  }

  Widget _buildCardDocumento(Map<String, dynamic> mov) {
    bool isEntrada = mov['tipo'] == 'ENTRADA';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        onTap: () => Navigator.pushNamed(
          context,
          RotasApp.visualizarPdf,
          arguments: mov,
        ),
        child: ListTile(
          leading: Icon(
            isEntrada ? Icons.add_circle : Icons.remove_circle,
            color: isEntrada ? const Color.fromARGB(255, 48, 122, 144) : Colors.red,
          ),
          title: Text(
            mov['codigo_guia'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${mov['material_nome']} - ${mov['funcionario_nome']}",
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${mov['quantidade']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat(
                  'dd/MM',
                ).format(DateTime.parse(mov['data_movimento'])),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- RELATÓRIO PDF/CSV ---
 Future<void> _gerarRelatorioFiltrado() async {
  // 1. Validar se há dados
  if (_listaExibida.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Não há dados filtrados para exportar.")),
    );
    return;
  }

  try {
    // 2. Criar o conteúdo do CSV (Separado por ponto e vírgula para abrir direto no Excel)
    String csv = "RELATORIO DE AUDITORIA - AFRICAN STOCK\n";
    csv += "Exportado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}\n";
    csv += "Filtros aplicados: Tipo=$_filtroTipo | Regiao=$_filtroProvincia\n\n";
    
    // Cabeçalhos
    csv += "DATA;GUIA;TIPO;MATERIAL;QTD;RESPONSAVEL;PROVINCIA\n";

    // Linhas de dados
    for (var m in _listaExibida) {
      String dataFormatada = "";
      try {
        dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(m['data_movimento']));
      } catch (e) {
        dataFormatada = m['data_movimento'].toString();
      }

      csv += "$dataFormatada;";
      csv += "${m['codigo_guia']};";
      csv += "${m['tipo']};";
      csv += "${m['material_nome']};";
      csv += "${m['quantidade']};";
      csv += "${m['funcionario_nome']};";
      csv += "${m['provincia_nome']}\n";
    }

    // 3. Obter diretório temporário e salvar o ficheiro
    final directory = await getTemporaryDirectory();
    final String fileName = "Relatorio_Stock_${DateTime.now().millisecondsSinceEpoch}.csv";
    final File file = File('${directory.path}/$fileName');
    
    await file.writeAsString(csv);

    // 4. Abrir o menu de partilha nativo do telemóvel
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Relatório de Auditoria de Stock - African Stock',
      subject: 'Exportação de Dados Inventário',
    );

  } catch (e) {
    debugPrint("Erro ao exportar relatório: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao gerar o ficheiro."), backgroundColor: Colors.red),
      );
    }
  }
}
}
