import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../modelos/funcionario.dart';

class TelaListaFuncionarios extends StatefulWidget {
  const TelaListaFuncionarios({super.key});

  @override
  State<TelaListaFuncionarios> createState() => _TelaListaFuncionariosState();
}

class _TelaListaFuncionariosState extends State<TelaListaFuncionarios> {
 final List<Funcionario> _funcionarios = [
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
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 3, // Podemos ligar ao botão CONFIG ou criar um novo acesso
      tituloCustom: "Gestão de Equipas",
      body: Column(
        children: [
          _buildBarraBuscaFiltro(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              itemCount: _funcionarios.length,
              itemBuilder: (context, index) => _buildCardFuncionario(_funcionarios[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CoresApp.primaria,
        onPressed: () {}, // Abrir formulário de cadastro de funcionário
        child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildBarraBuscaFiltro() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Procurar funcionário...",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: CoresApp.primaria, borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.filter_list, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildCardFuncionario(Funcionario f) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // AVATAR COM STATUS
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: CoresApp.primaria.withOpacity(0.1),
                  child: Text(f.nome[0], style: const TextStyle(fontWeight: FontWeight.bold, color: CoresApp.primaria, fontSize: 20)),
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: f.estaDisponivel ? CoresApp.sucesso : CoresApp.alerta,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            // INFO DO FUNCIONÁRIO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(f.funcao, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(f.provincia, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined, color: CoresApp.primaria, size: 20),
              onPressed: () {},
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
          ],
        ),
      ),
    );
  }
}