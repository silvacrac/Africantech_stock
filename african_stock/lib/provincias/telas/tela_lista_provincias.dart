import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';
import '../modelos/provincia.dart';

class TelaListaProvincias extends StatefulWidget {
  const TelaListaProvincias({super.key});

  @override
  State<TelaListaProvincias> createState() => _TelaListaProvinciasState();
}

class _TelaListaProvinciasState extends State<TelaListaProvincias> {
  // Mock de dados provinciais
  final List<ProvinciaModel> _provincias = [
    ProvinciaModel(
      id: '1', nome: "Maputo", codigo: "MPM", 
      totalArmazens: 3, totalEquipas: 12, valorTotalStock: 1250000
    ),
    ProvinciaModel(
      id: '2', nome: "Gaza", codigo: "GZA", 
      totalArmazens: 1, totalEquipas: 4, valorTotalStock: 450000
    ),
    ProvinciaModel(
      id: '3', nome: "Inhambane", codigo: "INH", 
      totalArmazens: 2, totalEquipas: 6, valorTotalStock: 750000
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      indexAtivo: 3, // Lincado ao menu CONFIG ou gestão
      tituloCustom: "Gestão de Locais",
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        itemCount: _provincias.length,
        itemBuilder: (context, index) => _buildCardProvincia(_provincias[index]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CoresApp.primaria,
        onPressed: () {}, // Adicionar nova província ou armazém
        child: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildCardProvincia(ProvinciaModel provincia) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CardPadrao(
        padding: EdgeInsets.zero,
        onTap: () {
          // Navegar para detalhes da província (Armazéns/Equipas locais)
        },
        child: Column(
          children: [
            // Header do Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: CoresApp.primaria.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(provincia.codigo, 
                        style: const TextStyle(color: CoresApp.primaria, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provincia.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Moçambique", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
                ],
              ),
            ),
            const Divider(height: 1),
            // Indicadores Rápidos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStat(Icons.warehouse_outlined, "${provincia.totalArmazens}", "Armazéns"),
                  _buildMiniStat(Icons.people_outline, "${provincia.totalEquipas}", "Equipas"),
                  _buildMiniStat(Icons.payments_outlined, "MT ${(provincia.valorTotalStock/1000).toStringAsFixed(0)}k", "Valor Stock"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: CoresApp.primaria),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}