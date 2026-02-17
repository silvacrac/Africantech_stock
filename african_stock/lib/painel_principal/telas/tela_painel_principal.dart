import 'dart:async';
import 'package:african_stock/autenticacao/Controllers/controlador_autenticacao.dart';
import 'package:african_stock/nucleo/componentes/base_scaffold.dart';
import 'package:african_stock/nucleo/constantes/constantes_rotas.dart';
import 'package:african_stock/nucleo/controladores/controlador_utilizador.dart';
import 'package:african_stock/nucleo/servicos/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../controladores/controlador_painel.dart';

class TelaPainelPrincipal extends StatefulWidget {
  const TelaPainelPrincipal({super.key});

  @override
  State<TelaPainelPrincipal> createState() => _TelaPainelPrincipalState();
}

class _TelaPainelPrincipalState extends State<TelaPainelPrincipal> {
  final _controlador = ControladorPainel();
  
  
  // Lógica de Visibilidade e Admin
  bool _mostrarValor = false; // Valor inicial oculto por segurança

// Função auxiliar para verificar permissão
  bool get _souAdmin => ControladorAutenticacao.instancia.funcionarioLogado?.isAdmin ?? false;

  // Lógica do Slideshow
  final PageController _pageController = PageController();
  int _paginaAtual = 0;
  late Timer _timer;

  double _valorTotalReal = 0.0;
  List<dynamic> _movimentosReais = [];
  bool _carregandoPainel = true;
  int _notificacoesCount = 0;

  
 

 


  @override
  void initState() {
    super.initState();
      _inicializarPainel();
    // Inicia a rotação automática do carrossel de anúncios
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_paginaAtual < 2) {
        _paginaAtual++;
      } else {
        _paginaAtual = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _paginaAtual,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

Future<void> _inicializarPainel() async {
    setState(() => _carregandoPainel = true);
    final dados = await ApiService().obterDadosDashboard();
    
    if (dados['sucesso'] == true) {
      setState(() {
        _valorTotalReal = double.tryParse(dados['valor_total'].toString()) ?? 0.0;
        _movimentosReais = dados['movimentos'] ?? [];
        _carregandoPainel = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 0,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SLIDESHOW DE ANÚNCIOS (Topo)
            _buildSlideshow(),
            const SizedBox(height: 24),

            // 2. CARD DE VALOR TOTAL (Com Toggle para Admin)
            _buildCardValorTotal(),
            const SizedBox(height: 32),

            // 3. SEÇÃO DE AÇÕES RÁPIDAS
            _buildSecaoTitulo("AÇÕES RÁPIDAS"),
            _buildGridAcoes(),
            const SizedBox(height: 32),

            // 4. ACTIVIDADE RECENTE (Foco em Guias/PDFs)
            _buildSecaoAtividadeRecente(),
            
            // Espaço de segurança para a navegação flutuante
            const SizedBox(height: 140), 
          ],
        ),
      ),
    );
  }

