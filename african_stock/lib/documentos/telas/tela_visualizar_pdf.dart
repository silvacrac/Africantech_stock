import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';

class TelaVisualizarPdf extends StatelessWidget {
  const TelaVisualizarPdf({super.key});

  @override
  Widget build(BuildContext context) {
    // CAPTURA OS DADOS ENVIADOS PELA TELA DE HISTÓRICO
    final Map<String, dynamic> mov = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    bool isEntrada = mov['tipo'] == 'ENTRADA';
    DateTime data = DateTime.parse(mov['data_movimento']);

    return Scaffold(
      appBar: BarraSuperior(titulo: "Detalhes: ${mov['codigo_guia']}"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEntrada ? "NOTA DE ENTRADA" : "GUIA DE SAÍDA",
              style: TextStyle(
                color: isEntrada ? Colors.green : CoresApp.erro,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mov['codigo_guia'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(
                  isEntrada ? Icons.login_rounded : Icons.logout_rounded,
                  size: 40,
                  color: (isEntrada ? Colors.green : CoresApp.erro).withOpacity(0.2),
                ),
              ],
            ),
            const Text(
              "Registro auditado via Sistema Industrial v1.0",
              style: TextStyle(color: CoresApp.textoSecundario, fontSize: 12),
            ),
            const SizedBox(height: 32),

            _buildSecaoInfo("RESUMO DO MOVIMENTO", [
              _itemInfo(Icons.category, "Material", mov['material_nome'], null),
              _itemInfo(Icons.layers, "Quantidade", "${mov['quantidade']} ${mov['unidade_medida'] ?? 'Un'}", CoresApp.primaria),
              _itemInfo(Icons.map, "Província", mov['provincia_nome'], null),
              if (mov['projeto_nome'] != null)
                _itemInfo(Icons.location_on, "Projeto/Obra", mov['projeto_nome'], null),
              _itemInfo(Icons.person, "Responsável", mov['funcionario_nome'], null),
              _itemInfo(Icons.schedule, "Data e Hora", DateFormat('dd MMM, yyyy HH:mm').format(data), null),
            ]),

            const SizedBox(height: 40),
            // OBS: Futuramente você pode gerar um PDF real aqui
            BotaoPadrao(
              texto: "Imprimir Guia (PDF)",
              icone: Icons.picture_as_pdf,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gerando PDF...")));
              },
            ),
            const SizedBox(height: 12),
            BotaoPadrao(
              texto: "Partilhar Detalhes",
              icone: Icons.share,
              outlined: true,
              onPressed: () {
                // Lógica de partilha de texto
              },
            ),
          ],
        ),
      ),
    );
  }

  // ... (Mantenha os métodos _buildSecaoInfo e _itemInfo que você já tem)
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

