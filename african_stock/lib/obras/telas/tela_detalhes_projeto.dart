import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../modelos/projeto.dart';
import '../modelos/funcionario.dart';

class TelaDetalhesProjeto extends StatelessWidget {
  final Projeto projeto;

  const TelaDetalhesProjeto({super.key, required this.projeto});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock da equipa alocada para este projeto
 final List<Funcionario> equipaAlocada = [
  Funcionario(
      id: 'F1', 
      nome: "Ricardo Matsinhe", 
      email: "ricardo@africantech.co.mz",
      funcao: "Supervisor", 
      provincia: "Maputo", 
      tipo: TipoAcesso.admin, // Nível Admin
      telefone: "841234567", 
      disponivel: false,
    ),
    Funcionario(
      id: 'F2', 
      nome: "Artur Chilaule", 
      email: "artur@africantech.co.mz",
      funcao: "Técnico Elétrico", 
      provincia: "Gaza", 
      tipo: TipoAcesso.operacional, // Nível Operacional
      telefone: "829876543",
      disponivel: true,
    ),
    Funcionario(
      id: 'F3', 
      nome: "Simão Pedro", 
      email: "simao@africantech.co.mz",
      funcao: "Motorista Pesados", 
      provincia: "Maputo", 
      tipo: TipoAcesso.operacional, 
      telefone: "855554444",
      disponivel: true,
    ),
    Funcionario(
      id: 'F4', 
      nome: "Benilde Mabunda", 
      email: "benilde@africantech.co.mz",
      funcao: "Engenheira Civil", 
      provincia: "Inhambane", 
      tipo: TipoAcesso.operacional, 
      telefone: "870001122",
      disponivel: true,
    ),
];


    return Scaffold(
      appBar: const BarraSuperior(titulo: "Detalhes do Trabalho"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER DO PROJETO
            _buildHeader(projeto, isDark),
            const SizedBox(height: 24),

            // 2. PROGRESSO
            _buildSecaoTitulo("PROGRESSO ACTUAL"),
            _buildCardProgresso(projeto),
            const SizedBox(height: 24),

            // 3. EQUIPA RESPONSÁVEL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSecaoTitulo("EQUIPA NO LOCAL"),
                TextButton(onPressed: () {}, child: const Text("Gerir", style: TextStyle(fontSize: 12))),
              ],
            ),
            _buildListaEquipa(equipaAlocada),
            const SizedBox(height: 24),

            // 4. MATERIAIS ASSOCIADOS
            _buildSecaoTitulo("MATERIAIS REQUISITADOS"),
            _buildCardMateriais(),
            const SizedBox(height: 40),

            // 5. AÇÕES DE GESTÃO
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CoresApp.primaria,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () {},
                    child: const Text("Actualizar Status", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Projeto p, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.cliente.toUpperCase(), style: const TextStyle(color: CoresApp.primaria, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(p.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text("${p.localizacao} • Início: ${p.dataInicio.day}/${p.dataInicio.month}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildCardProgresso(Projeto p) {
    return CardPadrao(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${(p.progresso * 100).toInt()}% Concluído", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Icon(Icons.trending_up, color: CoresApp.sucesso, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: p.progresso,
              minHeight: 10,
              backgroundColor: CoresApp.primaria.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(CoresApp.primaria),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaEquipa(List<Funcionario> funcionarios) {
    return Column(
      children: funcionarios.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CardPadrao(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: CoresApp.primaria.withOpacity(0.1),
                child: Text(f.nome[0], style: const TextStyle(color: CoresApp.primaria, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(f.funcao, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chat_bubble_outline, size: 18, color: CoresApp.primaria),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCardMateriais() {
    return CardPadrao(
      child: Column(
        children: [
          _materialItem("Cabo de Alumínio 50mm", "200 metros"),
          const Divider(),
          _materialItem("Isoladores de Porcelana", "12 unidades"),
          const Divider(),
          _materialItem("Transformador 100KVA", "1 unidade"),
        ],
      ),
    );
  }

  Widget _materialItem(String nome, String qtd) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(qtd, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CoresApp.primaria)),
        ],
      ),
    );
  }

  Widget _buildSecaoTitulo(String t) => Padding(padding: const EdgeInsets.only(bottom: 12, top: 8), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)));
}