  // APPBAR: PERFIL(E) | LOGO(C) | NOTIFICAÇÕES(D)
PreferredSizeWidget _buildAppBar() {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final funcionario = ControladorAutenticacao.instancia.funcionarioLogado;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leadingWidth: 70,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
      child: ValueListenableBuilder(
        valueListenable: fotoPerfilGlobal,
        builder: (context, foto, _) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, RotasApp.perfil),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: CoresApp.primaria, width: 1.5),
                color: CoresApp.primaria.withOpacity(0.1),
              ),
              child: ClipOval(
                child: foto != null 
                    ? Image.file(foto, fit: BoxFit.cover)
                    : Icon(Icons.person, color: isDark ? Colors.white : CoresApp.primaria, size: 20),
              ),
            ),
          );
        },
      ),
    ),
    title: SizedBox(
      height: 35,
      child: Image.asset('assets/imagens/logo.png', fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2, color: CoresApp.primaria)),
    ),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(funcionario?.nome.split(" ").first ?? "User", 
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : CoresApp.textoClaroPrincipal)),
          Text(funcionario?.provincia ?? "", 
            style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(Icons.notifications_none_rounded),
        onPressed: () => Navigator.pushNamed(context, RotasApp.notificacoes),
      ),
      const SizedBox(width: 12),
    ],
  );
}

  Widget _buildSlideshow() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _paginaAtual = i),
            children: [
              _buildSlideItem("Expansão Logística", "Fase 3 do armazém Maputo operacional.", "assets/imagens/slide1.jpg"),
              _buildSlideItem("Segurança", "Uso obrigatório de EPI no recinto.", "assets/imagens/slide2.jpg"),
              _buildSlideItem("Novo Inventário", "Recebemos stock de materiais elétricos.", "assets/imagens/slide3.jpg"),
            ],
          ),
          // Indicadores de Página (Dots)
          Positioned(
            bottom: 20, left: 20,
            child: Row(
              children: List.generate(3, (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 4, width: _paginaAtual == index ? 24 : 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_paginaAtual == index ? 1 : 0.4), 
                  borderRadius: BorderRadius.circular(2)
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSlideItem(String titulo, String sub, String imgPath) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: CoresApp.primaria),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Image.asset(
              imgPath, fit: BoxFit.cover, width: double.infinity, height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [CoresApp.primaria, Color(0xFF007AFF)])),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCardValorTotal() {
  final formatar = NumberFormat.currency(symbol: "MT ", decimalDigits: 2);
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [CoresApp.primaria, Color(0xFF007AFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [BoxShadow(color: CoresApp.primaria.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Valor Total do Stock", style: TextStyle(color: Colors.white70, fontSize: 14)),
            
            if (_souAdmin) 
              IconButton(
                icon: Icon(_mostrarValor ? Icons.visibility : Icons.visibility_off, color: Colors.white, size: 20),
                onPressed: () => setState(() => _mostrarValor = !_mostrarValor),
              )
            else
              const Icon(Icons.lock_outline, color: Colors.white38, size: 18),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              _souAdmin 
                ? (_mostrarValor ? formatar.format(_valorTotalReal) : "MT ••••••••")
                : "ACESSO RESTRITO", 
              style: TextStyle(
                color: Colors.white, 
                fontSize: _souAdmin ? 28 : 20, 
                fontWeight: FontWeight.bold
              )
            ),
            if (_souAdmin) const SizedBox(width: 8),
            if (_souAdmin) const Text("MZN", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMiniInfo(Icons.trending_up, "Crescimento", "+12.4%"),
            _buildMiniInfo(Icons.inventory_2, "Itens Totais", "14,203"),
          ],
        )
      ],
    ),
  );
}
  
  
Widget _buildMiniInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }








  Widget _buildGridAcoes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        children:[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          _buildBotoesQuadrados("Registar Entrada", Icons.add_box, RotasApp.listaMateriais),
          _buildBotoesQuadrados("Saída", Icons.outbox, RotasApp.registarSaida),
          _buildBotoesQuadrados("Transferir", Icons.swap_horiz, RotasApp.transferirStock),
          _buildBotoesQuadrados("Histórico", Icons.history, RotasApp.historicoGeral),
          
           ],),
           const SizedBox(height: 20),
       Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          _buildBotoesQuadrados("Equipas", Icons.groups_rounded, RotasApp.equipas),
          _buildBotoesQuadrados("Locais", Icons.map_rounded, RotasApp.provincias),
          
          _buildBotoesQuadrados("Gestão de Trabalhos", Icons.work, RotasApp.projetos),
           
          _buildBotoesQuadrados("Agenda", Icons.calendar_today_rounded, RotasApp.agenda),
          if (_souAdmin) // <--- Regra de segurança: só o Admin vê isto
  _buildBotoesQuadrados(
    "Relatórios", 
    Icons.analytics_rounded, 
    RotasApp.relatoriosAdmin
  ),
           ],
      ),

        ]
      )
    );
  }


  Widget _buildBotoesQuadrados(String label, IconData icon, String rota) {
    return Column(
      children: [
        CardPadrao(
          onTap: () => Navigator.pushNamed(context, rota),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: CoresApp.primaria, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label.split(" ").last, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSecaoAtividadeRecente() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSecaoTitulo("ACTIVIDADE RECENTE"),
          CardPadrao(
            padding: EdgeInsets.zero,
            child: _carregandoPainel 
              ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _movimentosReais.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final mov = _movimentosReais[index];
                    bool isEntrada = mov['tipo'] == 'ENTRADA';
                    
                    return ListTile(
                      onTap: () => Navigator.pushNamed(context, RotasApp.visualizarPdf, arguments: mov),
                      leading: CircleAvatar(
                        backgroundColor: isEntrada ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        child: Icon(isEntrada ? Icons.add : Icons.remove, size: 18, color: isEntrada ? Colors.green : Colors.red),
                      ),
                      title: Text(mov['item'] ?? "Material", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text("Guia: ${mov['codigo_guia']}", style: const TextStyle(fontSize: 11)),
                      trailing: Text(
                        "${mov['quantidade']}", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: isEntrada ? Colors.green : Colors.red)
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoTitulo(String t) => Padding(padding: const EdgeInsets.only(left: 20, bottom: 12), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.2)));
}