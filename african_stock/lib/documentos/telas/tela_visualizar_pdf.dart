import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';

class TelaVisualizarPdf extends StatelessWidget {
  const TelaVisualizarPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Detalhes do Movimento"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SAÍDA DE INVENTÁRIO",
              style: TextStyle(
                color: CoresApp.primaria,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "#MV-88291",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
                Icon(
                  Icons.inventory_2_rounded,
                  size: 40,
                  color: CoresApp.primaria.withOpacity(0.2),
                ),
              ],
            ),
            const Text(
              "Processado via Hub Logístico v4.2",
              style: TextStyle(color: CoresApp.textoSecundario, fontSize: 12),
            ),
            const SizedBox(height: 32),

            _buildSecaoInfo("INFORMAÇÃO DA TRANSACÇÃO", [
              _itemInfo(Icons.logout, "Tipo", "Saída", CoresApp.erro),
              _itemInfo(
                Icons.architecture,
                "Material",
                "Varão de Aço 12mm",
                null,
              ),
              _itemInfo(
                Icons.layers,
                "Quantidade",
                "1.250 Unidades",
                CoresApp.primaria,
              ),
              _itemInfo(Icons.map, "Província", "Gaza", null),
              _itemInfo(Icons.location_on, "Obra", "Ponte Limpopo B", null),
              _itemInfo(Icons.person, "Responsável", "Alex Johnson", null),
              _itemInfo(
                Icons.schedule,
                "Data/Hora",
                "24 Out, 2023 14:30",
                null,
              ),
            ]),

            const SizedBox(height: 40),
            BotaoPadrao(
              texto: "Abrir Documento PDF",
              icone: Icons.picture_as_pdf,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            BotaoPadrao(
              texto: "Partilhar PDF",
              icone: Icons.share,
              outlined: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoInfo(String titulo, List<Widget> itens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: CoresApp.textoSecundario,
          ),
        ),
        const SizedBox(height: 12),
        CardPadrao(
          padding: EdgeInsets.zero,
          child: Column(children: itens),
        ),
      ],
    );
  }

  Widget _itemInfo(IconData icon, String label, String valor, Color? corValor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CoresApp.borda.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CoresApp.textoSecundario),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: CoresApp.textoSecundario,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            valor,
            style: TextStyle(fontWeight: FontWeight.bold, color: corValor),
          ),
        ],
      ),
    );
  }
}
