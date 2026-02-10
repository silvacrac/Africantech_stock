import 'package:flutter/material.dart';
import '../constantes/constantes_cores.dart';

class BotaoPadrao extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool carregando;
  final IconData? icone;
  final bool outlined;

  const BotaoPadrao({
    super.key,
    required this.texto,
    this.onPressed,
    this.carregando = false,
    this.icone,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: outlined
          ? OutlinedButton(
              onPressed: carregando ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: CoresApp.primaria, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _buildConteudo(),
            )
          : ElevatedButton(
              onPressed: carregando ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primaria,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _buildConteudo(),
            ),
    );
  }

  Widget _buildConteudo() {
    if (carregando) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icone != null) ...[Icon(icone), const SizedBox(width: 10)],
        Text(texto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}