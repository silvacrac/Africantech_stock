import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../modelos/transferencia_stock.dart';

class TelaDetalhesTransferencia extends StatelessWidget {
  final TransferenciaStock transferencia;

  const TelaDetalhesTransferencia({super.key, required this.transferencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Detalhes do Recebimento"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.local_shipping_rounded, size: 64, color: CoresApp.primaria),
            const SizedBox(height: 16),
            Text(transferencia.numeroDocumento, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 32),
            
            CardPadrao(
              child: Column(
                children: [
                  _buildLinhaDetalhe("Material", transferencia.materialNome),
                  const Divider(height: 32),
                  _buildLinhaDetalhe("Quantidade", "${transferencia.quantidade} Unidades"),
                  const Divider(height: 32),
                  _buildLinhaDetalhe("Origem", transferencia.origemTipo),
                  const Divider(height: 32),
                  _buildLinhaDetalhe("Enviado por", transferencia.responsavelOrigem),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            BotaoPadrao(
              texto: "Confirmar Recebimento",
              icone: Icons.verified,
              onPressed: () {
                _mostrarDialogoConfirmacao(context);
              },
            ),
            const SizedBox(height: 12),
            BotaoPadrao(
              texto: "Reportar Problema",
              outlined: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinhaDetalhe(String label, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: CoresApp.textoSecundario, fontWeight: FontWeight.w600)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _mostrarDialogoConfirmacao(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Confirmar Entrada"),
        content: const Text("Ao confirmar, a quantidade será adicionada ao stock da sua província. Esta ação é irreversível."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(c);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: CoresApp.sucesso, content: Text("Stock atualizado com sucesso!"))
              );
            },
            child: const Text("Confirmar"),
          )
        ],
      ),
    );
  }
}