import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/constantes/constantes_rotas.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';

class TelaHistoricoGeral extends StatefulWidget {
  const TelaHistoricoGeral({super.key});

  @override
  State<TelaHistoricoGeral> createState() => _TelaHistoricoGeralState();
}

class _TelaHistoricoGeralState extends State<TelaHistoricoGeral> {
  final ScrollController _scrollController = ScrollController();
  
  // Estado da Lista e Paginação
  List<Map<String, dynamic>> _guiasExibidas = [];
  bool _carregandoMais = false;
  int _paginaAtual = 0;
  final int _itensPorPagina = 10;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();

    // Listener para Paginação (Infinite Scroll)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _carregarMaisGuias();
      }
    });
  }

  void _carregarDadosIniciais() {
    setState(() {
      _guiasExibidas = _gerarMockGuias(0, _itensPorPagina);
    });
  }

  Future<void> _carregarMaisGuias() async {
    if (_carregandoMais) return;
    setState(() => _carregandoMais = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulação de API

    _paginaAtual++;
    final novasGuias = _gerarMockGuias(_paginaAtual * _itensPorPagina, _itensPorPagina);

    setState(() {
      _guiasExibidas.addAll(novasGuias);
      _carregandoMais = false;
    });
  }

  // Gerador de documentos fictícios (Audit Log focado em PDFs)
  List<Map<String, dynamic>> _gerarMockGuias(int inicio, int quantidade) {
    return List.generate(quantidade, (i) {
      int index = inicio + i;
      bool isEntrada = index % 2 == 0;
      return {
        "id": "DOC-2024-${1000 + index}",
        "tipo": isEntrada ? "NOTA DE ENTRADA" : "GUIA DE SAÍDA",
        "responsavel": "Alex Johnson",
        "data": DateTime.now().subtract(const Duration(hours: 2)),
        "provincia": index % 3 == 0 ? "Maputo" : "Gaza",
        "cor": isEntrada ? const Color(0xFF10B981) : const Color(0xFFEF4444),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      indexAtivo: 2, // Ativa ícone HISTÓRICO na barra inferior
      tituloCustom: "Registro de Documentos",
      body: Column(
        children: [
          // 1. FILTROS RÁPIDOS (Data, Província, Tipo)
          _buildBarraFiltros(),

          // 2. LISTAGEM DE DOCUMENTOS
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              physics: const BouncingScrollPhysics(),
              itemCount: _guiasExibidas.length + (_carregandoMais ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _guiasExibidas.length) {
                  return _buildCardDocumento(_guiasExibidas[index], isDark);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
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

  Widget _buildBarraFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          _botaoFiltro("Hoje", Icons.today_rounded),
          _botaoFiltro("Província", Icons.map_outlined),
          _botaoFiltro("Tipo de Guia", Icons.filter_list_rounded),
          _botaoFiltro("Responsável", Icons.person_search_outlined),
        ],
      ),
    );
  }

  Widget _botaoFiltro(String label, IconData icone) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ActionChip(
        onPressed: () {},
        avatar: Icon(icone, size: 16, color: CoresApp.primaria),
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: CoresApp.bordaClaro.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildCardDocumento(Map<String, dynamic> guia, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        onTap: () => Navigator.pushNamed(context, RotasApp.visualizarPdf, arguments: guia['id']),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ÍCONE DE PDF ESTILIZADO
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: guia['cor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.picture_as_pdf_rounded, color: guia['cor'], size: 28),
            ),
            const SizedBox(width: 16),
            
            // INFORMAÇÕES DA GUIA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guia['tipo'], 
                    style: TextStyle(color: guia['cor'], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    guia['id'], 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        guia['responsavel'], 
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        guia['provincia'], 
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // DATA E SETA
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('HH:mm').format(guia['data']), 
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))
                ),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFE2E8F0)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}